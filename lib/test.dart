
import 'package:html/parser.dart' show parse;
import 'dart:async' show Future;


Future<void> getData() async {
  //var geo = GeoJson();
  //var data = await rootBundle.loadString('images/data.geojson');
  //await geo.parse(data, verbose: true);
  //print(data);
}

main(List<String> args) {
  parseData();
}


parseData() {
  var document = parse("""
    "<center>
            <table>
                  <tr>
                      <th colspan='2' align='center'>
                            <em>Attributes<\/em>
                      <\/th> <\/tr>
                  <tr bgcolor=\"#E3E3F3\"> <th>LOCALITY<\/th> <td>Balam Rd (Blk 31) \/ Circuit Rd (Blk 35)<\/td> <\/tr>
                  <tr bgcolor=\"\"> <th>CASE_SIZE<\/th> <td>2<\/td> <\/tr>
                  <tr bgcolor=\"#E3E3F3\"> <th>NAME<\/th> <td>Dengue_Cluster<\/td> <\/tr>
                  <tr bgcolor=\"\"> <th>HYPERLINK<\/th> <td>https:\/\/www.nea.gov.sg\/dengue-zika\/dengue\/dengue-clusters<\/td> <\/tr>
                  <tr bgcolor=\"#E3E3F3\"> <th>HOMES<\/th> <td><\/td> <\/tr><tr bgcolor=\"\"> <th>PUBLIC_PLACES<\/th> <td><\/td> <\/tr>
                  <tr bgcolor=\"#E3E3F3\"> <th>CONSTRUCTION_SITES<\/th> <td><\/td> <\/tr><tr bgcolor=\"\"> <th>INC_CRC<\/th> <td>9863CAB8604F8162<\/td> <\/tr><tr bgcolor=\"#E3E3F3\"> <th>FMEL_UPD_D<\/th> <td>20210331155248<\/td> <\/tr><\/table><\/center>"
  """);

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

  //print the data to console.
  print(data);
}
