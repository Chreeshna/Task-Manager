import 'package:flutter/material.dart';
import '../models/board_model.dart';
import 'board_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<BoardModel> boards = [
    BoardModel(title: 'Work', tasks: ['Task 1', 'Task 2']),
    BoardModel(title: 'Personal', tasks: ['Groceries', 'Gym']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Boards')),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(boards[index].title),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoardScreen(board: boards[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
