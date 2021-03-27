import 'dart:async';
import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:cz2006/locator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final primaryColor = Colors.green[400];

class Detail extends StatefulWidget {
  final Post post;
  const Detail({this.post});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Set<Marker> _markers = new HashSet<Marker>();

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          children: [
            Container(
                child: Column(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                  items: widget.post.images
                      .map((item) => Container(
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.network(item,
                                          fit: BoxFit.cover, width: 1000.0),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                            'No. ${widget.post.images.indexOf(item)} image',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ))
                      .toList(),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                child: Text(
                  "Description:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Text(widget.post.content),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Align(
                child: Text(
                  "Location:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.post.location.latitude,
                        widget.post.location.longitude),
                    zoom: 20,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      _markers.add(Marker(
                        markerId: MarkerId(widget.post.id),
                        position: LatLng(widget.post.location.latitude,
                            widget.post.location.longitude),
                      ));
                    });
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                locator.get<PostController>().deletePost(widget.post);
                Fluttertoast.showToast(
                    msg: "this post has been deleted successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 3,
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                    fontSize: 16.0);

                Navigator.pop(context);
              },
              child: Text(
                "delete",
              ),
            ),
            Container(
              height: 50.0,
              child: GestureDetector(
                onTap: () {
                  locator.get<PostController>().likePost(locator.get<UserController>().currentuser, widget.post);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFF05A22),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Like",
                          style: TextStyle(
                            color: Color(0xFFF05A22),
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  void onPressed() {}
}
