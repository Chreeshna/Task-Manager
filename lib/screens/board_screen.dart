import 'package:flutter/material.dart';
import '../models/board_model.dart';

class BoardScreen extends StatefulWidget {
  final BoardModel board;

  const BoardScreen({Key? key, required this.board}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.board.title)),
      body: ListView.builder(
        itemCount: widget.board.tasks.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.check_box_outline_blank),
          title: Text(widget.board.tasks[index]),
        ),
      ),
    );
  }
}
