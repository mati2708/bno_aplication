import 'package:bno/pages/calendar.dart';
import 'package:bno/pages/gallery_map.dart';
import 'package:bno/pages/settings_page.dart';
import 'package:bno/pages/strava_activities_page.dart';
import 'package:bno/pages/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';



Future logOut() async {
  await FirebaseAuth.instance.signOut();
}


class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Drawer(
        child: ListView(  
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: Color(0xFF002831),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: 
                        UserImagePicker(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Mateusz Kula",
                      style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          ),
                      ),
                    ),
                    Text(user.email,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                )),
                   ],
                ),
              ),
            ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black,
                  ),
                ),
                title: Text('Kalendarz',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => TableBasicsExample()))
                            },
              ),
            ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    Icons.collections,
                    color: Colors.black,
                  ),
                ),
                title: Text('Galeria map',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      Gallery()))
                            },
              ),
            ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    LineAwesomeIcons.strava,
                    color: Colors.black,
                  ),
                ),
                title: Text('Połącz ze Strava',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () async {
                    var token = await FirebaseAuth.instance.currentUser.getIdToken();
                    launch("https://www.strava.com/oauth/authorize?client_id=63771&redirect_uri=" +
                        Uri.encodeComponent("http://us-central1-bieg-30efa.cloudfunctions.net/authorizeStrava?userToken=" + token) +
                        "&response_type=code&approval_prompt=auto&scope=activity:read&x=d");

                    print("https://www.strava.com/oauth/authorize?client_id=63771&redirect_uri=" +
                        Uri.encodeComponent("http://us-central1-bieg-30efa.cloudfunctions.net/authorizeStrava?userToken=" + token) +
                        "&response_type=code&approval_prompt=auto&scope=activity:read&x=d");
                  },
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    LineAwesomeIcons.plus_square,
                    color: Colors.black,
                  ),
                ),
                title: Text('Dodaj aktywności',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => StravaActivities()));
                  },
              ),
            ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    Icons.query_stats,
                    color: Colors.black,
                  ),
                ),
                title: Text('Statystyki',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () => {},
              ),
              ListTile(
                leading: Padding(
                 padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    LineAwesomeIcons.user_shield,
                    color: Colors.black,
                  ),
                ),
                title: Text('Dane użytkownika',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      SettingsPage()))
                            },
              ),
               ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                  child: Icon(
                    LineAwesomeIcons.alternate_sign_out,
                    color: Colors.black,
                  ),
                ),
                title: Text('Wyloguj',
                style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87)
                    ),
                onTap: () async {
                    logOut();
                  },
              ),
          ],
      ),
    );
  }
}

