import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gohan_map/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';
import 'package:http_parser/http_parser.dart';

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
  final String googleMapShopId;
  final double latitude;
  final double longitude;
  final double star;
  final String imageURL;

  SwipeUIAPIResult(
      {required this.name,
      required this.address,
      required this.googleMapShopId,
      required this.latitude,
      required this.longitude,
      required this.star,
      required this.imageURL});

  factory SwipeUIAPIResult.fromJson(Map<String, dynamic> data) {
    String nameResult = data["googleMapShop"]["name"];
    String addressResult = data["googleMapShop"]["address"];
    String shopIdResult = data["googleMapShop"]["googleMapShopId"];
    double latitudeResult = data["googleMapShop"]["latitude"];
    double longitudeResult = data["googleMapShop"]["longitude"];
    double starResult = data["star"];
    String imageResult = data["imageURL"];
    return SwipeUIAPIResult(
        name: nameResult,
        address: addressResult,
        googleMapShopId: shopIdResult,
        latitude: latitudeResult,
        longitude: longitudeResult,
        star: starResult,
        imageURL: imageResult);
  }
}

class PostAPIRequest {
  final int timelineId;
  final String googleMapShopId;
  final double longitude;
  final double latitude;
  final double star;
  final String name;
  final String address;
  final List<List<byte>> imageList;

  PostAPIRequest(
      {required this.timelineId,
      required this.googleMapShopId,
      required this.longitude,
      required this.latitude,
      required this.star,
      required this.name,
      required this.address,
      required this.imageList});
  //multipart/form-data
  //makeRequest
  MultipartRequest makeRequest(String? token) {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://gohanmap.almikan.com/api/anonymous-post'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields['timelineId'] = timelineId.toString();
    request.fields['googleMapShopId'] = googleMapShopId;
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['star'] = star.toString();
    request.fields['name'] = name;
    request.fields['address'] = address;
    for (var item in imageList) {
      request.files.add(http.MultipartFile.fromBytes('imageList', item,
          filename: "image.jpg", contentType: MediaType.parse('image/jpeg')));
    }
    return request;
  }
}

//
// アプリのAPIを叩くためのクラス
//
class APIService {
  static Future<(List<SwipeUIAPIResult>, String)> requestSwipeAPI(
      LatLng latlng, int radius, String? token) async {
    final String apiUrl =
        'https://gohanmap.almikan.com/api/swipe/anonymous-post?latitude=${latlng.latitude}&longitude=${latlng.longitude}&radius=$radius';
    List<SwipeUIAPIResult> result = [];
    try {
      var response = await client.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode != 200) {
        throw json.decode(response.body)["detail"];
      }
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseData) {
        result.add(SwipeUIAPIResult.fromJson(item));
      }
    } catch (e) {
      logger.e(e);
      return (result, e.toString());
    }
    if (result.isEmpty) {
      return (result, "紹介できるお店が近くにありませんでした..");
    }
    return (result, "");
  }

  static Future<String> requestPostAPI(
      PostAPIRequest postApiRequest, String? token) async {
    try {
      var request = postApiRequest.makeRequest(token);
      debugPrint(request.fields.toString());
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final Map<String, dynamic>? responseData =
          json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 201) {
        //throw json.decode(response.body);
        throw responseData!["detail"];
      }
      return "";
    } catch (e) {
      logger.e(e);
      return e.toString();
    }
  }

  static Future<String> requestDeleteAPI(int timelineID, String? token) async {
    const String apiUrl = 'https://gohanmap.almikan.com/api/anonymous-post';
    try {
      var response = await client.delete(Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: json.encode({'timelineId': timelineID}));
      if (response.statusCode != 204) {
        throw json.decode(response.body)["detail"];
      }
    } catch (e) {
      logger.e(e);
      return (e.toString());
    }
    return "";
  }
}
