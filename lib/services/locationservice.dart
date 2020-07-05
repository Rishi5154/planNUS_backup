import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class LocationService{
  static Geocoder geocoder = new Geocoder();
   static Future<Position> getCurrentLocation() async {
     return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
   }

   static Future<Placemark> getCurrentAddress(Position pos) async {
     return await Geolocator().placemarkFromPosition(pos, localeIdentifier: "en").then((value) => value.removeLast());
   }

   static Future<Address> getAddress(Position pos) async {
     return await Geocoder.local.findAddressesFromCoordinates(new Coordinates(pos.latitude, pos.longitude)).then((value) => value.first);
   }
}
class _LocationState extends State<Location> {

  String kGoogleApiKey = 'AIzaSyDTcnPrAgWcVN4OoDMTS7d4fzKi7E2wdEA';
  TextEditingController controller = new TextEditingController();
  String heading;
  var uuid = new Uuid();
  String sessionToken;
  List<String> suggestedPlaces = new List<String>();
  
  Widget searchBar = Text("Search", style: GoogleFonts.openSans(fontSize: 18, color: Colors.white),);
  Icon shifting = Icon(Icons.search, color: Colors.white,);
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    heading = "Suggestions";
    controller.addListener(() {
      onSearchChanged();
    });
  }

  @override
  void dispose() {
    controller.removeListener(onSearchChanged);
    controller.dispose();
    super.dispose();
  }

  onSearchChanged(){
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getLocationResults(controller.text);
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {
        heading = "Suggestions";
      });
      return;
    }
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';

    //String request = '$baseURL?input=$input&key=$kGoogleApiKey&type=$type&sessiontoken=$sessionToken';
    String request = '$baseURL?input=$input&key=$kGoogleApiKey&sessiontoken=$sessionToken';
    print(request);
    Response response = await Dio().get(request);

    print(response);
    List<String> localSearch = new List<String>();
    final predictions = response.data['predictions'];
    for (int i = 0; i < predictions.length; i++) {
      String main = predictions[i]['structured_formatting']['main_text'] ?? '';
      String secondary = predictions[i]['structured_formatting']['secondary_text'] ?? '';
      String location = main + ' ' + secondary;
      localSearch.add(location);
//      localSearch.add(predictions[i]['description']);
//      setState(() {
//        suggestedPlaces.add(predictions[i]['description']);
//      });
    }

    setState(() {
      heading = "Results";
      suggestedPlaces = localSearch;
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: shifting,
            onPressed: () {
              setState(() {
                if (shifting.icon == Icons.search) {
                  shifting = Icon(Icons.cancel, );
                  searchBar = Container(
                    height: 45,
                    width: 300,
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                        alignLabelWithHint: true,
                        focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25),
                      borderSide: new BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                enabledBorder: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: Colors.white)),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  );
                } else {
                  searchBar = Text("Search", style: GoogleFonts.openSans(fontSize: 18, color: Colors.white),);
                  shifting = Icon(Icons.search);
                }
              });
            },
          )
        ],
        title: searchBar,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(heading, style: GoogleFonts.openSans(fontSize: 24, color: Colors.black),
              ),
            ),
            Expanded(
              child: suggestedPlaces.length != 0 || suggestedPlaces != null ? ListView.builder(
                itemCount: suggestedPlaces.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, suggestedPlaces[index]);
                    },
                    child: ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(suggestedPlaces[index],
                        style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  );
                },
              ) : Container()
            )
          ],
        ),
      ),
    );
  }
}
