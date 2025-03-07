import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:litenews/ui/52im/im_details_page.dart';
import 'package:litenews/ui/routes/page_path.dart';

import '../hellogithub/hello_details.dart';
import '../home_page.dart';

/// @author: xandone
/// created on: 2025/1/17 11:14
/// description:

class PageManifest {
  PageManifest._();

  static final routes = [
    GetPage(
      name: PagePath.mMain,
      page: () {
        return HomePage();
      },
      bindings: [],
    ),
    GetPage(
      name: PagePath.mHomeHelloGithub,
      page: () {
        return HelloDetailsPage(
          arguments: HelloDetailsArguments(itemId: '', isFromDb: false),
        );
      },
      bindings: [],
    ),
    GetPage(
      name: PagePath.mHome52Im,
      page: () {
        return ImDetailsPage(
            arguments: ImDetailsArguments(itemId: '1', title: ''));
      },
      bindings: [],
    ),
  ];
}
