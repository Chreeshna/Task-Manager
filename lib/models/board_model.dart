class BoardModel {
  final int id;
  final String name;

  BoardModel({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(id: map['id'], name: map['name']);
  }
}
