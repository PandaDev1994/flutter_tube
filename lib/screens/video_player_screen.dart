import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tube/blocks/favorite_bloc.dart';
import 'package:flutter_tube/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatelessWidget {
  final Video video;
  const VideoPlayer({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();

    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: video.id!,
      flags: const YoutubePlayerFlags(
          captionLanguage: 'pt',
          hideThumbnail: true,
          controlsVisibleAtStart: true,
          autoPlay: false,
          mute: false,
          isLive: false,
          forceHD: true,
          loop: false,
          enableCaption: true),
    );
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        thumbnail: Text(video.thumb!),
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.white,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.white,
        ),
        aspectRatio: 16 / 9,
        topActions: [
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              controller.metadata.title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          PopupMenuButton(
            iconColor: Colors.white,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child:
                    TextButton(onPressed: () {}, child: const Text('closed')),
              ),
              const PopupMenuItem<String>(
                child: Text('play'),
              ),
            ],
          )
        ],
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(
            video.title!,
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.black87,
          actions: [
            StreamBuilder<Map<String, Video>>(
              stream: bloc.outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    onPressed: () {
                      bloc.toggleFavorite(video);
                    },
                    icon: Icon(
                      snapshot.data!.containsKey(video.id!)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Titulo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    video.title!,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                  ),
                  const Divider(
                    color: Colors.black87,
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 26,
                        color: Colors.black87,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        video.channel!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
