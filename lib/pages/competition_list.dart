import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'competition_page.dart';

class CompetitionList extends StatelessWidget {
  const CompetitionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var competitions =
        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).collection("competitions").orderBy("date").snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: competitions,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Błąd!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data.docs.map((QueryDocumentSnapshot documentSnapshot) {
            return Container(
              padding: EdgeInsets.all(8),
              //color: Color(0xFF222831),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    elevation: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => CompetitionPage(documentSnapshot.id)));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: 400,
                              color: Color(0xFF002831),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        documentSnapshot.get("name"),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
                                      Text(documentSnapshot.get("distance").toStringAsFixed(2) + " km",
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
                                      if ((documentSnapshot.get("timeHou") == 0) && (documentSnapshot.get("timeSec") < 10))
                                        Text((documentSnapshot.get("timeMin").round().toString()) + ":0" + (documentSnapshot.get("timeSec").round().toString()),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            softWrap: true),
                                      if ((documentSnapshot.get("timeHou") == 0) && (documentSnapshot.get("timeSec") >= 10))
                                        Text((documentSnapshot.get("timeMin").round().toString()) + ":" + (documentSnapshot.get("timeSec").round().toString()),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            softWrap: true),
                                      if ((documentSnapshot.get("timeHou") != 0) && (documentSnapshot.get("timeMin") < 10))
                                        Text(
                                            (documentSnapshot.get("timeHou").round().toString()) +
                                                ":0" +
                                                (documentSnapshot.get("timeMin") - documentSnapshot.get("timeHou") * 60).round().toString() +
                                                ":0" +
                                                (documentSnapshot.get("timeSec").round().toString()),
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            softWrap: true),
                                      if ((documentSnapshot.get("timeHou") != 0) && (documentSnapshot.get("timeMin") >= 10))
                                        Text(
                                            (documentSnapshot.get("timeHou").round().toString()) +
                                                ":" +
                                                (documentSnapshot.get("timeMin") - documentSnapshot.get("timeHou") * 60).round().toString() +
                                                ":" +
                                                (documentSnapshot.get("timeSec").round().toString()),
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
                                      Text(documentSnapshot.get("type").toString(),
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
                                      Text(documentSnapshot.get("total_elevation_gain").round().toString() + "m",
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
                                      if (((((documentSnapshot.get("timeMin") * 60) + documentSnapshot.get("timeSec")) *
                                                  (1 / documentSnapshot.get("distance"))) %
                                              60) <
                                          10)
                                        Text(
                                            ((((documentSnapshot.get("timeMin") * 60) + documentSnapshot.get("timeSec")) *
                                                            (1 / documentSnapshot.get("distance"))) /
                                                        60)
                                                    .floor()
                                                    .toString() +
                                                ":0" +
                                                ((((documentSnapshot.get("timeMin") * 60) + documentSnapshot.get("timeSec")) *
                                                            (1 / documentSnapshot.get("distance"))) %
                                                        60)
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
                                            ((((documentSnapshot.get("timeMin") * 60) + documentSnapshot.get("timeSec")) *
                                                            (1 / documentSnapshot.get("distance"))) /
                                                        60)
                                                    .floor()
                                                    .toString() +
                                                ":" +
                                                ((((documentSnapshot.get("timeMin") * 60) + documentSnapshot.get("timeSec")) *
                                                            (1 / documentSnapshot.get("distance"))) %
                                                        60)
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
                                      Text(documentSnapshot.get("average_heartrate").toString(),
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
                      ),
                    )),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
