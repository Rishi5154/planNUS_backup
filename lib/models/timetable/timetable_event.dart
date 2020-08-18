import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:plannusandroidversion/messages/constants.dart';
import 'package:plannusandroidversion/models/timetable/schedule_timing.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:plannusandroidversion/services/locationservice.dart';
import 'package:provider/provider.dart';

part 'timetable_event.g.dart';

/// An event that is shown on Timetable
@JsonSerializable(explicitToJson: true)
class TimeTableEvent {
  //Properties
  ScheduleTiming timing;
  String id;
  String name;
  bool isImportant;
  DateTime startDate;
  DateTime endDate;
  bool isWeekly;
  String location;
  bool isPrivate;
  String type;

  //Constructor
  TimeTableEvent(this.timing,
                 this.id,
                 this.name,
                 this.isImportant,
                 this.startDate,
                 this.endDate,
                 this.isWeekly,
                 this.location,
                 this.isPrivate,
                 this.type);

  //JsonSerializable methods
  factory TimeTableEvent.fromJson(Map<String, dynamic> data) => _$TimeTableEventFromJson(data);

  Map<String, dynamic> toJson() => _$TimeTableEventToJson(this);
}

class TimeTableEventWidget extends StatefulWidget {
  const TimeTableEventWidget(this.con, this.event, this.isPrivate, {Key key,})
      : assert(event != null), super(key: key);
  final TimeTableEvent event;
  final BuildContext con;
  final bool isPrivate;

  @override
  _TimeTableEventWidgetState createState() => _TimeTableEventWidgetState();
}

class _TimeTableEventWidgetState extends State<TimeTableEventWidget> {

  TimeTableEvent event;
  bool isPrivate;
  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    event = widget.event;
    isPrivate = widget.isPrivate;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 0.75,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      color: event.isImportant ? Colors.redAccent : Colors.lightGreenAccent,
      child: GestureDetector(
        onTapDown: _storePosition,
        onLongPress: () async {
          showMenu(
            context: context,
            position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Constants.zero & overlay.size // Bigger rect, the entire screen
            ),
            items: <PopupMenuEntry> [
              PopupMenuItem<bool>(
                value: true,
                child: FlatButton(
                  child: Text("Delete"),
                  onPressed: () async {
                    setState(() {
                      if (event.isWeekly) {
                        user.timetable.deleteWeeklyEvent(event);
                      } else {
                        user.timetable.deleteEvent(event);
                      }
                    });
                    await user.update().whenComplete(() => Navigator.pop(widget.con));
                  },
                ),
              ),
              PopupMenuItem<bool>(
                value: false,
                child: FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(widget.con);
                    }
                ),
              )
            ],
            elevation: 8.0,
          );
        },
        onTap: () async {
          Position place;
          List<Marker> _markers = List<Marker>();
          try {
            place = await LocationService.getCoordinatesFromLocation(event.location);
            _markers.add(
                Marker(
                  markerId: MarkerId('Main'),
                  position: LatLng(place.latitude, place.longitude),
                  infoWindow: InfoWindow(
                      title: '' + event.name,
                      snippet: event.location
                  ),
                )
            );
          } catch (e) {
            place = null;
          }
          showDialog(
            context: context,
            builder: (context) {
                if (place == null) {
                  List<String> loc = event.location.split(' ');
                  List<String> separated = List<String>();
                  separated.add(loc[0]);
                  int index = 0;
                  for (int i = 1; i < loc.length; i++) {
                    String token = loc[i];
                    if ((separated[index] + ' $token').length < 30) {
                      separated[index] += ' $token';
                    } else {
                      index ++;
                      separated.add(token);
                    }
                  }
                  if (separated[0] == '' || separated[0] == ' ') {
                    separated[0] = 'No Location';
                  }
                  return SimpleDialog(
                    title: Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Text((isPrivate && event.isPrivate)
                              ? 'Private Event'
                              : event.name),
                          IconButton(
                            icon: Icon(Icons.close),
                            iconSize: 15.0,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ]
                      )
                    ),
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 10,
                        child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.location_on),
                                    onPressed: () {

                                    },
                                  ),
                                  Text(separated[0]),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: separated.length > 1
                                    ? Column(
                                    children: separated.getRange(
                                        1, separated.length).map((str) =>
                                        Row(children: [
                                          SizedBox(width: 47.0),
                                          Text(str)
                                        ])
                                    ).toList()
                                )
                                    : Container(),
                              )
                            ]
                        ),
                      )
                    ],
                  );
               } else {
                  return SimpleDialog(
                    title: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              Text((isPrivate && event.isPrivate)
                                  ? 'Private Event'
                                  : event.name),
                              IconButton(
                                icon: Icon(Icons.close),
                                iconSize: 15.0,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]
                        )
                    ),
                    children: <Widget>[
                      place == null
                          ? Container(child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                        child: Text('No location available',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 28, color: Colors.red,
                              fontFamily: 'FONTERROR'
                          ),
                        ),
                      ))
                          : Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black12, width: 1.5)
                            )
                        ),
                        height: MediaQuery.of(context).size.height/3,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          initialCameraPosition:
                          CameraPosition(
                              target:LatLng(place.latitude, place.longitude),
                              zoom: 18
                          ),
                          zoomControlsEnabled: true,
                          mapType: MapType.normal,
                          markers: Set<Marker>.of(_markers),
                        ),
                      ),
                      event.type != null ?
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Icon(Icons.info, semanticLabel: 'Type', color: Colors.lightBlue, size: 35,),
                          SizedBox(width: 5,),
                          Text(event.type, style: GoogleFonts.lato(fontSize: 18, color: Colors.lightBlue),)
                        ],
                        ),
                      )
                          : Container(),
                    ],
                  );
                }
            }
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 2, 4, 0),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.black,
            ),
            child: Text((isPrivate && event.isPrivate)? 'Private Event' : event.name),
          ),
        ),
      ),
    );
  }
}