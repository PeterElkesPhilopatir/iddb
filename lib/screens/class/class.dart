import 'package:flutter/material.dart';
import 'package:iddb/models/class.dart';


class ClassView extends StatefulWidget {
  const ClassView({Key? key}) : super(key: key);

  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  @override
  Widget build(BuildContext context) {
    Class c =
        (ModalRoute.of(context)!.settings.arguments as Map)['data'] as Class;
    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 20.0,
      ),
      body: ClassBodyView(),
    );
  }
}

class ClassBodyView extends StatefulWidget {
  const ClassBodyView({Key? key}) : super(key: key);

  @override
  _ClassBodyViewState createState() => _ClassBodyViewState();
}

class _ClassBodyViewState extends State<ClassBodyView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Flexible(child: getYt2()),
          // Flexible(
          //   child: CustomScrollView(
          //     slivers: [
          //       SliverList(
          //         delegate: SliverChildBuilderDelegate(
          //           (BuildContext context, int index) {
          //             return;
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

}
