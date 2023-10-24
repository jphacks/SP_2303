import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gohan_map/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';

http.Client client = http.Client(); // HTTPクライアントを格納する

//placeAPI
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

//SwipeUI用API
class SwipeUIAPIResult {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double star;
  final byte image;

  SwipeUIAPIResult(
      {required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.star,
      required this.image});

  factory SwipeUIAPIResult.fromJson(Map<String, dynamic> data) {
    String nameResult = data["name"];
    String addressResult = data["address"];
    double latitudeResult = data["latitude"];
    double longitudeResult = data["longitude"];
    double starResult = data["star"];
    byte imageResult = data["image"];
    return SwipeUIAPIResult(
        name: nameResult,
        address: addressResult,
        latitude: latitudeResult,
        longitude: longitudeResult,
        star: starResult,
        image: imageResult);
  }
}

class APIService {
  static Future<List<SwipeUIAPIResult>?> requestSwipeAPI(
      LatLng latlng, int radius, String token) async {
    final String apiUrl =
        'https://gohanmap.almikan.com/api/swipe/anonymous-post?latitude=${latlng.latitude}&longitude=${latlng.longitude}&radius=$radius';
    List<SwipeUIAPIResult> result = [];

    try {
      var response = await client.get(Uri.parse(apiUrl));
      debugPrint(response.body);
      if (response.statusCode != 200) throw "通信に失敗しました";

      final responseData = json.decode(response.body);
      if (responseData["status"] != "OK") throw "APIリクエストに失敗しました";

      for (var item in responseData["results"]) {
        result.add(SwipeUIAPIResult.fromJson(item));
      }
    } catch (e) {
      logger.e(e);
      return null;
    }

    return result;
  }
}
