import 'package:flutter/material.dart';

class HomeCardWidget extends StatelessWidget {
  HomeCardWidget(
      {@required this.title,
      this.more = 'HEPSİNİ GÖR',
      @required this.child,
      this.onPress});

  final String title, more;
  final VoidCallback onPress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCardTitle(title: title, onPress: onPress),
        SizedBox(height: 6),
        child,
      ],
    );
  }
}

class HomeCardTitle extends StatelessWidget {
  HomeCardTitle(
      {@required this.title, this.more = 'HEPSİNİ GÖR', this.onPress});

  final String title, more;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
              child: Text(
                more,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: onPress),
        ],
      ),
    );
  }
}
