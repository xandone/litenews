import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('收藏'),
    );
  }
}
