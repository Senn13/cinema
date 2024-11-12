import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:cinema/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class AppErrorWidget extends StatelessWidget{

  final AppErrorType errorType;
  final VoidCallback onPressed;

  const AppErrorWidget({
    Key? key,
    required this.errorType,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_32.w.toDouble()),
      child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text(
        errorType == AppErrorType.api
        ? TranslationConstants.somethingWentWrong.t(context) 
        : TranslationConstants.checkNetwork.t(context),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      ButtonBar(
        children: [
          Button(
            onPressed: onPressed,
            text: TranslationConstants.retry,
          ),
          Button(
            onPressed: () => Wiredash.of(context).show(),
            text: TranslationConstants.feedback,
          ),
        ],
      )
      ],
      )
    );
  }
}