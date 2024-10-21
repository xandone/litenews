import 'package:litenews/db/hello_item_dao.dart';
import 'package:litenews/models/convert_utils.dart';
import 'package:litenews/models/hellogithub/hello_item_bean.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objectbox.g.dart';
import '../utils/logger.dart';

/// Provides access to the ObjectBox Store throughout the app.
///`dart run build_runner build`
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  static final ObjectBox _instance = ObjectBox.create0();

  factory ObjectBox() {
    return _instance;
  }

  ObjectBox.create0();

  Future<Box<T>> createBox<T>() async {
    String directory =
        p.join((await getApplicationDocumentsDirectory()).path, "litenews-db");
    if (Store.isOpen(directory)) {
      return _store.box<T>();
    } else {
      _store = await openStore(
          directory: directory, macosApplicationGroup: "hellogithub.db");
    }
    return _store.box<T>();
  }

  void close() {
    _store.close();
  }
}
