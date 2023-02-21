import 'package:hello/utils/color_palette.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class FormController extends StatelessWidget {
  const FormController({
    super.key,
    required this.formPosition,
    required this.backwardHandler,
    required this.forwardHandler,
  });

  final int formPosition;
  final VoidCallback backwardHandler;
  final VoidCallback forwardHandler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ArrowIconButton(
          visible: formPosition > 0,
          arrowIcon: Icons.arrow_back_ios,
          onPressed: backwardHandler,
        ),
        DotsIndicator(
          position: formPosition.toDouble(),
          dotsCount: 3,
          decorator: DotsDecorator(
            activeColor: kPrimaryColor,
          ),
        ),
        _ArrowIconButton(
          visible: formPosition < 2,
          arrowIcon: Icons.arrow_forward_ios,
          onPressed: forwardHandler,
        ),
      ],
    );
  }
}

class _ArrowIconButton extends StatelessWidget {
  const _ArrowIconButton({
    required this.visible,
    required this.arrowIcon,
    required this.onPressed,
  });

  final bool visible;
  final IconData arrowIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          arrowIcon,
          size: 30.0,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
