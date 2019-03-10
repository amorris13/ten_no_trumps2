import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

import 'model/bid.dart';
import 'model/hand.dart';

class NewHandScreen extends StatefulWidget {
  final DocumentReference matchReference;
  final DocumentReference roundReference;

  NewHandScreen(this.matchReference, this.roundReference);

  @override
  _NewHandScreenState createState() {
    return _NewHandScreenState();
  }
}

class _NewHandScreenState extends State<NewHandScreen> {
  final _formKey = GlobalKey<FormState>();

  HandBuilder handBuilder = HandBuilder();

  _NewHandScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Hand")),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            FormField<Bid>(
              initialValue: null,
              validator: (bid) {
                if (bid == null) {
                  return 'Bid must be set';
                }
              },
              onSaved: (bid) {
                handBuilder.bid = bid.toFullString();
              },
              builder: (FormFieldState<Bid> state) {
                Multimap<Tricks, Bid> bidsByTricks = Multimap.fromIterable(
                    Bid.BIDS,
                    key: (bid) => bid.tricks,
                    value: (bid) => bid);
                var rows = <Widget>[];
                bidsByTricks.forEachKey((tricks, bids) {
                  var buttons = <Widget>[];
                  bids.forEach((bid) {
                    buttons.add(Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: RaisedButton(
                          onPressed: () {
                            state.didChange(state.value == bid ? null : bid);
                          },
                          padding: const EdgeInsets.all(0.0),
                          child: Text(bid.getSymbol()),
                          color: state.value == bid
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                    ));
                  });
                  rows.add(Row(children: buttons));
                });
                if (state.hasError) {
                  rows.add(Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            state.errorText,
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ));
                }
                return Column(children: rows);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // matchBuilder.lastPlayed = DateTime.now();
                    // matchBuilder.teamA.wins = 0;
                    // matchBuilder.teamB.wins = 0;

                    // DocumentReference matchReference =
                    //     Firestore.instance.collection("matches").document();
                    // matchReference.setData(matchBuilder.build().toMap());
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => MatchScreen(matchReference)),
                    // );
                  }
                },
                child: Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
