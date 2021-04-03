import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:cz2006/View/GeoJson.dart';
import 'package:cz2006/View/details.dart';
import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:location/location.dart';
import 'dart:ui' as ui;

class ViewDengueMap extends StatefulWidget {
  ViewDengueMap({Key key}) : super(key: key);

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewDengueMap> {
  Completer<GoogleMapController> _controller = Completer();
  Uint8List pinLocationIcon;
  List<LatLng> polygonCoords = [
    LatLng(1.43296265331129, 103.08832357078792),
    LatLng(2.43006265331129, 104.18832357078792),
    LatLng(3.43006265331129, 109.38332357078792),
    LatLng(1.43296265331129, 103.08832357078792)
  ];

  List<LatLng> point = List<LatLng>();
  List<Post> posts;
  bool loading = true;
  double infoPosition = -100;
  Post currentPost;
  String apiKey = "AIzaSyCVNX_dr0ebA4zmzokVUxcizwN1NRdifcI";
  LocationData currentLocation;
  Location location;

  @override
  Future<void> initState() {
    location = new Location();

    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      print(currentLocation.latitude);
    });
    setInitialLocation();
    getdata();
    addPoints();
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    print("set initial location");
    currentLocation = await location.getLocation();
    print("initiliza the location" + currentLocation.altitude.toString());

    // hard-coded destination for this example
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

  bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }

  onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void addPoints() {
    for (var i = 0; i < GeoJson.IN.length; i++) {
      var ltlng = LatLng(GeoJson.IN[i][1], GeoJson.IN[i][0]);
      point.add(ltlng);
    }
  }

  Set<Polygon> myPolygon() {
    Set polygon = HashSet<Polygon>();
    polygon.add(Polygon(
        polygonId: PolygonId('test'),
        points: polygonCoords,
        strokeWidth: 2,
        fillColor: Colors.yellow.withOpacity(0.15),
        strokeColor: Colors.red));
    return polygon;
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      target: LatLng(1.3521, 103.8198),
      zoom: 13,
      bearing: 30,
      tilt: 0,
    );

    if (currentLocation != null) {
      initialLocation = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 13,
        tilt: 30,
      );
    }
    return new Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            compassEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: false,
            polygons: myPolygon(),
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            onMapCreated: onMapCreated,
            onTap: (LatLng location) {
              setState(() {
                //infoPosition = -100;
                //_checkIfValidMarker(location, point);
                //
                //
                if (_checkIfValidMarker(location, polygonCoords)) {
                  print("hu");
                }
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context, ScaleRoute(page: Detail(post: p)));
              },
              splashColor: Colors.green,
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
          ),
        ),
      ));
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                //curve: Curves.fastOutSlowIn,
                curve: Curves.ease,
              ),
            ),
            child: child,
          ),
        );
}
