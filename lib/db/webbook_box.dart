import 'package:litenews/db/web_book_dao.dart';

import '../objectbox.g.dart';

class WebbookBox {
  /// A Box of notes.
  late final Box<WebBookDao> _noteBox;

  void initBox(Box<WebBookDao> box) {
    this._noteBox = box;
  }

  Stream<List<WebBookDao>> getNotes() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder =
        _noteBox.query().order(WebBookDao_.id, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder
        .watch(triggerImmediately: true)
        // Map it to a list of notes to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  Stream<WebBookDao?> getNotesById(String itemId) {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder = _noteBox
        .query(WebBookDao_.item_id.equals(itemId))
        .order(WebBookDao_.id, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder.watch(triggerImmediately: true).map((query) => query.findFirst());
  }

  /// Add a note.
  ///
  /// To avoid frame drops, run ObjectBox operations that take longer than a
  /// few milliseconds, e.g. putting many objects, asynchronously.
  /// For this example only a single object is put which would also be fine if
  /// done using [Box.put].
  Future<void> addNote(WebBookDao bean) => _noteBox.putAsync(bean);

  Future<void> removeNote(int id) => _noteBox.removeAsync(id);

  Future<WebBookDao?> readNote(int id) {
    return _noteBox.getAsync(id);
  }
}
