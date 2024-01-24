import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'make_menu.dart';
import 'make_order.dart';
import 'menu_list.dart';
import 'order_history.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final tableController = TextEditingController();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final chefController = TextEditingController();
  final ingredientsController = TextEditingController();

  Future deleteFirestore(String documentId) async {
    try{
      await FirebaseFirestore.instance.collection('orders').doc(documentId).delete();
    }catch(e){
      print('error: ' + '$e');
    }
  }

  updateData(selectedDoc) async{
    FirebaseFirestore.instance.collection('orders').doc(selectedDoc)
        .update({
       'table number': tableController.text,
       'item name': nameController.text,
       'quantity': quantityController.text,
       'chef': chefController.text,
       'ingredients': ingredientsController.text
    }).whenComplete(() => Navigator.of(context).pop()).catchError((e){print(e);});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 220,
        child: ListView(
          children: [
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MakeOrder()));
            },
                child: Text('Make Orders')),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MakeMenu()));
            },
                child: Text('Hotel Menu')),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistory()));
            },
                child: Text('Order History'))
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Our Kitchen'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuList()));
          },
              icon: Icon(Icons.food_bank_outlined))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData && snapshot.data.docs.isNotEmpty){

            var OrderList = List<UserOrder>.empty(growable: true);

            snapshot.data?.docs?.forEach((documentSnapshot) {
              var Orderss = UserOrder.fromDocumentSnapshot(documentSnapshot);

              OrderList.add(Orderss);
            });
            return ListView.builder(
              itemCount: OrderList.length,
                itemBuilder: (context, int index){
                return ExpansionTile(
                  title: Text('TABLE: ' + OrderList[index].table),
                  leading: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          //editMenuController.text = MenuList[index].menu1;
                          tableController.text = OrderList[index].table;
                          nameController.text = OrderList[index].name;
                          quantityController.text = OrderList[index].quantity;
                          chefController.text = OrderList[index].chef;
                          ingredientsController.text = OrderList[index].ingredients;
                          showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: ListView(
                                      shrinkWrap: true,
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
                                        SizedBox(height: 10,),
                                        ElevatedButton(
                                            onPressed: (){
                                              // MenuList[index].updateData({});
                                              updateData(OrderList[index].id,);
                                            },
                                            child: Text('Submit'))

                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                            icon: Icon(Icons.edit)),
                        IconButton(onPressed: (){
                          deleteFirestore(OrderList[index].id);//function
                        },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(OrderList[index].name),
                        Text(OrderList[index].chef),
                        Text(OrderList[index].quantity),
                        Text(OrderList[index].ingredients),

                      ],
                    ),
                  ]
                );
                });
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },),
    );
  }
}
