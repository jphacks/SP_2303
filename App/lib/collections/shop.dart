import 'package:isar/isar.dart';

part 'shop.g.dart';

@Collection()
class Shop {
  Id id = Isar.autoIncrement;

  late String googlePlaceId;
  late String shopName;
  late String shopAddress;
  late String shopMapIconKind;
  late bool wantToGoFlg;
  late double shopLatitude;
  late double shopLongitude;
  late DateTime createdAt;
  late DateTime updatedAt;
}
