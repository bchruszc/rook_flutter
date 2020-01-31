import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

String RookWebsite = "http://beta.rook3.chruszcz.ca/api";
String PlayerList = "/players";

class APIRequest {
  Future<GetListResponse> getAPI(String api) async {
    String fullURL = RookWebsite + api;
    final response = await http.get(fullURL);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var typeResponse = json.decode(response.body);
      if (typeResponse is List<dynamic>) {
        GetListResponse getResponse = GetListResponse(typeResponse);
        return getResponse;
      }
      throw Exception('Havent supported this response yet $typeResponse');
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to get $fullURL');
    }
  }
}

class GetListResponse {
  final List<dynamic> jsons;

  GetListResponse(this.jsons);
}
