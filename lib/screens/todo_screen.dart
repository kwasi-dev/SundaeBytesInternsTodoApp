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
    TodoItem("Complete Geography homework",
        DateTime.parse("2022-07-10 10:00:00")),
    TodoItem("Complete Physics homework", 
        DateTime.parse("2022-07-14 12:00:00"))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
