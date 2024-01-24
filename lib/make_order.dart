import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dash_board.dart';

class MakeOrder extends StatefulWidget {
  const MakeOrder({super.key});

  @override
  State<MakeOrder> createState() => _MakeOrderState();
}

class _MakeOrderState extends State<MakeOrder> {

  final formKey = GlobalKey<FormState>();
  final tableController = TextEditingController();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final chefController = TextEditingController();
  final ingredientsController = TextEditingController();

  var table = '';
  var name = '';
  var quantity = '';
  var chef = '';
  var ingredients = '';

  sendData() async {
    if(formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("orders").add({
        'table number': table,
        'item name': name,
        'quantity': quantity,
        'chef': chef,
        'ingredients': ingredients
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Order'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: tableController,
                      decoration: InputDecoration(
                        labelText: 'Table Number',
                        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Table Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Item Name',
                        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Item';
                        }
                        return null;
                      },

                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: 'Enter Quantity',
                        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Quantity';
                        }
                        return null;
                      },

                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: chefController,
                      decoration: InputDecoration(
                        labelText: 'Chef Name',
                        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Chef Name';
                        }
                        return null;
                      },

                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: ingredientsController,
                      decoration: InputDecoration(
                        labelText: 'Enter Ingredients',
                        labelStyle: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderSide: BorderSide()
                        ),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 10),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Ingredients';
                        }
                        return null;
                      },

                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            table = tableController.text;
                            name = nameController.text;
                            quantity = quantityController.text;
                            chef = chefController.text;
                            ingredients = ingredientsController.text;
                          });
                          sendData();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardPage()));
                        }
                      },
                      child: Text('Submit'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserOrder{
  final String table;
  final String name;
  final String quantity;
  final String chef;
  final String ingredients;
  final String id;

  UserOrder({required this.table, required this.name, required this.quantity, required this.chef, required this.ingredients,
  required this.id});

  factory UserOrder.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserOrder(
     //url: snapshot.get('url'),
      // category: snapshot.get('tag'),
      table: snapshot.get('table number'),
      name: snapshot.get('item name'),
      quantity: snapshot.get('quantity'),
      chef: snapshot.get('chef'),
      ingredients: snapshot.get('ingredients'),
      id: snapshot.id,  
    );
  }
}
