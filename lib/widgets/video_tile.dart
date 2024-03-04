import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocks/favorite_bloc.dart';
import 'package:flutter_tube/models/video.dart';

class VideoTile extends StatelessWidget {
  final Video video;
  const VideoTile({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<FavoriteBloc>();
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              video.thumb!,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        maxLines: 2,
                        video.title!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        video.channel!,
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<Map<String, Video>>(
                  initialData: const {},
                  stream: bloc.outFav,
                  builder: (contex, snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        onPressed: () {
                          bloc.toggleFavorite(video);
                        },
                        icon: Icon(
                          snapshot.data!.containsKey(video.id)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.white,
                          size: 36,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          )
        ],
      ),
    );
  }
}
