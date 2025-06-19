class TestData {
  final String name;
  final int age;

  TestData({required this.name, required this.age});

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory TestData.fromJson(Map<String, dynamic> json) => TestData(name: json['name'], age: json['age']);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TestData &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}