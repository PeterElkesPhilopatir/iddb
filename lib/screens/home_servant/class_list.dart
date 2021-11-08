import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iddb/models/class.dart';
import 'package:provider/provider.dart';

class ClassList extends StatefulWidget {
  const ClassList({Key? key}) : super(key: key);

  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  @override
  Widget build(BuildContext context) {
    final cs = Provider.of<List<Class>>(context);
    if (cs.length == 0) {
      print('no data');
    }
    return ListView.builder(
      itemCount: cs.length,
      itemBuilder: (context, index) {
        return InkWell(
            child: ClassTile(c: cs[index]));
      },
    );
  }
}

class ClassTile extends StatelessWidget {
  final Class c;

  ClassTile({required this.c});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        margin: EdgeInsets.all(8.0),
        child:
            // GestureDetector(
            //   onTap: (){
            //     showToast(c.name);
            //   },
            //   child: Container(
            //     child: Center(
            //       child:Column(
            //       children: [
            //         Text(c.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40.0),),
            //         SizedBox(height: 10.0),
            //         Text(c.description,style: TextStyle(color: Colors.white),)
            //       ],
            //     ),),
            //     height: 190.0,
            //     width: MediaQuery.of(context).size.width - 100.0,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(18),
            //         color: Colors.grey[500],
            //         image: DecorationImage(
            //             colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.clear),
            //             image: new NetworkImage(
            //                 'https://scontent.fcai1-2.fna.fbcdn.net/v/t31.18172-8/12779085_10153439604893951_2889210514726304878_o.jpg?_nc_cat=109&ccb=1-5&_nc_sid=973b4a&_nc_ohc=iAJzKRJlAMoAX--v7YO&_nc_ht=scontent.fcai1-2.fna&oh=4898cefc8e5a3537aaddd54481274b9b&oe=618B8578'
            //             ),
            //             fit: BoxFit.fill
            //         )
            //     ),
            //   ),
            // ),
            ListTile(
          leading: Icon(Icons.group),
          title: Text(c.name),
          subtitle: Text(c.description),
          onTap: () {
            Navigator.pushNamed(context, '/class', arguments: {
              'data': c,
            });
          },
        ),
      ),
    );
  }
}
