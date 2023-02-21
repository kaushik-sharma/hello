import 'dart:async';

import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class ResendSmsCodeButton extends StatefulWidget {
  const ResendSmsCodeButton({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  State<ResendSmsCodeButton> createState() => _ResendSmsCodeButtonState();
}

class _ResendSmsCodeButtonState extends State<ResendSmsCodeButton> {
  final _stopwatch = Stopwatch();
  final _resendInterval = kSmsCodeResendInterval;
  var _resendButtonEnabled = false;

  void _resendOtp() async {
    _resendButtonEnabled = false;
    _stopwatch.reset();
    _stopwatch.start();
    await FirebaseServices.sendVerificationCode(
      context: context,
      phoneNumber: widget.phoneNumber,
    );
  }

  @override
  void initState() {
    _stopwatch.start();
    Timer.periodic(
      Duration(milliseconds: 16),
      (timer) {
        if (_resendButtonEnabled) {
          return;
        }
        if ((_resendInterval - _stopwatch.elapsed).inMilliseconds <= 0) {
          _resendButtonEnabled = true;
          _stopwatch.stop();
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _resendButtonEnabled
        ? TextButton(
            onPressed: _resendOtp,
            child: Text('Resend code'),
          )
        : _WaitingMessage(
            stopwatch: _stopwatch,
            resendInterval: _resendInterval,
          );
  }
}

class _WaitingMessage extends StatelessWidget {
  const _WaitingMessage({
    required this.stopwatch,
    required this.resendInterval,
  });

  final Stopwatch stopwatch;
  final Duration resendInterval;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Resend code in'),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.2 * kPadding,
          ),
          child: SizedBox(
            width: 30.0,
            height: 30.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1.0 -
                      stopwatch.elapsedMilliseconds /
                          resendInterval.inMilliseconds,
                  backgroundColor: kNeutralColors[2].withOpacity(0.5),
                  strokeWidth: kLineThickness,
                ),
                Text('${(resendInterval - stopwatch.elapsed).inSeconds}'),
              ],
            ),
          ),
        ),
        Text('seconds.'),
      ],
    );
  }
}
