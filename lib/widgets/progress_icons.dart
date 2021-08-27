import 'package:flutter/material.dart';

class ProgressIcons extends StatelessWidget {
  final int? total;
  final int? done;

  const ProgressIcons({this.total, this.done});

  @override
  Widget build(BuildContext context) {
    final iconSize = 50.0;
    final doneIcon = Icon(
      Icons.beenhere,
      size: iconSize,
      color: Colors.orange,
    );

    final notDoneIcon = Icon(
      Icons.beenhere_outlined,
      size: iconSize,
      color: Colors.orange[100],
    );

    List<Icon> icons = [];

    for (int i = 0; i < total!; i++) {
      if (i < done!) {
        icons.add(doneIcon);
      } else {
        icons.add(notDoneIcon);
      }
    }

    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: icons,
      ),
    );
  }
}
