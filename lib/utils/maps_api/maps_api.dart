library MapsAPI;

import 'dart:core';
import 'dart:io';
import 'dart:convert';

import 'package:bnbscout24/utils/maps_api/search_result.dart';
import 'package:http/http.dart' as http;

class MapsAPI {
  MapsAPI();

  Future<List<SearchResult>?> resolve(String query) async {
    dynamic json;

    http.Response s = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyDvJ1IjXYh8FvzmDoaKQISESQTH_tnDfbM&address=${query}"));


    try {
      json = jsonDecode(s.body);

      print(json);

      if (json != null) {
        dynamic gResults = json["results"];

        List<SearchResult> resultList = List.empty(growable: true);

        for (dynamic map in gResults) {
          double lat = map['geometry']["location"]["lat"];
          double lon = map['geometry']["location"]["lng"];
          String displayName = map['formatted_address'];

          resultList.add(SearchResult(
              latitude: lat,
              longitude: lon,
              displayName: displayName));
        }
        return resultList;
      }
    } catch (e) {
      print("WARNING: Failed to parse json output.");
      print(e);
      return null;
    }
  }
}
