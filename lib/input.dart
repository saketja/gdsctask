import 'package:flutter/material.dart';
import 'package:gdsc/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDochanged;
  final onDeleteItem;
  final onEditItem;

  const TodoItem ({
    Key? key,
    required this.todo,
    required this.onDeleteItem,
    required this.onToDochanged,
    required this.onEditItem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom:20),
      child: ListTile(
        onTap: () {
          onToDochanged(todo);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        contentPadding: EdgeInsets.symmetric(horizontal:20, vertical:5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.lightBlue,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(0),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: Icon(Icons.edit),
                onPressed: () {
                  onEditItem(todo.id);
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.all(0),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: Icon(Icons.delete),
                onPressed: () {
                  onDeleteItem(todo.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
