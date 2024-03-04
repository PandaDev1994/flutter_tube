import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocks/favorite_bloc.dart';
import 'package:flutter_tube/blocks/videos_block.dart';
import 'package:flutter_tube/delegates/data_searche.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/screens/favorites_screen.dart';
import 'package:flutter_tube/widgets/video_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final blocFavorit = BlocProvider.getBloc<FavoriteBloc>();
  final blocVideo = BlocProvider.getBloc<VideosBloc>();
  String url =
      'https://s2-techtudo.glbimg.com/twL-iutP86bVd1sCcaL_65vUzvA=/400x0/smart/filters:strip_icc()/s.glbimg.com/po/tt2/f/original/2015/09/10/youtube_1.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: SizedBox(
          height: 40,
          width: 150,
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          StreamBuilder<Map<String, Video>>(
            initialData: const {},
            stream: blocFavorit.outFav,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data!.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                );
              } else {
                return Container();
              }
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteScreen()));
              },
              icon: const Icon(
                Icons.star,
                size: 30,
                color: Colors.white,
              )),
          IconButton(
            onPressed: () async {
              String? result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                BlocProvider.getBloc<VideosBloc>().inSearch.add(result);
              }
            },
            icon: const AnimatedIcon(
              icon: AnimatedIcons.search_ellipsis,
              progress: kAlwaysDismissedAnimation,
            ),
            iconSize: 30,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder(
          initialData: const [],
          stream: blocVideo.outVideos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (snapshot.hasData && index < snapshot.data.length) {
                    return VideoTile(
                      video: snapshot.data[index],
                    );
                  } else if (index > 1) {
                    blocVideo.inSearch.add('');
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
