import 'package:flutter/material.dart';
import 'package:iddb/models/member.dart';

class MemberWidget extends StatefulWidget {
  final Member member;

  MemberWidget({Key? key, required this.member}) : super(key: key);

  @override
  _MemberWidgetState createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/member_details',
            arguments: {'data': widget.member});
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          width: (MediaQuery.of(context).size.width / 2) - 15,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
              image: NetworkImage(widget.member.imageURL),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                gradient: new LinearGradient(
                    colors: [
                      Colors.black,
                      const Color(0x19000000),
                    ],
                    begin: const FractionalOffset(0.0, 1.0),
                    end: const FractionalOffset(0.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.member.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ), /* add child content here */
        ),
      ),
    );
  }

}
