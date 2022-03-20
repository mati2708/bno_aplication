import 'package:bno/pages/strava_activities_page.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'home_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

Future logOut() async {
  await FirebaseAuth.instance.signOut();
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    var profileInfo = Expanded(
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(top: 30),
            child: Stack(children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LineAwesomeIcons.pen,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Mateusz Kula",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              )),
          SizedBox(
            height: 3,
          ),
          Text(user.email,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              )),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 30,
        ),
        IconButton(
            icon: Icon(
              LineAwesomeIcons.arrow_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage()));
            }),
        profileInfo,
        Icon(
          LineAwesomeIcons.sun,
          size: 30,
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          header,
          Expanded(
            child: ListView(
              children: <Widget>[
                ProfileListItem(
                  icon: LineAwesomeIcons.user_shield,
                  text: 'Dane użytkownika',
                  onTap: () {},
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.strava,
                  text: 'Dodaj aktywność',
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => StravaActivities()));
                  },
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.strava,
                  text: 'Połącz ze Strava',
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
                ProfileListItem(
                  icon: LineAwesomeIcons.cog,
                  text: 'Ustawienia',
                  onTap: () {},
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  text: 'Wyloguj się',
                  hasNavigation: false,
                  onTap: () async {
                    logOut();
                  },
                ),
              ],
            ),
          ),
          // FlatButton(
          //     onPressed: () async {
          //       var token = await FirebaseAuth.instance.currentUser.getIdToken();
          //       launch("https://www.strava.com/oauth/authorize?client_id=63771&redirect_uri=http://192.168.1.106:5001/bieg-30efa/us-central1/authorizeStrava?userToken=" +
          //           token +
          //           "&response_type=code&approval_prompt=auto&scope=activity:read&x=d");
          //     },
          //     child: Text("Połącz ze Stravą")),
          // FlatButton(
          //     onPressed: () async {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (_) => StravaActivities()));
          //     },
          //     child: Text("Zrób coś ze Stravą")),
        ],
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final text;
  final bool hasNavigation;
  final Function onTap;

  const ProfileListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.grey[200]),
      margin: EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      child: Container(
          child: InkWell(
        onTap: onTap,
        child: Container(
            height: 55,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(this.icon, size: 25),
                SizedBox(
                  width: 25,
                ),
                Text(
                  this.text,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                if (this.hasNavigation) Icon(LineAwesomeIcons.angle_right, size: 25),
              ],
            )),
      )),
    );
  }
}
