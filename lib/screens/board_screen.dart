import 'package:flutter/material.dart';
import 'task_screen.dart';

class BoardScreen extends StatefulWidget {
  final String boardName;

  const BoardScreen({super.key, required this.boardName});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<String> tasks = []; // Empty task list

  // Function to show a dialog for adding tasks
  void _addTask() {
    String newTask = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          onChanged: (value) => newTask = value,
          decoration: const InputDecoration(hintText: 'Enter task name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newTask.trim().isNotEmpty) {
                setState(() {
                  tasks.add(newTask); // Add new task to the list
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
        elevation: 0,
      ),
      body: tasks.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(tasks[index]),
                    subtitle: Text('Due: 2025-05-${index + 1}'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskScreen(
                            listId: index,
                            boardId: 1,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(child: Text('No tasks available')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask, // Call the add task function
        child: const Icon(Icons.add),
      ),
    );
  }
}
