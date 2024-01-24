import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'make_order.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        actions: [
          IconButton(onPressed: () async {
            //PdfInvoiceApi().savePdfFile("fileName", byteList as Unit8Liat)
          },
              icon: Icon(Icons.file_copy))
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
