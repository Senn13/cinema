import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/data/core/api_constants.dart';
import 'package:cinema/presentation/blocs/cast/cast_bloc.dart';
import 'package:cinema/presentation/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CastBloc, CastState>(
      builder: (context, state) {
        if (state is CastLoaded) {
          return Container(
            height: Sizes.dimen_100.h.toDouble(),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.casts.length,
              itemBuilder: (context, index) {
                final castEntity = state.casts[index];
                return Container(
                  height: Sizes.dimen_100.h.toDouble(),
                  width: Sizes.dimen_160.w.toDouble(),
                  child: Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(
                      horizontal: Sizes.dimen_8.w.toDouble(),
                      vertical: Sizes.dimen_4.h.toDouble(),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Sizes.dimen_8.w.toDouble()),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8.w.toDouble()),
                            ),
                            child: CachedNetworkImage(
                              height: Sizes.dimen_100.h.toDouble(),
                              width: Sizes.dimen_160.w.toDouble(),
                              imageUrl:
                                  '${ApiConstants.BASE_IMAGE_URL}${castEntity.posterPath}',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.dimen_8.w.toDouble(),
                          ),
                          child: Text(
                            castEntity.name,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Sizes.dimen_8.w.toDouble(),
                            right: Sizes.dimen_8.w.toDouble(),
                            bottom: Sizes.dimen_2.h.toDouble(),
                          ),
                          child: Text(
                            castEntity.character,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}