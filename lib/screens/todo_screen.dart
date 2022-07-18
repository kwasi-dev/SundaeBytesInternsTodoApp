import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intern_todo/models/todo_item.dart';
import 'package:intern_todo/utilities/database.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  //Load Items from database
  DatabaseHelper dbHelper = DatabaseHelper()..loadDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController deadlineController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Create Item"),
                  actions: [
                    TextButton(
                      child: Text("Save"),
                      onPressed: () {
                        print("I have selected the save button");
                        String description = descriptionController.text;
                        String deadline = deadlineController.text;

                        if (description.isEmpty || deadline.isEmpty) {
                        } else {
                          DateTime convertedDate = DateTime.parse(deadline);

                          TodoItem newItemFromForm =
                              TodoItem(description, convertedDate);

                          DatabaseHelper dbh = DatabaseHelper();

                          dbh.saveItemToDatabase(newItemFromForm);

                          setState(() {
                            //RELOAD
                          });

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        print("I have selected the cancel button");
                      },
                    )
                  ],
                  content: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.description),
                              hintText: "Enter the description for the item",
                              labelText: "Description"),
                        ),
                        TextFormField(
                          controller: deadlineController,
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 60)));

                            if (selectedDate != null) {
                              //update the textFormField
                              deadlineController.text = selectedDate.toString();
                            }
                          },
                          decoration: const InputDecoration(
                              icon: Icon(Icons.punch_clock_outlined),
                              hintText: "",
                              labelText: "Deadline"),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: dbHelper.loadAllTodoItems(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text("Loading...");
              default:
                if (snapshot.hasError)
                  return Text("Error: ${snapshot.error}");
                else {
                  List<TodoItem> items = snapshot.data!;

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      TodoItem thisItem = items[index];
                      return CheckboxListTile(
                        title: Text(thisItem.description),
                        subtitle: Text(thisItem.getSubtitle()),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              thisItem.updateCompletedDate(value);
                            }
                          });
                        },
                        value: thisItem.isFinished,
                      );
                    },
                  );
                }
            }
          }),
    );
  }
}
