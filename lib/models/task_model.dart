class Task {
  final int? id;
  final int boardId;
  final int listId;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String assignedTo;
  bool isDone;

  Task({
    this.id,
    required this.boardId,
    required this.listId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.assignedTo,
    required this.isDone,
  });

  // Convert Task to Map for insertion into DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'boardId': boardId,
      'listId': listId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'assignedTo': assignedTo,
      'isDone': isDone ? 1 : 0,
    };
  }

  // Convert Map to Task object
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      boardId: map['boardId'],
      listId: map['listId'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      priority: map['priority'],
      assignedTo: map['assignedTo'],
      isDone: map['isDone'] == 1,
    );
  }
}
