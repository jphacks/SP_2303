import 'dart:convert';

import 'package:gohan_map/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

http.Client client = http.Client(); // HTTPクライアントを格納する

class PlaceApiRestaurantResult {
  final LatLng latlng;
  final String name;
  final String placeId;
  final String address;

  PlaceApiRestaurantResult(
      {required this.latlng,
      required this.name,
      required this.placeId,
      required this.address});

  factory PlaceApiRestaurantResult.fromJson(Map<String, dynamic> data) {
    LatLng latlngResult = LatLng(data["geometry"]["location"]["lat"],
        data["geometry"]["location"]["lng"]);
    String nameResult = data["name"];
    String placeIdResult = data["place_id"];
    String addressResult = data["vicinity"];
    return PlaceApiRestaurantResult(
        latlng: latlngResult,
        name: nameResult,
        placeId: placeIdResult,
        address: addressResult);
  }
}

Future<List<PlaceApiRestaurantResult>> searchRestaurantsByGoogleMapApi(
    String keyword, LatLng latlng) async {
  const String apiKey = String.fromEnvironment("GOOGLE_MAP_API_KEY");
  final String apiUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$keyword&location=${latlng.latitude},${latlng.longitude}&rankby=distance&type=food&language=ja&key=$apiKey';
  List<PlaceApiRestaurantResult> result = [];

  try {
    var response = await client.get(Uri.parse(apiUrl));
    if (response.statusCode != 200) throw "通信に失敗しました";

    final responseData = json.decode(response.body);
    if (responseData["status"] != "OK") throw "APIリクエストに失敗しました";

    for (var item in responseData["results"]) {
      result.add(PlaceApiRestaurantResult.fromJson(item));
    }
  } catch (e) {
    logger.e(e);
  }

  return result;
}
