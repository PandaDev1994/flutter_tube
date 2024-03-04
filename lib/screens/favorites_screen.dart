import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocks/favorite_bloc.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:flutter_tube/screens/video_player_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blocFavorite = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<Map<String, Video>>(
          stream: blocFavorite.outFav,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.values.map((v) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayer(
                            video: v,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      blocFavorite.toggleFavorite(v);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: Image.network(v.thumb!),
                        ),
                        Expanded(
                            child: Text(
                          v.title!,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                        ))
                      ],
                    ),
                  );
                }).toList(),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  playar(String id, String title) {
    YoutubePlayerController controller;
    controller = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
      ),
    );

    YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.white,
          progressColors: const ProgressBarColors(
              playedColor: Colors.amber, handleColor: Colors.red),
        ),
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              title: Text(id),
            ),
            body: player,
          );
        });
  }
}
