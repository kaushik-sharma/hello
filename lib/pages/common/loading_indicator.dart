import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 1.5 * kLineThickness,
      ),
    );
  }
}
