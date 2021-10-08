import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final double horizontal;
  final double verticle;

  Space({this.horizontal = 0, this.verticle = 0});

  @override
  Widget build(BuildContext context) {
    var margin = EdgeInsets.only(top: verticle, left: horizontal);
    return Container(margin: margin);
  }
}
