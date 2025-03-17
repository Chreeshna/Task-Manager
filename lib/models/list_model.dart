class ListModel {
  final int id;
  final int boardId;
  final String name;

  ListModel({required this.id, required this.boardId, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'boardId': boardId, 'name': name};
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(id: map['id'], boardId: map['boardId'], name: map['name']);
  }
}
