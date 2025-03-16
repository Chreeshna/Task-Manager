class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  final List<String> users = ["User1", "User2", "User3"]; // Example users

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final loadedTasks =
        await DBHelper.getTasks(widget.boardId, widget.listName);
    setState(() => tasks = loadedTasks);
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController taskController = TextEditingController();
        String? assignedUser = users[0]; // Default user

        return AlertDialog(
          title: const Text("New Task"),
          content: Column(
            children: [
              TextField(controller: taskController),
              DropdownButton<String>(
                value: assignedUser,
                onChanged: (String? newValue) {
                  setState(() {
                    assignedUser = newValue!;
                  });
                },
                items: users.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (taskController.text.isNotEmpty) {
                  final newTask = Task(
                    title: taskController.text,
                    listId: widget.boardId,
                    assignedTo: assignedUser!, // Assigned user
                  );
                  await DBHelper.insertTask(newTask);
                  _loadTasks();
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
