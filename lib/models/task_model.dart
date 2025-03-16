class Task {
  final int? id;
  final int listId; // Updated to be list-based
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String assignedTo; // New field for task assignee
  final bool isDone;

  Task({
    this.id,
    required this.listId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.assignedTo,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'assignedTo': assignedTo,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
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
