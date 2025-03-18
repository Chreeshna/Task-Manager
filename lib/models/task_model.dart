class Task {
  int? id;
  int boardId;
  int listId;
  String title;
  String description;
  String dueDate;
  String priority;
  String assignedTo;
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

  // Convert a Task into a map
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
      'isDone': isDone ? 1 : 0, // store boolean as integer
    };
  }

  // Convert a map into a Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      boardId: map['boardId'],
      listId: map['listId'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      priority: map['priority'],
      assignedTo: map['assignedTo'],
      isDone: map['isDone'] == 1, // convert back from integer
    );
  }
}
