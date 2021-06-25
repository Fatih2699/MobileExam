import 'package:flutter/material.dart';

import 'login_screen.dart';

class Hakkinda extends StatefulWidget {
  var animationImage;
  Hakkinda({this.animationImage});
  @override
  _HakkindaState createState() => _HakkindaState();
}

class _HakkindaState extends State<Hakkinda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: "hakkinda",
        child: Material(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/image/hakkinda.png"),
                    fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
