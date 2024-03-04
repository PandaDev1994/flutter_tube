import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/api/api.dart';

class VideosBloc implements BlocBase {
  Api? api;

  List<Video>? videos;

  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();

    _searchController.stream.listen((_search));
  }

  void _search(String search) async {
    if (search != '') {
      _videosController.sink.add([]);
      videos = await api!.search(search);
    } else {
      videos = videos! + await api!.nextPage();
    }

    if (videos != null) {
      _videosController.sink.add(videos!);
    } else {
      // ignore: avoid_print
      print('deu erro');
    }
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}
}
