// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_market_app/const.dart';
import 'package:url_launcher/url_launcher.dart';

Future<Future> navigateslide(
  Widget pagename,
  BuildContext context,
) async {
  return Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.rightToLeft,
      child: pagename,
    ),
  );
}

Future<Future> navigatedirect(
  Widget pagename,
  BuildContext context,
) async {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => pagename));
}

updateLastActive() {
  FirebaseFirestore.instance
      .collection("Users")
      .doc(constuserid)
      .update({"last_active": DateTime.now()});
}
// Future<void> showSnackMessage(String message, _scaffoldKey) {
//   return _scaffoldKey.currentState.showSnackBar(SnackBar(
//     content: Text(message),
//   ));
// }

// Future<void> checkuserid(
//     String myuserid, userid, username, BuildContext context) {
//   return FirebaseFirestore.instance
//       .collection("Users")
//       .doc(userid.toString())
//       .get()
//       .then((value) => {
//             myuserid.toString() == userid.toString()
//                 ? navigateslide(Profilescreen(), context)
//                 : navigateslide(
//                     VisitUserscreen(
//                       model: UserModel.userFromFirebase(value),
//                       userid: userid.toString(),
//                       username: username.toString(),
//                     ),
//                     context),
//           });
// }

// Future<void> checktagflow(userid, text, BuildContext ctx) {
//   if (text[0] == "@") {
//     String subusername = text.substring(1, text.length.toInt());
//     print(subusername);
//     FirebaseFirestore.instance
//         .collection('Users')
//         .where("username", isEqualTo: subusername)
//         .get()
//         .then((value) {
//       value.docs.length != 0
//           ? checkuserid(userid, value.docs[0]["userid"], subusername, ctx)
//           : navigateslide(
//               NoUserFound(
//                 username: subusername,
//               ),
//               ctx);
//     });
//   } else {
//     print(text);
//     navigateslide(
//         HashtagScreen(
//           hashtag: text,
//         ),
//         ctx);
//   }
// }

// Future<void> acheckuserid(
//     String myuserid, userid, username, BuildContext context) {
//   return FirebaseFirestore.instance
//       .collection("Users")
//       .where("email", isEqualTo: "_emailController")
//       .get()
//       .then((value) async {
//     print(value.docs.length);
//     if (value.docs.length > 0) {
//       //  showSnackMessage(
//       //     "this Email is Already registered with another account");
//     } else {
//       navigateslide(EnterUsername(), context);
//     }
//   });
// }

void showSnackMessage(String message, key) {
  key.currentState.showSnackBar(SnackBar(
    content: Text(message),
  ));
}

// Future<bool> onBackPressed(BuildContext context) {
//   if (Navigator.canPop(context)) {
//     return Future.value(true);
//   } else {
//     return Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
//   }
// }

// void checkstory(void falsestory(), void truestory(), userid) {
//   FirebaseFirestore.instance
//       .collection('Stories')
//       .where("userid", isEqualTo: userid.toString())
//       .get()
//       .then((value) {
//     if (value.docs.length == 1) {
//       truestory();
//     } else {
//       falsestory();
//     }
//   });
// }

// changeaccount(
//   String userid,
//   List userlogged,
//   BuildContext context,
// ) async {
//   print("Account changing");
//   print(userid);
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   await FirebaseFirestore.instance
//       .collection("Users")
//       .doc(userid)
//       .get()
//       .then((value) {
//     sharedPreferences.setString("username", value["username"]);
//     sharedPreferences.setString("name", value["name"]);
//     sharedPreferences.setString("userid", value["userid"].toString());
//     sharedPreferences.setString("bio", value["bio"]);
//     sharedPreferences.setString("userimg", value["userimg"]);

//     print(userlogged.toString() + "itne users login");
//   });
// }

launchURL(String url) async {
  // const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
// xasasass

//    FirebaseFirestore.instance
//                             .collection("Users")
//                             .where("email", isEqualTo: _emailController.text)
//                             .get()
//                             .then((value) async {
//                           print(value.docs.length);
//                           if (value.docs.length > 0) {
//                              showSnackMessage(
//                                 "this Email is Already registered with another account");
//                           } else {
//                                   navigateslide(EnterUsername(), context);

//                           }
//                         });
// }
