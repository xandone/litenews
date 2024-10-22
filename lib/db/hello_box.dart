import '../models/convert_utils.dart';
import '../models/hellogithub/hello_item_bean.dart';
import '../objectbox.g.dart';
import '../ui/collect/deal_type.dart';
import 'hello_item_dao.dart';

class HelloBox {
  /// A Box of notes.
  late final Box<HelloItemDao> _noteBox;

  void initBox(Box<HelloItemDao> box) {
    this._noteBox = box;
  }

  Stream<List<HelloItemDao>> getNotes(DealType dealType) {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder = _noteBox
        .query(HelloItemDao_.deal_type
            .equals(dealType == DealType.collectionType ? 1 : 2))
        .order(HelloItemDao_.id, flags: Order.descending);
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
  Future<void> addNote(HelloItemDao bean) => _noteBox.putAsync(bean);

  Future<void> removeNote(int id) => _noteBox.removeAsync(id);
}
