import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileTextInfo extends StatelessWidget {
  const ProfileTextInfo({
    super.key,
    required this.title,
    required this.content,
    required this.editHandler,
  });

  final String title;
  final String content;
  final VoidCallback editHandler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 220.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: kNeutralColors[2],
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.15 * kPadding),
              Text(
                content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kNeutralColors[0],
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: editHandler,
          icon: Icon(
            FontAwesomeIcons.penToSquare,
            size: 20.0,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}
