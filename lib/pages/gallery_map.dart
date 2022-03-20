import 'dart:convert';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Gallery extends StatelessWidget {

  String map = "assets/images/map_1.jpg";
    String map2 = "assets/images/map_2.png";
    String map3 = "assets/images/map_3.png";
    String map4 = "assets/images/map_4.png";
    String map5 = "assets/images/map_5.jpg";
    String map6 = "assets/images/map_6.jpg";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xFF002831),
        title: Text('Galeria map',
        style: GoogleFonts.montserrat(
          fontSize: 26,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          color: Colors.white,
          ),)),
    body: Container(
      decoration: BoxDecoration(
        color: Color(0xFF222831),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
                    child: Image.asset(map),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
                    child: Image.asset(map2),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
                    child: Image.asset(map3),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
                    child: Image.asset(map4),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
                    child: Image.asset(map5),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InteractiveViewer(
                    child: Image.asset(map6),
                    ),
          ),
        ],
      ),
    )
    );
  }
}