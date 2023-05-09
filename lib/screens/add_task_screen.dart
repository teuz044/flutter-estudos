import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final List<Task> tasks;

  const AddTaskScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = widget.tasks;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _addTask() {
    final taskName = _textEditingController.text.trim();
    if (taskName.isNotEmpty) {
      final task = Task(name: taskName);
      setState(() {
        _tasks.add(task);
      });
      _textEditingController.clear();
    }
  }

  void _editTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editController =
        TextEditingController(text: task.name);

        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: 'Task Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  task.name = editController.text.trim();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _tasks.remove(task);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Theme(
        data: ThemeData.dark(), // Define o tema escuro
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Digite aqui a sua tarefa',
                  labelStyle: TextStyle(
                    color: Colors.black, // Define a cor do texto do label
                  ),
                ),
                style: TextStyle(
                  color: Colors.black, // Definindo a cor do texto como preto
                ),
                onEditingComplete: _addTask,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addTask,
                child: const Text('Add Task'),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Tarefas:',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: Key(task.name),
                      onDismissed: (direction) {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${task.name} dismissed')));
                      },
                      background: Container(color: Colors.red),
                      child: CheckboxListTile(
                        title: Text(
                            task.name,
                          style: TextStyle(color: Colors.black),
                        ),
                        checkColor: Colors.black,
                        value: task.isCompleted,
                        onChanged: (value) {
                          setState(() {
                            task.isCompleted = value ?? false;
                          });
                        },
                        secondary: IconButton(
                          icon: Icon(Icons.edit,color: Colors.black,),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final TextEditingController controller = TextEditingController(
                                    text: task.name);
                                return AlertDialog(
                                  title: Text('Edit Task'),
                                  content: TextField(
                                    controller: controller,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        labelText: 'Task Name'),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('CANCEL'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('SAVE'),
                                      onPressed: () {
                                        setState(() {
                                          task.name = controller.text.trim();
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('DELETE'),
                                      onPressed: () => _deleteTask(task),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}