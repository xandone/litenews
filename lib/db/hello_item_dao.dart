import 'package:objectbox/objectbox.dart';

@Entity()
class HelloItemDao {
  @Id()
  int id;

  HelloItemDao({
    this.id = 0,
    required this.type,
    required this.item_id,
    required this.primary_lang,
    required this.title,
    required this.updated_at,
    this.author = '',
    this.author_avatar = '',
    this.comment_total = 0,
    this.name = '',
    this.summary = '',
    this.summary_en = '',
    this.title_en = '',
  });

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
  int type;
}
