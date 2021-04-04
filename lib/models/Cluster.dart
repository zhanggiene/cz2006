import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class Cluster {
  String location;
  int caseSize;
  String list;
  String home;
  String public_places;
  String construction;
  List<LatLng> locations;

  Cluster.fromMap(Map<String, dynamic> data) {
    List<String> result = parseData(data["properties"]["Description"]);
    var geometry = data['geometry']['coordinates'][0];
    List<LatLng> locationstemp=[];
    for (int i = 0; i < geometry.length; i++) {
      locationstemp.add(LatLng(geometry[i][1], geometry[i][0]));
    }

    location = result[0];
    caseSize = int.parse(result[1]);
    home = result[4];
    public_places = result[5];
    construction = result[6];
    locations = locationstemp;
  }

  List<String> parseData(String html) {
    var document = parse(html);

    //declaring a list of String to hold all the data.
    List<String> data = [];

    //We can also do document.getElementsByTagName("td") but I am just being more specific here.
    var rows =
        document.getElementsByTagName("table")[0].getElementsByTagName("td");

    //Map elememt to its innerHtml,  because we gonna need it.
    //Iterate over all the table-data and store it in the data list
    rows.map((e) => e.innerHtml).forEach((element) {
      if (element != "-") {
        data.add(element);
      }
    });
    return data;
  }
}
