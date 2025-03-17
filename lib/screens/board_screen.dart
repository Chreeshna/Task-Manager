import 'package:flutter/material.dart';
import 'task_screen.dart';

class BoardScreen extends StatelessWidget {
  final String boardName;

  const BoardScreen({super.key, required this.boardName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(boardName),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Replace with actual task count
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text('Task ${index + 1}'),
              subtitle: Text('Due: 2023-10-${index + 1}'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(
                      listId: index, // Pass the index as a unique listId
                      boardId:
                          1, // Static boardId (replace with actual one if needed)
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
