import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/task_model.dart';

class TaskScreen extends StatefulWidget {
  final int listId;
  final int boardId;

  const TaskScreen({super.key, required this.listId, required this.boardId});

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

  void _loadTasks() async {
    final db = DBHelper();
    final List<Task> loadedTasks = await db.getTasks(widget.listId);
    if (mounted) {
      setState(() {
        tasks = loadedTasks;
      });
    }
  }

  void _addTask() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String priority = 'Medium';
    DateTime? dueDate;
    String? assignee;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title')),
                  TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description')),
                  DropdownButton<String>(
                    value: priority,
                    items: ['High', 'Medium', 'Low'].map((level) {
                      return DropdownMenuItem(value: level, child: Text(level));
                    }).toList(),
                    onChanged: (value) =>
                        setDialogState(() => priority = value!),
                  ),
                  TextButton(
                    onPressed: () async {
                      dueDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      setDialogState(() {});
                    },
                    child: Text(dueDate == null
                        ? 'Pick Due Date'
                        : 'Due: ${dueDate!.toLocal()}'.split(' ')[0]),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'Assign to (optional)'),
                    onChanged: (value) => assignee = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty) {
                    final newTask = Task(
                      id: null,
                      boardId: widget.boardId,
                      listId: widget.listId,
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: dueDate?.toLocal().toString().split(' ')[0] ??
                          'No due date',
                      priority: priority,
                      assignedTo: assignee ?? 'Unassigned',
                      isDone: false,
                    );
                    final db = DBHelper();
                    await db.createTask(newTask);
                    if (mounted) {
                      _loadTasks();
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteTask(int id) async {
    final db = DBHelper();
    await db.deleteTask(id);
    if (mounted) {
      _loadTasks();
    }
  }

  void _toggleComplete(Task task) async {
    task.isDone = !task.isDone;
    final db = DBHelper();
    await db.updateTask(task);
    if (mounted) {
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for Board ${widget.boardId}'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(task.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
