import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> loadStravaActivities() async {
  var token = await FirebaseAuth.instance.currentUser.getIdToken();

  var getStravaActivities = FirebaseFunctions.instance.httpsCallable("getStravaActivities");
  var response = await getStravaActivities({"token": token});

  for (var item in response.data[0].keys) {
    print(item);
  }

  return response.data;
}

class StravaActivities extends StatelessWidget {
  const StravaActivities({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Color(0xFF002831),
          title: Text(
            'Aktywności Strava',
            style: GoogleFonts.montserrat(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          )),
      body: FutureBuilder(
        future: loadStravaActivities(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Błąd!");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Container(
          //             padding: EdgeInsets.all(16),
          //             child: Row(
          //               children: [
          //                 Expanded(child: Text("Nazwa aktywności",
          //                 style: GoogleFonts.montserrat(
          //                           fontSize: 14,
          //                           fontWeight: FontWeight.w400,
          //                             ),
          //                             textAlign: TextAlign.center,)
          //                             ),
          //                   Expanded(child: Text("Dystans",
          //                 style: GoogleFonts.montserrat(
          //                           fontSize: 14,
          //                           fontWeight: FontWeight.w400,
          //                             ),
          //                             textAlign: TextAlign.center,))
          //               ],
          //             ),
          //           )

          return ListView(
            children: snapshot.data.map<Widget>((activity) {
              return InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity["name"],
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              (activity["distance"] / 1000).toStringAsFixed(2) + " km",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).collection("competitions").add({
                    "name": activity["name"],
                    "type": activity["type"],
                    "polyline": activity["polyline"],
                    "average_heartrate": activity["average_heartrate"],
                    "distance": activity["distance"] / 1000,
                    "timeHou": (activity["elapsed_time"] / 3600).floor(),
                    "timeMin": (activity["elapsed_time"] / 60).floor(),
                    "timeSec": activity["elapsed_time"] % 60,
                    "total_elevation_gain": activity["total_elevation_gain"],
                    "date": DateTime.parse(activity["start_date"]),
                    "start_point": GeoPoint(
                      activity["start_latlng"][0],
                      activity["start_latlng"][1],
                    )
                  });
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
