import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final String apiKey = dotenv.get('GOOGLE_MAP_API_KEY');
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

//anonymous_post_get用API
// [
//   {
//     "id": 0,
//     "userId": "string",
//     "timelineId": 0,
//     "googleMapShopId": "string",
//     "star": 0,
//     "imageList": [
//       {
//         "id": 0,
//         "anonymousPostId": 0,
//         "imageURL": "string",
//         "createdAt": "2023-11-13T08:39:47.868Z",
//         "updatedAt": "2023-11-13T08:39:47.868Z"
//       }
//     ],
//     "createdAt": "2023-11-13T08:39:47.868Z",
//     "updatedAt": "2023-11-13T08:39:47.868Z"
//   }
// ]
class AnonymousPostAPIResult {
  final int id;
  final String userId;
  final int timelineId;
  final String googleMapShopId;
  final double star;
  final List<ApiImageData> imageList;
  final String createdAt;
  final String updatedAt;

  AnonymousPostAPIResult(
      {required this.id,
      required this.userId,
      required this.timelineId,
      required this.googleMapShopId,
      required this.star,
      required this.imageList,
      required this.createdAt,
      required this.updatedAt});

  factory AnonymousPostAPIResult.fromJson(Map<String, dynamic> data) {
    int idResult = data["id"];
    String userIdResult = data["userId"];
    int timelineIdResult = data["timelineId"];
    String googleMapShopIdResult = data["googleMapShopId"];
    double starResult = data["star"];
    List<ApiImageData> imageListResult = [];
    for (var item in data["imageList"]) {
      imageListResult.add(ApiImageData.fromJson(item));
    }
    String createdAtResult = data["createdAt"];
    String updatedAtResult = data["updatedAt"];
    return AnonymousPostAPIResult(
        id: idResult,
        userId: userIdResult,
        timelineId: timelineIdResult,
        googleMapShopId: googleMapShopIdResult,
        star: starResult,
        imageList: imageListResult,
        createdAt: createdAtResult,
        updatedAt: updatedAtResult);
  }
}

class ApiImageData {
  final int id;
  final int anonymousPostId;
  final String imageURL;
  final String createdAt;
  final String updatedAt;

  ApiImageData(
      {required this.id,
      required this.anonymousPostId,
      required this.imageURL,
      required this.createdAt,
      required this.updatedAt});

  factory ApiImageData.fromJson(Map<String, dynamic> data) {
    int idResult = data["id"];
    int anonymousPostIdResult = data["anonymousPostId"];
    String imageURLResult = data["imageURL"];
    String createdAtResult = data["createdAt"];
    String updatedAtResult = data["updatedAt"];
    return ApiImageData(
        id: idResult,
        anonymousPostId: anonymousPostIdResult,
        imageURL: imageURLResult,
        createdAt: createdAtResult,
        updatedAt: updatedAtResult);
  }
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
  static Future<(List<AnonymousPostAPIResult>, String)> requestAnonymousAPI(
      String? token) async {
    const String apiUrl = 'https://gohanmap.almikan.com/api/anonymous-post';
    List<AnonymousPostAPIResult> result = [];
    try {
      var response = await client.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode != 200) {
        throw json.decode(response.body)["detail"];
      }
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseData) {
        result.add(AnonymousPostAPIResult.fromJson(item));
      }
    } catch (e) {
      logger.e(e);
      return (result, e.toString());
    }
    if (result.isEmpty) {
      return (result, "投稿がありませんでした..");
    }
    return (result, "");
  }

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
      // 正常の場合は空文字がレスポンスされるので、json.decodeをしない
      if (response.statusCode != 201) {
        final Map<String, dynamic>? responseData =
            json.decode(utf8.decode(response.bodyBytes));
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

  //アカウント削除API
  static Future<String> requestDeleteUserAPI(String? token) async {
    const String apiUrl = 'https://gohanmap.almikan.com/api/user/withdraw';
    try {
      var response = await client.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
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
