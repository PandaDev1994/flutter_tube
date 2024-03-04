import 'dart:convert';
import 'package:flutter_tube/models/video.dart';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyA6ttnCYO1ZUXHe5mdRe9jQVgSCYnry9Io';

// "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
// "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
// "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {
  String? _search;
  String? _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;
    var url = Uri.https("www.googleapis.com", "/youtube/v3/search", {
      "part": "snippet",
      "q": search,
      "type": "video",
      "key": apiKey,
      "maxResults": "10",
    });
    http.Response response = await http.get(url);

    return decode(response)!;
  }

  Future<List<Video>> nextPage() async {
    var url = Uri.https("www.googleapis.com", "/youtube/v3/search", {
      "part": "snippet",
      "q": _search,
      "type": "video",
      "key": apiKey,
      "maxResults": "10",
      "pageToken": _nextToken,
    });
    http.Response response = await http.get(url);

    return decode(response)!;
  }

  List<Video>? decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      _nextToken = decoded['nextPageToken'];

      List<Video> videos = decoded['items'].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
