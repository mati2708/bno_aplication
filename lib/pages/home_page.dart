import 'dart:convert';

import 'package:bno/pages/add_competition_page.dart';
import 'package:bno/pages/competition_list.dart';
import 'package:bno/pages/competition_page.dart';
import 'package:bno/pages/competitions_map.dart';
import 'package:bno/pages/navigation_bar.dart';
import 'package:bno/pages/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geocoder/geocoder.dart';
import 'package:bno/pages/nav_drawer.dart';

import 'login_page.dart';

const MAPBOX_ACCESS_TOKEN =
    "pk.eyJ1IjoibWF0aTI3MDgiLCJhIjoiY2t5YXR1M3EzMDh6dzJvb2YzODFmbmRobyJ9.En9WtD-JHRnk61uVuGNqAQ";
const MAPBOX_STYLE = "mapbox://styles/mapbox/dark-v10";

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFEEEEEE),
        accentColor: Color(0xFFEEEEEE),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: NavDrawer(),
          appBar: AppBar(
            title: Text("Home",
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFEEEEEE),
                )),
            backgroundColor: Color(0xFF222831),
            actions: [
              // IconButton(
              //     icon: Icon(Icons.settings),
              //     onPressed: () {
              //       Navigator.of(context)
              //           .push(MaterialPageRoute(builder: (_) => SettingsPage()));
              //     })
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("Aktywności",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        //fontStyle: FontStyle.italic,
                        color: Color(0xFFEEEEEE),
                      )),
                ),
                Tab(
                  child: Text("Mapa",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        //fontStyle: FontStyle.italic,
                        color: Color(0xFFEEEEEE),
                      )),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              CompetitionList(),
              CompetionsMap(),
            ],
          ),
          
          floatingActionButton: FloatingActionButton(
            elevation: 8,
            child: Icon(Icons.add),
            foregroundColor: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddCompetitionPage()));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: "Map",
              )
            ],
          ),
        ),
      ),
    );
  }
}
