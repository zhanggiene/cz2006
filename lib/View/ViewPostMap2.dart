import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Cluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:location/location.dart';
import 'dart:ui' as ui;
import 'package:html/parser.dart' show parse;
import 'package:flutter/services.dart' show rootBundle;
import 'package:shape_of_view/shape_of_view.dart';

class ViewDengueMap extends StatefulWidget {
  ViewDengueMap({Key key}) : super(key: key);

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewDengueMap> {
  Completer<GoogleMapController> _controller = Completer();
  Uint8List pinLocationIcon;
  List<Cluster> clusters = new List();
  bool loading = true;
  double infoPosition = -250;
  Cluster currentCluster;
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
      //print(currentLocation.latitude);
    });
    setInitialLocation();
    getdata();
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    //print("set initial location");
    currentLocation = await location.getLocation();
    //print("initiliza the location" + currentLocation.altitude.toString());

    // hard-coded destination for this example
  }

  getdata() async {
    var data = await rootBundle.loadString('images/data.geojson');
    var lists = json.decode(data)['features'];
    for (var i = 0; i < lists.length; i++) {
      //print("hi");
      var cluster = Cluster.fromMap(lists[i]);
      //print(cluster.locations);
      clusters.add(cluster);
    }

    setState(() {
      loading = false;
    });
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

  int _checkIfValidMarker(LatLng tap) {
    for (int i = 0; i < clusters.length; i++) {
      int intersectCount = 0;
      for (int j = 0; j < clusters[i].locations.length - 1; j++) {
        if (rayCastIntersect(
            tap, clusters[i].locations[j], clusters[i].locations[j + 1])) {
          intersectCount++;
        }
      }

      if ((intersectCount % 2) == 1) {
        return i; // odd = inside, even = outside;

      }
    }

    return -1;
  }

  onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Set<Polygon> myPolygon() {
    Set polygon = HashSet<Polygon>();
    for (int i = 0; i < clusters.length; i++) {
      print("building polygon");
      //print(clusters[i].locations);
      polygon.add(Polygon(
          polygonId: PolygonId(i.toString()),
          points: clusters[i].locations,
          strokeWidth: 2,
          fillColor: Colors.yellow.withOpacity(0.15),
          strokeColor: Colors.green));
    }
    return polygon;
  }

  Future<void> getData() async {
    var data = await rootBundle.loadString('images/data.geojson');
    //print(json.decode(data)['features']);
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
                  infoPosition = -250;
                  //_checkIfValidMarker(location, point);
                  if (_checkIfValidMarker(location) != -1) {
                    infoPosition = 0;
                    currentCluster = clusters[_checkIfValidMarker(location)];
                  }

                  //
                  //
                });
              }),
          infoCard(context, infoPosition, currentCluster),
        ],
      ),
    );
  }
}

Widget infoCard(context, double position, Cluster p) {
  if (p == null) {
    return Text("check your internet");
  }
  return AnimatedPositioned(
      bottom: position,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 300),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 230,
          child: ShapeOfView(
            shape: ArcShape(
              direction: ArcDirection.Outside,
              height: 50,
              position: ArcPosition.Top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    p.caseSize.toString() + " cases",
                    style: new TextStyle(
                        fontSize: 30.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Location: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 295, maxHeight: 30),
                        child: AutoSizeText(
                          p.location.toString(),
                          minFontSize: 11,
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Home: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 315, maxHeight: 60),
                        child: AutoSizeText(
                          p.home.toString(),
                          minFontSize: 10,
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Public places: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 265, maxHeight: 70),
                        child: AutoSizeText(
                          p.public_places.toString(),
                          minFontSize: 10,
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Construction: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 265, maxHeight: 20),
                        child: AutoSizeText(
                          p.construction.toString(),
                          minFontSize: 10,
                        )),
                  ],
                ),
                //Text(p.home.toString()),
                // Flexible(child: Text("location: " + p.location.toString())),
                // ConstrainedBox(
                //     constraints: BoxConstraints(maxHeight: 30, minHeight: 20),
                //     child: AutoSizeText("location: " + p.location.toString())),
                // ConstrainedBox(
                //     constraints: BoxConstraints(maxHeight: 30, minHeight: 20),
                //     child: AutoSizeText("home: " + p.home.toString())),
                // Flexible(child: Text("home:" + p.home.toString())),
                // ConstrainedBox(
                //     constraints: BoxConstraints(maxHeight: 30, minHeight: 20),
                //     child: AutoSizeText(
                //         "Public places: " + p.public_places.toString())),
                // Flexible(
                //     child:
                //         Text("Public places: " + p.public_places.toString())),
                // Flexible(
                //     child: Text("Construction: " + p.construction.toString())),
              ],
            ),
          ),
        ),
      ));
}
