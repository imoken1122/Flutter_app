import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Firebase初期化
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  String loginUserEmail = "";
  String loginUserPassword = "";
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(64),
          child: Column(
            children: <Widget>[
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "メールアドレス" ,
                   contentPadding: new EdgeInsets.symmetric(vertical:0)),

                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード（６文字以上）",
                contentPadding: new EdgeInsets.symmetric(vertical:0)),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                height : 48,
                width : 140,
                child: ElevatedButton(
                
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result =
                          await auth.createUserWithEmailAndPassword(
                        email: newUserEmail,
                        password: newUserPassword,
                      );

                      // 登録したユーザー情報
                      final User user = result.user;
                      setState(() {
                        infoText = "登録OK：${user.email}";
                      });
                    } catch (e) {
                      // 登録に失敗した場合
                      setState(() {
                        infoText = "登録NG：${e.toString()}";
                      });
                    }
                  },
                  child: Text("ユーザー登録"),

                ),
              ),
              const SizedBox(height: 64),
              TextFormField(
                decoration : InputDecoration(labelText : "メールアドレス", 
                   contentPadding : new EdgeInsets.symmetric(vertical:0)),
                onChanged : (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                }, 
                ),
             TextFormField(
                decoration : InputDecoration(labelText : "パスワード",contentPadding : new EdgeInsets.symmetric(vertical:0)),
                onChanged : (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                }, 
                ), 
              const SizedBox(height:32),
              SizedBox(
                  height : 48,
                  width : 140,
                 child : ElevatedButton(
                    onPressed: () async{ 
                      try{
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential res = await auth.signInWithEmailAndPassword(email: loginUserEmail, password: loginUserPassword);
                        final User user = res.user;
                        setState((){
                          infoText=  "ログイン成功 : ${user.email}";
                        });
                      }catch(e){
                        setState(() {
                          infoText = "ログイン失敗 : ${e.toString()}";
                        });
                      }
                    },
                    child : Text("ログイン"),
                  ),
              ),
              const SizedBox(height:16),
              Text(infoText),
            ],
          ),
        ),
      ),
    );
  }
}