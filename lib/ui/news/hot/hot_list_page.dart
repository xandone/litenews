import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @author: xiao
/// created on: 2025/3/7 17:03
/// description:
class HotListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotListState();
  }
}

class _HotListState extends State<HotListPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('1111'),
          );
        });
  }
}
