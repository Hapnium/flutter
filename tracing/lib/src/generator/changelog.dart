import 'dart:io';

void main(List<String> args) {
  generateChangelog(args);
}

void generateChangelog(List<String> args) {
  final baseCommit = args.isNotEmpty ? args[0] : 'HEAD~1';
  final headCommit = args.length > 1 ? args[1] : 'HEAD';

  final changelog = Changelog();

  // Get the changes
  final changes = getGitDiff(baseCommit, headCommit);
  for (var change in changes) {
    final parts = change.split('\t');
    if (parts.length == 2) {
      final status = parts[0];
      final file = parts[1];
      switch (status) {
        case 'A':
          changelog.added.add(file);
          break;
        case 'M':
          changelog.modified.add(file);
          break;
        case 'D':
          changelog.deleted.add(file);
          break;
      }
    }
  }

  // Prepare changelog content
  final changelogContent = prepareChangelogContent(
    changelog,
    getCommitMessages(baseCommit, headCommit),
    getVersionFromPubspec(),
  );

  // Write to CHANGELOG.md
  writeChangelogToFile(changelogContent, getVersionFromPubspec());
}

List<String> getGitDiff(String baseCommit, String headCommit) {
  return executeGitCommand('git diff --name-status $baseCommit $headCommit');
}

String getCommitMessages(String baseCommit, String headCommit) {
  final messages = executeGitCommand(
      'git log --oneline $baseCommit..$headCommit');
  return messages.join('\n');
}

String getVersionFromPubspec() {
  // Read the version from pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    final lines = pubspecFile.readAsLinesSync();
    for (var line in lines) {
      if (line.startsWith('version:')) {
        return line
            .split(':')
            .last
            .trim();
      }
    }
  }
  return 'unknown';
}

List<String> executeGitCommand(String command) {
  final parts = command.split(' ');
  final result = Process.runSync(parts[0], parts.sublist(1));
  if (result.exitCode == 0) {
    return result.stdout.toString().split('\n')
        .where((line) => line.isNotEmpty)
        .toList();
  } else {
    print('Error executing command: ${result.stderr}');
    return [];
  }
}

String prepareChangelogContent(Changelog changelog, String commitMessages, String version) {
  final buffer = StringBuffer();
  buffer.writeln('# Changelog\n');
  buffer.writeln('Version: **$version**\n');
  buffer.writeln(
      'All notable changes to this project will be documented in this file.\n');
  buffer.writeln('## [Unreleased]\n');

  // Commit messages section
  if (commitMessages.isNotEmpty) {
    buffer.writeln('### ✍️ Commit Messages\n');
    for (var message in commitMessages.split('\n')) {
      buffer.writeln('* $message');
    }
    buffer.writeln('');
  }

  // Added section
  if (changelog.added.isNotEmpty) {
    buffer.writeln('### ✨ Added\n');
    for (var file in changelog.added) {
      buffer.writeln('* `$file` - New functionality or features introduced.');
    }
    buffer.writeln('');
  }

  // Modified section
  if (changelog.modified.isNotEmpty) {
    buffer.writeln('### 🛠️ Modified\n');
    for (var file in changelog.modified) {
      buffer.writeln(
          '* `$file` - Updated to improve functionality or fix issues.');
    }
    buffer.writeln('');
  }

  // Deleted section
  if (changelog.deleted.isNotEmpty) {
    buffer.writeln('### ❌ Deleted\n');
    for (var file in changelog.deleted) {
      buffer.writeln('* `$file` - Removed as it was no longer needed.');
    }
    buffer.writeln('');
  }

  return '${buffer.toString().trim()}\n';
}

void writeChangelogToFile(String content, String version) {
  final changesDir = Directory('changes');
  if (!changesDir.existsSync()) {
    changesDir.createSync();
  }

  final changelogFile = File('changes/CHANGELOG-$version.md');
  changelogFile.writeAsStringSync(content);
  print('CHANGELOG-$version.md has been updated successfully!');
}

class Changelog {
  final List<String> added = [];
  final List<String> modified = [];
  final List<String> deleted = [];
}