import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // 最初に表示するWidget
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'ChatApp',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.green,
      ),
      // ログイン画面を表示
      home: LoginPage(),
    );
  }
}

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String pass = "";
  String info = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          padding: EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child : Image.asset("images/login.png"),
                ),
              const SizedBox(height: 64),
              Container(
                width: 600,
                child : TextFormField(
                  decoration: InputDecoration(
                      labelText: "メールアドレス",
                      contentPadding: new EdgeInsets.symmetric(vertical: 0)),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width : 600,
               child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "パスワード",
                      contentPadding: new EdgeInsets.symmetric(vertical: 0)),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      pass = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              Container(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    child: Text('ユーザー登録'),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final res = await auth.createUserWithEmailAndPassword(
                            email: email, password: pass);
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return ChatPage(res.user);
                          }),
                        );
                      } catch (e) {
                        setState(() {
                          info = "登録に失敗 : ${e.toString()}";
                        });
                      }
                    },
                  )),
              const SizedBox(height: 16),
              Container(
                  width:150,
                  height: 48,
                  child: OutlinedButton(
                      child: Text("ログイン"),
                      onPressed: () async {
                        try {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final res = await auth.signInWithEmailAndPassword(
                              email: email, password: pass);
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return ChatPage(res.user);
                            }),
                          );
                        } catch (e) {
                          setState(() {
                            info = "ログインに失敗 ${e.toString()}";
                          });
                        }
                      })),

             const SizedBox(height: 16),
             Container(
               child : Text(info)
             ),
            ],
          ),
        ),
      ),
    );
  }
}

// チャット画面用Widget
class ChatPage extends StatelessWidget {
  ChatPage(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャットルーム'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      body:Column(
        children : <Widget>[
          Container(
            padding : EdgeInsets.all(8),
            child : Text("ログイン情報 : ${user.email}")
            ),
          Expanded(
            child : StreamBuilder<QuerySnapshot>(
               stream :FirebaseFirestore.instance
              .collection("posts")
              .orderBy("date")
              .snapshots(),
            builder : (context, snapshot){
              if (snapshot.hasData){
                final List<DocumentSnapshot> documents = snapshot.data.docs;
                return ListView(
                  children : documents.map((doc){
                    return Card(
                      child: ListTile(
                        title: Text(doc["text"]),
                        subtitle: Text("${doc["email"]}  ${doc["date"]}"),
                        trailing : doc["email"] == user.email
                        ?IconButton(
                          icon : Icon(Icons.delete),
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection("posts")
                            .doc(doc.id).delete();
                             },
                                )
                              : null,
                        ),
                      );
                  }).toList(),
                );
            }
            return Center(
              child : Text("loading ..."),
            );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // 投稿画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return AddPostPage(user);
            }),
          );
        },
      ),
    );
  }
}

// 投稿画面用Widget
class AddPostPage extends StatefulWidget {
  AddPostPage(this.user);
  final User user;
  @override
  _AddPostPageState createState() => _AddPostPageState();
}
class _AddPostPageState extends State<AddPostPage> {
  // 入力した投稿メッセージ
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              Container(
                width: 600,
                height: 44,
                child : TextFormField(
                  decoration: InputDecoration(labelText: '投稿メッセージ',
                  contentPadding: new EdgeInsets.symmetric(vertical: -25)),
                  // 複数行のテキスト入力
                  keyboardType: TextInputType.multiline,
                  // 最大3行
                  maxLines: 3,
                  onChanged: (String value) {
                    setState(() {
                      messageText = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 140,
                height: 64,
                child: ElevatedButton(
                  child: Text('投稿'),
                  onPressed: () async {
                    final date =
                        DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = widget.user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await FirebaseFirestore.instance
                        .collection('posts') // コレクションID指定
                        .doc() // ドキュメントID自動生成
                        .set({
                      'text': messageText,
                      'email': email,
                      'date': date
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}