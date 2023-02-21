import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({
    super.key,
    required this.items,
    required this.itemOnTap,
  });

  final List<String> items;
  final void Function(String) itemOnTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: false),
      child: PopupMenuButton<String>(
        tooltip: '',
        icon: Icon(FontAwesomeIcons.ellipsisVertical),
        itemBuilder: (context) => items
            .map(
              (value) => PopupMenuItem<String>(
                value: value,
                onTap: () async => await Future(
                  () => itemOnTap(value),
                ),
                child: Text(value),
              ),
            )
            .toList(),
      ),
    );
  }
}
