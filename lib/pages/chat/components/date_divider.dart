import 'package:flutter/material.dart';
import 'package:hello/helpers/date_helpers.dart';
import 'package:hello/utils/constants.dart';

class DateDivider extends StatelessWidget {
  const DateDivider({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateText = DateHelpers.isToday(date)
        ? 'Today'
        : DateHelpers.isYesterday(date)
            ? 'Yesterday'
            : DateHelpers.getDateText(date);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              height: 0.0,
              thickness: 1.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.5 * kPadding),
            child: Text(dateText),
          ),
          Expanded(
            child: Divider(
              height: 0.0,
              thickness: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
