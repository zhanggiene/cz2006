import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportBite extends StatefulWidget {
  ReportBite({Key key}) : super(key: key);

  @override
  _ReportBiteState createState() => _ReportBiteState();
}

class _ReportBiteState extends State<ReportBite> {
  int _bitesNumber;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.amber),
          title: Text('profile'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: new Center(
              child: new Column(children: [
            new ListTile(
              leading: new Column(
                children: <Widget>[
                  new Container(
                      width: 80.0,
                      child: new Text(
                        'Number of bites',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              title: new TextField(
                keyboardType: TextInputType.number,
                onChanged: (String p) {
                  setState(() {
                    _bitesNumber = int.parse(p);
                  });
                },
                decoration: InputDecoration(
                    labelText: 'bites',
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal))),
              ),
            ),
          ])),
        ));
  }
}
