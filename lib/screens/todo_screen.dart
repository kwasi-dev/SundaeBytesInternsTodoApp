import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intern_todo/models/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoItem> items = [
    TodoItem(
        "Complete Geography homework", DateTime.parse("2022-07-10 10:00:00")),
    TodoItem("Complete Physics homework", DateTime.parse("2022-07-14 12:00:00"))
  ];

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
                        DateTime convertedDate = DateTime.parse(deadline);

                        TodoItem newItemFromForm =
                            TodoItem(description, convertedDate);

                        setState(() {
                          items.add(newItemFromForm);
                        });

                        Navigator.of(context).pop();
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
      body: ListView.builder(
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
      ),
    );
  }
}
