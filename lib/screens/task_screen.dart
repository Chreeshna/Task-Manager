import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/task_model.dart';

class TaskScreen extends StatefulWidget {
  final int listId;

  const TaskScreen({super.key, required this.listId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Function to load tasks from the database
  void _loadTasks() async {
    final db = DBHelper(); // Singleton instance
    final List<Task> loadedTasks = await db.getTasks(widget.listId);
    if (mounted) {
      setState(() {
        tasks = loadedTasks;
      });
    }
  }

  // Function to show the dialog for adding/editing a task
  void _showTaskDialog(Task? existingTask) {
    TextEditingController titleController =
        TextEditingController(text: existingTask?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: existingTask?.description ?? '');
    String priority = existingTask?.priority ?? 'Medium';
    DateTime? dueDate = existingTask?.dueDate != null
        ? DateTime.parse(existingTask!.dueDate)
        : null;
    String? assignee = existingTask?.assignedTo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingTask == null ? 'Add New Task' : 'Edit Task'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                value: priority,
                items: ['High', 'Medium', 'Low'].map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    priority = value!;
                  });
                },
              ),
              TextButton(
                onPressed: () async {
                  dueDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                child: Text(dueDate == null
                    ? 'Pick Due Date'
                    : 'Due: ${dueDate!.toLocal()}'.split(' ')[0]),
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Assign to (optional)'),
                onChanged: (value) => assignee = value,
                controller: TextEditingController(text: assignee ?? ''),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final newTask = Task(
                    id: existingTask?.id ?? null,
                    listId: widget.listId, // Only associate with listId
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: dueDate?.toLocal().toString().split(' ')[0] ??
                        'No due date',
                    priority: priority,
                    assignedTo: assignee ?? 'Unassigned',
                    isDone: existingTask?.isDone ?? false,
                  );
                  final db = DBHelper();
                  if (existingTask == null) {
                    await db.createTask(newTask); // Create new task
                  } else {
                    await db.updateTask(newTask); // Update existing task
                  }
                  if (mounted) {
                    _loadTasks(); // Reload tasks after creating or updating
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(existingTask == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete a task
  void _deleteTask(int id) async {
    final db = DBHelper();
    await db.deleteTask(id);
    if (mounted) {
      _loadTasks(); // Reload tasks after deletion
    }
  }

  // Function to toggle the completion status of a task
  void _toggleComplete(Task task) async {
    task.isDone = !task.isDone;
    final db = DBHelper();
    await db.updateTask(task);
    if (mounted) {
      _loadTasks(); // Reload tasks after updating
    }
  }

  // Function to get color based on task priority
  Color _getPriorityColor(String priority) {
    if (priority == 'High') {
      return Colors.redAccent;
    } else if (priority == 'Medium') {
      return Colors.orangeAccent;
    } else {
      return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for List ${widget.listId}'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  color: _getPriorityColor(task.priority),
                  elevation: 2,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration:
                            task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                        'Priority: ${task.priority} | Due: ${task.dueDate} | Assigned: ${task.assignedTo}'),
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (value) => _toggleComplete(task),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showTaskDialog(task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(task.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
