import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:litenews/ui/news/hot/hot_page.dart';

/// @author: xiao
/// created on: 2025/3/7 16:07
/// description:

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: HotPage()),
    );
  }
}
