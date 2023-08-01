/*import 'package:flutter/material.dart';
void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drop Down Menu Example',
      home: DropDownExample(),
    );
  }
}

class DropDownExample extends StatefulWidget {
  DropDownExample({Key key}) : super(key: key);
  
  @override
  _DropDownExampleState createState() => _DropDownExampleState();
}

class _DropDownExampleState extends State<DropDownExample> {

  int selectedValue = 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:Container(
       child: Padding(
         padding: const EdgeInsets.all(10.0),
         child:Center(
           child: DropdownButton(
              value: selectedValue,
              items: [
                DropdownMenuItem(
                  child: Text("Male"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("Female"),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text("Others"),
                  value: 3
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                });
              }),
         )
    ),),);
  }
}*/