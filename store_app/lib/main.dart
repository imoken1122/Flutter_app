import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyFirestorePage(),
    );
  }
}

class MyFirestorePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyFirestorePage> {
  List<DocumentSnapshot> doclist = [];
  String info = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text("コレクション, ドキュメント作成"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc("id_abc")
                    .collection("orders")
                    .doc("id_111")
                    .set({"price": 1000, "data": "10/13"});
              },
            ),
            ElevatedButton(
              child: Text("ドキュメント一覧"),
              onPressed: () async {
                final snapshot =
                    await FirebaseFirestore.instance.collection("users").get();
                setState(() {
                  doclist = snapshot.docs;
                });
              },
            ),
            Column(
              children: doclist.map((doc) {
                return ListTile(
                  title: Text("${doc['name']}さん"),
                  subtitle: Text("${doc['age']}歳"),
                );
              }).toList(),
            ),
            ElevatedButton(
              child: Text("doc指定取得"),
              onPressed: () async {
                final doc = await FirebaseFirestore.instance
                    .collection("users")
                    .doc("id_abc")
                    .collection("orders")
                    .doc("id_111").get();
                setState(() {
                  info = "${doc['date']} ${doc['price']}";
                });
              },
            ),
            ListTile(title: Text(info)),
            ElevatedButton(
              child: Text("ドキュメント更新"),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("users").doc("id_abc").update({"age":422});
              }
            ),
             ElevatedButton(
              child: Text("ドキュメント削除"),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("users").doc("id_abc")
                .collection("orders").doc("id_123").delete();
              }
            ),
          ],
        ),
      ),
    );
  }
}
