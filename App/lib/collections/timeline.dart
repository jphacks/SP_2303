import 'package:isar/isar.dart';

part 'timeline.g.dart';

@Collection()
class Timeline {
  Id id = Isar.autoIncrement;

  late List<String> images;
  late String comment;
  late double star;
  late bool isPublic;
  late DateTime createdAt;
  late DateTime updatedAt;
  @Index()
  late int shopId;
  late DateTime date;
}
