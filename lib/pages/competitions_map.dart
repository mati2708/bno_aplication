import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class CompetionsMap extends StatelessWidget {
  const CompetionsMap({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).collection("competitions").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Błąd!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        MapboxMapController mapController;
        return MapboxMap(
          accessToken: "pk.eyJ1IjoibWF0aTI3MDgiLCJhIjoiY2t5YXR1M3EzMDh6dzJvb2YzODFmbmRobyJ9.En9WtD-JHRnk61uVuGNqAQ",
          initialCameraPosition: CameraPosition(target: LatLng(53.4138189, 14.5545421), zoom: 4),
          onMapCreated: (MapboxMapController controller) async {
            mapController = controller;
          },
          onStyleLoadedCallback: () {
            for (var activity in snapshot.data.docs) {
              var data = activity.data() as Map<String, dynamic>;

              print(data["start_point"].latitude.runtimeType);
              mapController.addSymbol(SymbolOptions(
                geometry: LatLng(data["start_point"].latitude, data["start_point"].longitude),
                iconImage: "assets/images/marker.png",
                iconSize: 0.05,
              ));
            }
          },
        );
      },
    );
  }
}
