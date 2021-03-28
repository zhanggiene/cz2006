import 'dart:async';

import 'package:cz2006/View/CreatePost.dart';
import 'package:cz2006/View/details.dart';
import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ViewPostMap extends StatefulWidget {
  ViewPostMap({Key key}) : super(key: key);

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPostMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  List<Post> posts;
  bool loading = true;
  double infoPosition = -100;
  Post currentPost;
  String apiKey = "AIzaSyCVNX_dr0ebA4zmzokVUxcizwN1NRdifcI";

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    print("to get all posts");
    locator.get<PostController>().getPostByTime().then((value) {
      posts = value;
      setState(() {
        loading = false;
      });
    });
  }

  void setMapPins() {
    for (Post i in posts) {
      _markers.add(Marker(
        markerId: MarkerId(i.id),
        position: i.location,
        onTap: () {
          setState(() {
            infoPosition = 0;
            currentPost = i;
          });
        },
      ));
    }
  }

  onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      target: LatLng(1.3521, 103.8198),
      zoom: 13,
      bearing: 30,
      tilt: 0,
    );
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            onMapCreated: onMapCreated,
            onTap: (LatLng location) {
              setState(() {
                infoPosition = -100;
              });
            },
          ),
          infoCard(context, infoPosition, currentPost),
        ],
      ),
    );
  }
}

Widget infoCard(context, double position, Post p) {
  if (p == null) {
    return Text("check your internet");
  }
  return AnimatedPositioned(
      bottom: position,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(left: 10),
                color: Colors.redAccent,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(p.title),
                      Text(DateFormat('yyyy-MM-dd').format(
                          DateTime.fromMicrosecondsSinceEpoch(
                              p.timeOfCreation))),
                    ],
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.arrow_right_alt_rounded,
                  size: 50.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ));
}
