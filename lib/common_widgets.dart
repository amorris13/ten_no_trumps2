import 'package:flutter/material.dart';

class LeaveBehindWidget extends StatelessWidget {
  const LeaveBehindWidget({
    Key key,
    @required this.alignment,
  }) : super(key: key);

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      color: Colors.red[700],
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
