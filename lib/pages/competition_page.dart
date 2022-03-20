import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CompetitionPage extends StatelessWidget {
  var id;

  CompetitionPage(String id) {
    this.id = id;
  }

  String map = "assets/images/map_1.jpg";
  String map2 = "assets/images/map_2.png";
  String map3 = "assets/images/map_3.png";

  @override
  Widget build(BuildContext context) {
    var competition = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).collection("competitions").doc(id).snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: competition,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Błąd!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var data = snapshot.data;

        MapboxMapController mapController;

        GeoPoint startPoint = data.get("start_point");

        return Scaffold(
          appBar: AppBar(
            //title: Text(data["name"]),
            title: Text(data["type"],
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFEEEEEE),
                )),
            backgroundColor: Color(0xFF222831),
          ),
          body: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    data["name"],
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF222831),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                  )),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: 250,
                  child: MapboxMap(
                    accessToken: "pk.eyJ1IjoibWF0aTI3MDgiLCJhIjoiY2ttdDFiNWtiMGo1eDJwcGM5N2N1dnp0aCJ9.FTRyuQoL3fHmc149Sm8sSw",
                    initialCameraPosition: CameraPosition(target: LatLng(startPoint.latitude, startPoint.longitude),zoom: 12),
                    onMapCreated: (MapboxMapController controller) async {
                      mapController = controller;
                    },
                    onStyleLoadedCallback: () {
                      var points = decodePolyline(data.get("polyline")).map((p) => LatLng(p[0], p[1]));
                      List<LatLng> geometry = [];
                      for (var point in points) {
                        geometry.add(point);
                      }
                      mapController.addLine(LineOptions(
                        geometry: geometry,
                        lineColor: "#da443e",
                        lineWidth: 4,
                      ));
                    },
                  ),
                ),

                //     Text(
                //       "Dystans  "+data["distance"].toString()+" km",
                //       style: GoogleFonts.montserrat(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w400,
                //         ),
                //         softWrap: true,
                //       ),
                //       Text(
                //       "Czas  "+data["timeMin"].round().toString()+":"+data["timeSec"].round().toString(),
                //       style: GoogleFonts.montserrat(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w400,
                //         ),
                //         softWrap: true
                //       ),
                //       ],
                // ),
                // body: Column(
                //   children: [
                //     Container(
                //         height: 240,
                //         child: MapboxMap(
                //           accessToken: "pk.eyJ1IjoibWF0aTI3MDgiLCJhIjoiY2ttdDFiNWtiMGo1eDJwcGM5N2N1dnp0aCJ9.FTRyuQoL3fHmc149Sm8sSw",
                //           initialCameraPosition: CameraPosition(target: LatLng(53.4138189, 14.5545421), zoom: 10),
                //           ),
              ),
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Row(children: [
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Dystans",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true),
                        SizedBox(
                          height: 5,
                        ),
                        Text(data["distance"].toStringAsFixed(2) + " km",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: true),
                      ])),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Czas",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true),
                        SizedBox(
                          height: 5,
                        ),
                        if ((data["timeHou"] == 0) && (data["timeSec"] < 10))
                          Text((data["timeMin"].round().toString()) + ":0" + (data["timeSec"].round().toString()),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true),
                        if ((data["timeHou"] == 0) && (data["timeSec"] >= 10))
                          Text((data["timeMin"].round().toString()) + ":" + (data["timeSec"].round().toString()),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true),
                        if ((data["timeHou"] != 0) && (data["timeMin"] < 10))
                          Text(
                              (data["timeHou"].round().toString()) +
                                  ":0" +
                                  (data["timeMin"] - data["timeHou"] * 60).round().toString() +
                                  ":0" +
                                  (data["timeSec"].round().toString()),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true),
                        if ((data["timeHou"] != 0) && (data["timeMin"] >= 10))
                          Text(
                              (data["timeHou"].round().toString()) +
                                  ":" +
                                  (data["timeMin"] - data["timeHou"] * 60).round().toString() +
                                  ":" +
                                  (data["timeSec"].round().toString()),
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true),
                      ])),
                    ]),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Typ",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true),
                        SizedBox(
                          height: 5,
                        ),
                        Text(data["type"].toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: true),
                      ])),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Przewyższenie",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true),
                        SizedBox(
                          height: 5,
                        ),
                        Text(data["total_elevation_gain"].round().toString() + "m",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: true),
                      ])),
                    ]),
                    SizedBox(
                      height: 8,
                    ),
                    Row(children: [
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Tempo",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true),
                        SizedBox(
                          height: 5,
                        ),
                        if (((((data["timeMin"] * 60) + data["timeSec"]) * (1 / data["distance"])) % 60) < 10)
                          Text(
                              ((((data["timeMin"] * 60) + data["timeSec"]) * (1 / data["distance"])) / 60)
                                      .floor()
                                      .toString() +
                                  ":0" +
                                  ((((data["timeMin"] * 60) + data["timeSec"]) * (1 / data["distance"])) % 60)
                                      .round()
                                      .toString() +
                                  " /km",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true)
                        else
                          Text(
                              ((((data["timeMin"] * 60) + data["timeSec"]) * (1 / data["distance"])) / 60)
                                      .floor()
                                      .toString() +
                                  ":" +
                                  ((((data["timeMin"] * 60) + data["timeSec"]) * (1 / data["distance"])) % 60)
                                      .round()
                                      .toString() +
                                  " /km",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap: true),
                      ])),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Text("Średnie tętno",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true),
                        SizedBox(
                          height: 5,
                        ),
                        Text(data["average_heartrate"].toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            softWrap: true),
                      ])),
                    ]),
                  ]))
            ],
          ),
        );
      },
    );
  }
}
