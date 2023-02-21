import 'dart:async';

import 'package:hello/utils/color_palette.dart';
import 'package:flutter/material.dart';

void buildMaterialBanner({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: kNeutralColors[1],
            ),
      ),
      actions: [SizedBox()],
    ),
  );
  Timer(
    Duration(seconds: 5),
    () => ScaffoldMessenger.of(context).clearMaterialBanners(),
  );
}
