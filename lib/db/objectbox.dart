import 'package:litenews/db/hello_item_dao.dart';
import 'package:litenews/models/convert_utils.dart';
import 'package:litenews/models/hellogithub/hello_item_bean.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../objectbox.g.dart';


/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<HelloItemDao> _noteBox;

  ObjectBox._create(this._store) {
    _noteBox = Box<HelloItemDao>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
        directory:
            p.join((await getApplicationDocumentsDirectory()).path, "litenews-db"),
        macosApplicationGroup: "hellogithub.db");
    return ObjectBox._create(store);
  }

  Stream<List<HelloItemDao>> getNotes() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder = _noteBox.query().order(HelloItemDao_.id, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder
        .watch(triggerImmediately: true)
        // Map it to a list of notes to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  /// Add a note.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, asynchronously.
  /// For this example only a single object is put which would also be fine if
  /// done using [Box.put].
  Future<void> addNote(HelloItemBean bean) => _noteBox.putAsync(ConvertUtils.getHelloItemDao(
      bean));

  Future<void> removeNote(int id) => _noteBox.removeAsync(id);
}
