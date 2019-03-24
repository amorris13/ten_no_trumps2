import 'package:flutter/material.dart';

import 'model/scoring_prefs.dart';

class ScoringPrefsDialog extends StatefulWidget {
  final ScoringPrefs scoringPrefs;

  ScoringPrefsDialog(this.scoringPrefs);

  @override
  State<StatefulWidget> createState() => _ScoringPrefsDialogState();
}

class _ScoringPrefsDialogState extends State<ScoringPrefsDialog> {
  ScoringPrefsBuilder scoringPrefsBuilder;

  @override
  void initState() {
    super.initState();
    scoringPrefsBuilder =
        (widget.scoringPrefs ?? ScoringPrefs.createDefault()).toBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Scoring Preferences"),
      contentPadding: EdgeInsets.only(left: 8.0, top: 8.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: Text("Non bidding points"),
            trailing: DropdownButton<NonBiddingPointsEnum>(
              value: scoringPrefsBuilder.nonBiddingPoints,
              onChanged: (NonBiddingPointsEnum newValue) {
                setState(() {
                  scoringPrefsBuilder.nonBiddingPoints = newValue;
                });
              },
              items: NonBiddingPointsEnum.values
                  .map((NonBiddingPointsEnum value) =>
                      DropdownMenuItem<NonBiddingPointsEnum>(
                        value: value,
                        child: Text(NonBiddingPointsEnum.getText(value)),
                      ))
                  .toList(),
            ),
          ),
          ListTile(
            title: Text("Ten trick bonus"),
            trailing: Checkbox(
              value: scoringPrefsBuilder.tenTrickBonus,
              onChanged: (val) {
                setState(() {
                  scoringPrefsBuilder.tenTrickBonus = val;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(widget.scoringPrefs),
        ),
        FlatButton(
          child: Text('Save'),
          onPressed: () =>
              Navigator.of(context).pop(scoringPrefsBuilder.build()),
        ),
      ],
    );
  }
}
