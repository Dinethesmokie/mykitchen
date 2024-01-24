import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'make_menu.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {

  Future deleteFirestore(String documentId) async {
    try{
      await FirebaseFirestore.instance.collection('menu').doc(documentId).delete();
    }catch(e){
      print('error: ' + '$e');
    }
  }

  updateData(selectedDoc, newValues) async{
    FirebaseFirestore.instance.collection('menu').doc(selectedDoc)
        .update({
      'menu items': editMenuController.text
    }).whenComplete(() => Navigator.of(context).pop()).catchError((e){print(e);});
  }

  var editMenuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Items'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('menu').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData && snapshot.data.docs.isNotEmpty){

            var MenuList = List<HotelMenu>.empty(growable: true);

            snapshot.data?.docs?.forEach((documentSnapshot) {
              var itemss = HotelMenu.fromDocumentSnapshot(documentSnapshot);

              MenuList.add(itemss);
            });
            return ListView.builder(
                itemCount: MenuList.length,
                itemBuilder: (context, int index){
                  return ListTile(
                      title: Text(MenuList[index].menu1),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            editMenuController.text = MenuList[index].menu1;
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
                                              controller: editMenuController,
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
                                          SizedBox(height: 10,),
                                          ElevatedButton(
                                              onPressed: (){
                                               // MenuList[index].updateData({});
                                                updateData(MenuList[index].id, MenuList[index].menu1);
                                              },
                                              child: Text('Submit'))

                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                              icon: Icon(Icons.edit)),
                          IconButton(onPressed: () async {
                            deleteFirestore( MenuList[index].id);
                          },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },),
    );
  }
}
