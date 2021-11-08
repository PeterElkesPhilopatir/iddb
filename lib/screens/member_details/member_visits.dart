import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:iddb/models/member.dart';
import 'package:iddb/models/visit.dart';
import 'package:iddb/screens/member_details/visit_item.dart';
import 'package:iddb/shared/loading.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:iddb/shared/messages.dart';

class MemberVisits extends StatefulWidget {
  Member member;

  MemberVisits({Key? key, required this.member}) : super(key: key);

  @override
  _MemberVisitsState createState() => _MemberVisitsState();
}

class _MemberVisitsState extends State<MemberVisits> {
  List visits = <Visit>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("visits")
              .orderByChild('member_id')
              .equalTo(widget.member.id)
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              try {
                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
                visits.clear();
                Visit p;
                map.forEach((key, v) => {
                      p = Visit(),
                      p.id = key,
                      p.type = v['type'],
                      p.date = v['date'],
                      p.notes = v['notes'],
                      p.member_id = v['member_id'],
                      p.servant_id = v['servant_id'],
                      visits.add(p),
                    });

                return ListView.builder(
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    return VisitWidget(visit: visits[index]);
                  },
                );
              } catch (e) {
                print(e);
                return Scaffold(
                  body: Center(
                    child: Text('No Visits registered'),
                  ),
                );
              }
            } else {
              return Center(child: Loading());
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          onAddClicked();
        },
        backgroundColor: Colors.red,
        label: Text('Register visit'),
        icon: Icon(Icons.post_add_sharp),
      ),
    );
  }

  void onAddClicked() {
    showDialog();
  }

  void showDialog() {
    double icon_size = 60;
    DateTime selectedDate = DateTime.now();
    Visit visit = Visit();
    visit.member_id = widget.member.id;
    showGeneralDialog(
      barrierLabel: "Register Visit",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 350),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return SimpleDialog(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        final DateTime? selected = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2025),
                        );
                        if (selected != null && selected != selectedDate)
                          setState(() {
                            selectedDate = selected;
                            visit.date =
                                "${selected.year}-${selected.month}-${selected.day}";
                          });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Visit Date"),
                      ),
                    ),
                    Text(
                      visit.date,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 20,
                          letterSpacing: 2.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              visit.type = VisitType.mobile;
                            });
                          },
                          child: Container(
                              child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.phone_android,
                                  size: icon_size,
                                  color: visit.type == VisitType.mobile
                                      ? Colors.indigo
                                      : Colors.grey,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Phone Visit',
                                  style: TextStyle(
                                    color: visit.type == VisitType.mobile
                                        ? Colors.indigo
                                        : Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              visit.type = VisitType.home;
                            });
                          },
                          child: Container(
                              child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home,
                                  size: icon_size,
                                  color: visit.type == VisitType.home
                                      ? Colors.indigo
                                      : Colors.grey,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Home Visit',
                                  style: TextStyle(
                                    color: visit.type == VisitType.home
                                        ? Colors.indigo
                                        : Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Visit Notes',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.lightBlueAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          visit.notes = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextButton(
                        child: Text(
                          'Register',
                        ),
                        onPressed: () {
                          _onRegClicked(visit);
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))))
                  ],
                ),
              ),
            ),
          ]);
        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _onRegClicked(Visit visit) async {
    visit.add().then((value) => value
        ? {
            showToast('Added'),
            Navigator.of(context, rootNavigator: true).pop(),
          }
        : showToast('failed'));
  }
}
