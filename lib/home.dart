import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var Taskbox = Hive.box<Task>('tasks');
     var box = Hive.box('myBox');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
             
              SizedBox(height: 20),
              // TITLE
              Text(
                'My To-Do List',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // INPUT FIELD + ADD BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              controller: controller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter a task';
                                }
                                if (value.length < 3) {
                                  return 'At least 3 letters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Add a new task...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          box.add(controller.text);
                          controller.clear();
                        }
                      },
                      backgroundColor: Colors.white,
                      child: Icon(Icons.add, color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // LIST OF TASKS
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, Box box, _) {
                    var tasks = box.values.toList();

                    if (tasks.isEmpty) {
                      return Center(
                        child: Text(
                          'No tasks yet!',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Dismissible(
                            key: Key(tasks[index].toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              box.deleteAt(index);
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  tasks[index].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red.shade700,
                                  ),
                                  onPressed: () {
                                    box.deleteAt(index);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
