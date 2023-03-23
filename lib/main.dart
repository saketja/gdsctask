import'package:flutter/material.dart';
import 'package:gdsc/todo.dart';
import 'package:gdsc/input.dart';
import 'package:hive/hive.dart';
import 'dart:async';

void main(){
  runApp(MaterialApp(
    home:HomePage(),
    theme:ThemeData(

    ),
  ));
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todolist=ToDo.todolist();
  List<ToDo> _foundToDo=[];
  final _todocontroller=TextEditingController();

  void initState()
  {
    _foundToDo=todolist;
    super.initState();
  }

  void _runFilter(String enteredKeyword)
  {
    List<ToDo> results=[];
    if(enteredKeyword.isEmpty){
      results=todolist;
    }
    else{
      results=todolist
          .where((item)=>item.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo=results;
    });
  }

  void _handleToDochange(ToDo todo){
    setState((){
      todo.isDone=!todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      todolist.removeWhere((item) => item.id==id);
    });
  }

  void _addtodoitem(String toDo)
  {
    setState(() {
      todolist.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
    });
    _todocontroller.clear();
  }

  void _editToDoItem(BuildContext context, ToDo todo) {
    final TextEditingController _editController =
    TextEditingController(text: todo.todoText);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Todo'),
        content: TextField(
          controller: _editController,
          decoration: InputDecoration(
            hintText: 'Enter new todo...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Update the to-do item in the list with the edited text
                todo.todoText = _editController.text;
              });
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }


  Widget searchBox()
  {
    return Container(
      decoration:BoxDecoration(
        color:Colors.yellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child:TextField(
        onChanged: (value)=>_runFilter(value),
        decoration:InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search,size: 20,color: Colors.black,),
          prefixIconConstraints: BoxConstraints(
            maxHeight:20,
            minWidth: 30,
          ),
          border:InputBorder.none,
          hintText: 'Search',
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title:Text(
          'TODO LIST APP',
          style:TextStyle(
            color:Colors.blue,
          ),
        ),
      ),

      body:Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical:15),
            child:Column(
              children: [
                searchBox(),

                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin:EdgeInsets.only(
                          top:50 ,
                          bottom: 20,
                        ),
                        child: Text(
                          'ALL TODOs',
                          style: TextStyle(
                            fontSize:30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for(ToDo todo in _foundToDo)
                        TodoItem(
                          todo:todo,
                          onToDochanged: _handleToDochange,
                          onDeleteItem: _deleteToDoItem,
                          onEditItem:_editToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:Row(children:[
              Expanded(
                child: Container(
                  margin:EdgeInsets.only(
                    bottom:20,
                    right: 20,
                    left:20,
                  ),
                  padding:EdgeInsets.symmetric(
                    horizontal:20,
                    vertical:5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(
                      color:Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),],
                    borderRadius:BorderRadius.circular(10),
                  ),
                  child:TextField(
                    controller: _todocontroller,
                    decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border:InputBorder.none
                    ),
                  ),
                ),
              ),
              Container(
                margin:EdgeInsets.only(
                  bottom:20,
                  right:20,
                ) ,
                child:ElevatedButton(
                    child:Text('+',style:TextStyle(fontSize: 40,),),
                    onPressed: (){
                      _addtodoitem(_todocontroller.text);
                    },
                    style:ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: Size(60, 60),
                    )
                ),
              ),
            ]),
          ),
        ],
      ),

      drawer: Drawer(
        child:ListView(
          padding:const EdgeInsets.all(0),
          children:<Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("TODO APP"),
              accountEmail: Text("DEVELOPER DETAILS"),
            ),
            ListTile(
              leading:Icon(Icons.person),
              title:Text("Saket Jain"),
              subtitle:Text("App developer"),
            ),
            ListTile(
              leading:Icon(Icons.email),
              title:Text("Email"),
              subtitle: Text("saketjain2020@gmail.com"),
            )
          ],
        ),
      ),
    );
  }
}