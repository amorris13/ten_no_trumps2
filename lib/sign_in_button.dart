import 'dart:async';

import 'package:flutter/material.dart';

typedef FutureFunction = Future Function();

class SignInButton extends StatefulWidget {
  final Color color;
  final String label;
  final Image image;
  final FutureFunction onPressed;

  SignInButton(this.color, this.label, this.image, this.onPressed);

  void progressComplete(BuildContext context) {
    _SignInButtonState state =
        context.ancestorStateOfType(const TypeMatcher<_SignInButtonState>());
    state._progressComplete();
  }

  @override
  State<StatefulWidget> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool _progress = false;

  void _progressComplete() {
    setState(() {
      _progress = false;
    });
  }

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: RaisedButton(
        color: widget.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                child: widget.image),
            buildButtonChild(),
          ],
        ),
        onPressed: widget.onPressed == null
            ? null
            : () {
                setState(() {
                  _progress = true;
                });
                widget.onPressed.call().whenComplete(() {
                  setState(() {
                    _progress = false;
                  });
                });
              },
      ),
    );
  }

  Widget buildButtonChild() {
    if (_progress) {
      return SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else {
      return Text(widget.label);
    }
  }

  void reset() {
    _progress = false;
  }
}
