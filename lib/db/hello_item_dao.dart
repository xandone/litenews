import 'package:objectbox/objectbox.dart';

@Entity()
class HelloItemDao {
  @Id()
  int id;

  HelloItemDao(
      {this.id = 0,
      required this.author,
      required this.author_avatar,
      required this.comment_total,
      required this.item_id,
      required this.name,
      required this.primary_lang,
      required this.summary,
      required this.summary_en,
      required this.title,
      required this.title_en,
      required this.updated_at});

  String author;
  String author_avatar;
  int comment_total;
  String item_id;
  String name;

  String primary_lang;
  String summary;
  String summary_en;
  String title;
  String title_en;

  String updated_at;
}
