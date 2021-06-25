import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../splash_screen.dart';
import 'login_screen.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  String _email, _password;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("HATA ÇIKTI" + snapshot.error.toString()),
            ),
          );
        } else
          return Scaffold(
            body: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/image/register.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent, //white24
                    child: Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: 120.0, horizontal: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "KAYIT OL",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  height: 60.0,
                                  child: TextFormField(
                                    onChanged: (alinanEmail) {
                                      setState(() {
                                        _email = alinanEmail;
                                      });
                                    },
                                    validator: (alinanEmail) {
                                      return alinanEmail.contains("@")
                                          ? null
                                          : "Lütfen geçerli bir mail adresi giriniz.";
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      hintText: "Email Adresinizi giriniz.",
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  height: 60.0,
                                  child: TextFormField(
                                    onChanged: (alinanSifre) {
                                      setState(() {
                                        _password = alinanSifre;
                                      });
                                    },
                                    validator: (alinanSifre) {
                                      return alinanSifre.length >= 6
                                          ? null
                                          : "Şifreniz en az 6 karakter olmalıdır.";
                                    },
                                    obscureText: true,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: 14.0),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      hintText: "Parolanızı Giriniz",
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text("Kayıt OL"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    elevation: 5.0,
                                    shadowColor: Colors.white),
                                onPressed: () {
                                  kayitEkle();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Google ile kayıt ol",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 100,
                                ),
                                GestureDetector(
                                  onTap: () => googleIleGiris(),
                                  child: Container(
                                    height: 45.0,
                                    width: 45.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(0, 2),
                                            blurRadius: 6.0),
                                      ],
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/image/google.png"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              child: Text("Zaten Hesabım Var"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  elevation: 5.0,
                                  shadowColor: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  void kayitEkle() async {
    if (_formKey.currentState.validate()) {
      try {
        UserCredential _credential = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        User _yeniUser = _credential.user;
        await _yeniUser.sendEmailVerification();
        if (auth.currentUser != null) {
          Fluttertoast.showToast(
              msg: "Lütfen girilen email adresini doğrulayınız.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          await auth.signOut().then(
                (user) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (Route<dynamic> route) => false),
              );
        }
      } catch (e) {
        debugPrint("HATA VAR ");
        debugPrint(e.toString());
      }
    }
  }

  Future<UserCredential> googleIleGiris() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await auth.signInWithCredential(credential).then(
            (user) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => SplashScreen()),
                (Route<dynamic> route) => false),
          );
    } catch (e) {
      debugPrint("HATA VAR GOOGLE İLE GİRİŞ" + e.toString());
    }
  }
}
