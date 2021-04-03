void register(){
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
}