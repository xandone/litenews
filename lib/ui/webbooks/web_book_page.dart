import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:litenews/res/colors.dart';
import 'package:litenews/ui/webbooks/web_books_details.dart';

class WebBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WebBookState();
  }
}

class WebBookState extends State<WebBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          children: [
            GestureDetector(
                child: const Column(
                  children: [
                    Expanded(
                        child: Image(
                      image: AssetImage('assets/images/flu_combat_logo.png'),
                    )),
                    Text(
                      'flutter实战',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WebBooksDetails();
                  }));
                }),
            Column(
              children: [
                Expanded(
                    child: SvgPicture.asset(
                  'assets/images/hello_algo.svg',
                  colorFilter:
                      ColorFilter.mode(Color(0XFF55aea6), BlendMode.srcIn),
                )),
                const Text(
                  'hello算法',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Column(
              children: [
                Expanded(
                    child: Image(
                  image: AssetImage('assets/images/qiangu.png'),
                )),
                Text(
                  '千古前端',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
