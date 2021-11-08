import 'package:flutter/material.dart';
import 'package:iddb/models/member.dart';
import 'package:iddb/models/visit.dart';
import 'package:iddb/shared/messages.dart';

class VisitWidget extends StatefulWidget {
  Visit visit;

  VisitWidget({Key? key, required this.visit}) : super(key: key);

  @override
  _MemberWidgetState createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<VisitWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showAlertDialog(context);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ExpansionTile(
            leading: getIconType(),
            title: Text(widget.visit.date),
            children: [
              Text(widget.visit.notes)
            ],
          ),
        ),
      ),
    );
  }

  Icon getIconType() {
    double icon_size = 50.0;
    if (widget.visit.type == VisitType.home)
      return Icon(
        Icons.home,
        size: icon_size,
        color: Colors.indigo,
      );
    if (widget.visit.type == VisitType.mobile)
      return Icon(
        Icons.phone_android,
        size: icon_size,
        color: Colors.indigo,
      );
    return Icon(null);
  }

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Remove Visit?'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context, rootNavigator: true)
                    .pop(),
                child: Text('No'),
              ),
              FlatButton(
                onLongPress: () {
                  widget.visit.delete().then((value) => value
                      ? {
                          showToast('deleted'),
                    Navigator.of(context, rootNavigator: true).pop(),
                        }
                      : showToast('failed'));
                },
                onPressed: () {
                  showToast('Long press to Delete!');
                },
                child: Text('Yes'),
              ),
            ],
          );
        }).then((exit) {
      if (exit == null) return;

      if (exit) {
        // user pressed Yes button
      } else {
        // user pressed No button
      }
    });
  }
}
