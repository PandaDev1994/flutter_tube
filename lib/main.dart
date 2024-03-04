import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocks/favorite_bloc.dart';
import 'package:flutter_tube/blocks/videos_block.dart';
import 'package:flutter_tube/api/api.dart';
import 'package:flutter_tube/screens/home_screen.dart';

void main() {
  Api api = Api();
  api.search('eletro');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get blocs => null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        blocs: [Bloc((_) => VideosBloc()), Bloc((_) => FavoriteBloc())],
        dependencies: const [],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(),
        ));
  }
}
