import 'package:flutter/material.dart';
import 'package:social_contact_tracker/model/covid_status.dart';
import 'package:social_contact_tracker/widgets/flat_round_icon_button.dart';

class CovidStatusChangeDialog extends StatefulWidget {
  final int statusShareContactCount;
  final CovidStatus currentCovidStatus;

  const CovidStatusChangeDialog(
      {Key key, this.statusShareContactCount, this.currentCovidStatus})
      : super(key: key);

  @override
  _CovidStatusChangeDialogState createState() =>
      _CovidStatusChangeDialogState();
}

class _CovidStatusChangeDialogState extends State<CovidStatusChangeDialog> {
  CovidStatus _covidStatus;

  @override
  void initState() {
    super.initState();
    _covidStatus = widget.currentCovidStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: new Hero(
              tag: "preview",
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Neuen Status wählen',
                        style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      _getCovidStatusRow(CovidStatus.NO_CONTACT),
                      const SizedBox(height: 8),
                      _getCovidStatusRow(CovidStatus.CONTACT_2),
                      const SizedBox(height: 8),
                      _getCovidStatusRow(CovidStatus.CONTACT_1),
                      const SizedBox(height: 8),
                      _getCovidStatusRow(CovidStatus.POSITIVE),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Text(
                              '${widget.statusShareContactCount} Leute werden\nbenachrichtigt'),
                          Spacer(),
                          FlatRoundIconButton(
                            child: Text('Status updaten'),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            onTap: () {
                              Navigator.of(context).pop(_covidStatus);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCovidStatusRow(CovidStatus covidStatus) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(99)),
      onTap: () {
        setState(() {
          _covidStatus = covidStatus;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: covidStatus == _covidStatus
            ? BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.all(Radius.circular(99)),
              )
            : BoxDecoration(),
        child: Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: covidStatus.toBackgroundColor(),
                  shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              covidStatus.toDispalyText(),
              style: TextStyle(
                  color: covidStatus.toTextColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
