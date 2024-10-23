import 'package:objectbox/objectbox.dart';

@Entity()
class WebBookDao {
  @Id()
  int id;

  WebBookDao({
    this.id = 0,
    required this.item_id,
    required this.current_url,
  });

  String item_id;
  String current_url;
}
