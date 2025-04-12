part of 'smart_poll.dart';

/// Provides a default configuration for a SmartPollOption.
/// This getter returns a default [SmartPollOptionConfig] instance
/// with default values for all properties. This can be used as
/// a starting point for creating custom configurations.
SmartPollOptionConfig _default = SmartPollOptionConfig();

class _SmartPollState<T> extends State<SmartPoll<T>> {
  int _totalVotes = 0;
  bool _hasPollEnded = false;
  bool _userHasVoted = false;
  bool _isLoading = false;
  SmartPollOption? _votedOption;
  List<SmartPollOption> _options = [];

  @override
  void initState() {
    _init();

    super.initState();
  }

  void _init() {
    setState(() {
      _options = widget.options;
      _totalVotes = options.fold(0, (int acc, SmartPollOption option) => acc + option.votes);
      _hasPollEnded = pollEnded;
      _userHasVoted = hasVoted;
      _votedOption = options.find((SmartPollOption option) => option.id == votedOptionId);
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(covariant SmartPoll<T> oldWidget) {
    if(oldWidget.options.notEquals(widget.options)) {
      _init();
    } else if(oldWidget.options.isLengthLt(widget.options.length)) {
      _init();
    } else if(oldWidget.options.isLengthGt(widget.options.length)) {
      _init();
    } else if(oldWidget.votedOptionId != widget.votedOptionId) {
      _init();
    } else if(oldWidget.id.notEquals(widget.id)) {
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }

  @protected
  @nonVirtual
  String get id {
    if(widget.id.isNotNull) {
      return widget.id!;
    }

    Random random = Random();
    int randomInt = random.nextInt(1000000);

    return randomInt.toString();
  }

  @protected
  @nonVirtual
  bool get hasVoted => widget.hasVoted;

  @protected
  @nonVirtual
  bool get pollEnded => widget.pollEnded;

  @protected
  @nonVirtual
  T? get votedOptionId => widget.votedOptionId;

  @protected
  @nonVirtual
  SmartPollVotingCallback? get votingCallback => widget.onVoted;

  @protected
  @nonVirtual
  Widget get header => widget.header ?? SizedBox.shrink();

  @protected
  @nonVirtual
  List<SmartPollOption> get options => _options;

  @protected
  @nonVirtual
  double get spacingBetweenHeaderAndOptions => widget.spacingBetweenHeaderAndOptions ?? 10;

  @protected
  @nonVirtual
  SmartPollMetadata get metadata {
    SmartPollMetadata data = widget.metadata ?? SmartPollMetadata(totalVotes: _totalVotes);

    if(data.overrideTotalVotes) {
      data.copyWith(totalVotes: _totalVotes);
    }

    return data;
  }

  @protected
  @nonVirtual
  SmartPollOptionConfigBuilder configBuilder(SmartPollOptionConfigBuilder? builder) => (SmartPollOptionConfig c, int index) {
    return widget.useGlobalConfig && widget.globalConfig.isNotNull
      ? widget.globalConfig!
      : widget.configBuilder.isNotNull ? widget.configBuilder!(c, index)
      : builder.isNotNull ? builder!(c, index) : c;
  };

  @protected
  @nonVirtual
  SmartPollMetadataBuilder get metadataBuilder => widget.metadataBuilder ?? (SmartPollMetadata meta) {
    if(meta.shouldShow) {
      return Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: widget.mainAxisAlignment,
        textDirection: widget.textDirection,
        textBaseline: widget.textBaseline,
        children: [
          Spacing.vertical(meta.spacing),
          Row(
            crossAxisAlignment: meta.crossAxisAlignment,
            mainAxisSize: meta.mainAxisSize,
            mainAxisAlignment: meta.mainAxisAlignment,
            textDirection: meta.textDirection,
            textBaseline: meta.textBaseline,
            spacing: meta.metaSpacing,
            children: [
              TextBuilder(
                text: '${meta.totalVotes} ${meta.text}',
                style: meta.style.fontStyle ?? FontStyle.normal,
                color: meta.style.color ?? Colors.black,
                size: meta.style.fontSize ?? 14,
                flow: meta.style.overflow,
                decoration: meta.style.decoration,
                autoSize: meta.autoSize,
                weight: meta.style.fontWeight ?? FontWeight.normal,
              ),
              Expanded(child: meta.meta ?? Container()),
            ],
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  };

  void _handleOption(SmartPollOption option) async {
    if(votingCallback.isNotNull) {
      // Disables clicking while loading
      if(_isLoading) return;

      setState(() {
        _votedOption = option;
        _isLoading = true;
      });

      bool success = await votingCallback!(_votedOption!, _totalVotes);

      setState(() {
        _isLoading = false;

        if(success) {
          List<SmartPollOption> current = List.from(_options);
          int index = current.findIndex((SmartPollOption poll) => poll.id == option.id);

          if(index.notEquals(-1)) {
            current[index] = current[index].copyWith(isVoted: true);
          }

          _options = current;
          _totalVotes = _totalVotes++;
          _userHasVoted = true;
        }
      });
    }
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(id),
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      mainAxisAlignment: widget.mainAxisAlignment,
      textDirection: widget.textDirection,
      textBaseline: widget.textBaseline,
      children: [
        header,
        Spacing.vertical(spacingBetweenHeaderAndOptions),
        ...options.asMap().entries.map((MapEntry<int, SmartPollOption> entry) {
          SmartPollOptionConfig config = configBuilder(entry.value.configBuilder)(_default, entry.key);

          ItemMetadata<SmartPollOption> metadata = ItemMetadata<SmartPollOption>(
            isFirst: entry.key.equals(0),
            isLast: entry.key.equals(options.length - 1),
            index: entry.key,
            totalItems: options.length,
            isSelected: votedOptionId == entry.value.id,
            item: entry.value.copyWith(
              percent: _totalVotes.equals(0) ? 0 : entry.value.votes / _totalVotes,
              isLeading: options.map((SmartPollOption option) => option.votes)
                  .reduce((int a, int b) => a > b ? a : b) == entry.value.votes,
              isVoted: votedOptionId == entry.value.id,
              isVoting: _votedOption?.id == entry.value.id,
              configBuilder: entry.value.configBuilder ?? (SmartPollOptionConfig c, int index) => config
            )
          );

          SmartPollOption option = metadata.item;

          Widget title = option.title ?? TextBuilder(
            text: option.description ?? '',
            style: config.style.fontStyle ?? FontStyle.normal,
            color: config.style.color ?? Colors.black,
            size: config.style.fontSize ?? 14,
            flow: config.style.overflow,
            decoration: config.style.decoration,
            autoSize: config.autoSize,
            weight: config.style.fontWeight ?? FontWeight.normal,
          );

          String value = config.useText
            ? config.text
            : (_totalVotes.equals(0) ? "0${config.text}" : '${(option.votes / _totalVotes * 100).toDp(1)}%');

          if(widget.itemReader.isNotNull) {
            widget.itemReader!(context, metadata);
          }

          if(widget.itemBuilder.isNotNull) {
            return widget.itemBuilder!(context, metadata);
          } else if(_userHasVoted || _hasPollEnded) {
            return PollAnimator(
              width: config.width,
              duration: config.votedDuration,
              height: config.height,
              key: UniqueKey(),
              margin: EdgeInsets.only(bottom: config.spacing),
              decoration: config.votedDecoration,
              barRadius: config.votedRadius,
              padding: EdgeInsets.zero,
              percent: option.percent,
              animatedDuration: config.votedDuration,
              backgroundColor: option.isVoted ? config.userVotedBackgroundColor : config.votedBackgroundColor,
              progressColor: option.isLeading
                  ? config.leadingVotedProgressColor
                  : option.isVoted ? config.userVotedProgressColor : config.votedProgressColor,
              child: Container(
                width: config.contentWidth,
                padding: config.contentPadding,
                child: Row(
                  spacing: config.contentSpacing,
                  children: [
                    title,
                    if(option.isVoting) ...[
                      config.votedCheckmark
                    ],
                    Spacer(),
                    TextBuilder(
                      text: value,
                      style: config.style.fontStyle ?? FontStyle.normal,
                      color: config.style.color ?? Colors.black,
                      size: config.style.fontSize ?? 14,
                      flow: config.style.overflow,
                      decoration: config.style.decoration,
                      autoSize: config.autoSize,
                      weight: config.style.fontWeight ?? FontWeight.normal,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              key: UniqueKey(),
              margin: EdgeInsets.only(bottom: config.spacing),
              child: InkWell(
                onTap: () => _handleOption(option),
                splashColor: config.splashColor,
                borderRadius: config.borderRadius,
                child: Container(
                  height: config.height,
                  width: config.width ?? MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: option.isVoting ? config.voteInProgressColor : config.fillColor,
                    border: config.border,
                    borderRadius: config.borderRadius,
                  ),
                  child: Center(child: _isLoading && option.isVoting ? config.votingProgressIndicator : title,),
                ),
              ),
            );
          }
        }),
        metadataBuilder(metadata),
      ]
    );
  }
}