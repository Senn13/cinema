import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/presentation/blocs/videos/videos_bloc.dart';
import 'package:cinema/presentation/journeys/watch_video/watch_video_argruments.dart';
import 'package:cinema/presentation/journeys/watch_video/watch_video_screen.dart';
import 'package:cinema/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideosWidget extends StatelessWidget {
  final VideosBloc? videosBloc;

  const VideosWidget({
    Key? key,
    this.videosBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: videosBloc,
      builder: (context, state) {
        if (state is VideosLoaded && state.videos.iterator.moveNext()) {
          final _videos = state.videos;
          return Button(
            text: TranslationConstants.watchTrailers,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WatchVideoScreen(
                    watchVideoArguments: WatchVideoArguments(_videos),
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}