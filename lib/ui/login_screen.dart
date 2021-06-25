import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movielib_final/ui/register_screen.dart';

import '../splash_screen.dart';
import 'hakkinda.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  String _email, _password;

  var _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

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
                    "assets/image/loginIntro.jpg",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white24, //white24
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
                              "GİRİŞ YAP  ",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.cyan.shade600,
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
                                    color: Colors.black,
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
                                    color: Colors.black,
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
                                          : "Şİfreniz en az 6 karakterli olmalıdır.";
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
                            Container(
                              alignment: Alignment.centerRight,
                              child: MaterialButton(
                                onPressed: () => sifreSifirla(),
                                padding: EdgeInsets.only(right: 1.0),
                                child: Text(
                                  "Şifremi Unuttum",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.black),
                                    child: Checkbox(
                                      value: _rememberMe,
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Beni Hatırla",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text("GİRİŞ YAP"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                    elevation: 5.0,
                                    shadowColor: Colors.white),
                                onPressed: () => girisYap(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Google ile giriş yap",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                            color: Colors.black26,
                                            offset: Offset(0, 2),
                                            blurRadius: 6.0),
                                      ],
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/image/google.png")),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "KAYIT OL",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 50,
                    child: Hero(
                      tag: "hakkinda",
                      child: Material(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Hakkinda(
                                animationImage: "assets/image/hakkinda.png",
                              ),
                            ),
                          ),
                          child: Image.asset(
                            "assets/image/hakkinda.png",
                            height: 50,
                            width: 50,
                          ),
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

  void girisYap() {
    if (_formKey.currentState.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ),
            (route) => false);
      }).catchError(
        (hata) {
          debugPrint("Hata aldınız $hata");
        },
      );
    }
  }

  sifreSifirla() async {
    try {
      await auth.sendPasswordResetEmail(email: _email);
      Fluttertoast.showToast(
          msg: "Şifre yenileme talebiniz mail adresinize gönderildi.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    } catch (e) {
      debugPrint("HATA VAR ŞİFRE RESETLEME " + e.toString());
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
