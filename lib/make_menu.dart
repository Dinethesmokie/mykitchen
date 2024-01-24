import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'menu_list.dart';

class MakeMenu extends StatefulWidget {
  const MakeMenu({super.key});

  @override
  State<MakeMenu> createState() => _MakeMenuState();
}

class _MakeMenuState extends State<MakeMenu> {

  final formKey = GlobalKey<FormState>();
  final menuController = TextEditingController();
  var menu1 = '';

  sendData() async {
    if(formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("menu").add({
        'menu items': menu1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Menu'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: menuController,
                    decoration: InputDecoration(
                      labelText: 'Enter Menu',
                      labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderSide: BorderSide()
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Menu Name';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          menu1 = menuController.text;
                        });
                        sendData();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuList()));
                        menuController.clear();// clear previous entered value
                      }
                    },
                    child: Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HotelMenu{
  final String menu1;
  final String id;

  HotelMenu({required this.menu1,
    required this.id});

  factory HotelMenu.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return HotelMenu(
      menu1: snapshot.get('menu items'),
      id: snapshot.id,
    );
  }
}
