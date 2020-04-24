import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'classes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Geoflutterfire geo = Geoflutterfire();
  FirebaseUser _loggedIn;

  get userRef => _db.collection('Utilisateur');

  FirebaseUser get loggedIn => _loggedIn;

  /* _signInG() async {
    try{
      await _googleSignIn.signIn();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn() ;
      GoogleSignInAuthentication googleAuth = await googleUser.authentication ;
      FirebaseUser user = await _auth.signInWithGoogle(
        accessToken
      )
      setState(() {
        _isLoggedin=true ;
        print('vous etes connecte');
      })
    }
    catch(err){
      print(err);
    };*/ //on doit avoir stateful widget

  /* _signOutG() async {
      try{
        await _googleSignIn.signOut();

      }
      catch(err){
        print(err);
      }
  }
*/
  GoogleSignIn get googleSignIn => _googleSignIn;

  Firestore get db => _db;

  FirebaseAuth get auth => _auth;


  set loggedIn(FirebaseUser value) {
    _loggedIn = value;
  }

  Utilisateur toUtil() {
    loggedIn = auth.currentUser() as FirebaseUser;
    return Utilisateur(
      pseudo: loggedIn.uid,
      tel: loggedIn.phoneNumber,
      mail: loggedIn.email,
    );
  }

  getUser(String idDoc) {
    return Firestore.instance.collection('Utilisateur')
        .document(idDoc)
        .snapshots();
  }

  String connectedID() {
    // returns null when no user is logged in
    // print('stratConnectedid');
    auth.currentUser().then((onValue) {
      //  print(onValue.email);
      print(onValue.uid);
      // print('endConnectedid');
      return onValue.uid;
    }).catchError((onError) {
      //   print('caught error connectedID') ;
      //   print(onError);
      print('means none connected');
    });
  }

  Future sendPwdResetEmail(String email) async {
    try {
      final reset = _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  bool isLog() {
    // returns false when no user is logged in
    var ui = connectedID();
    if (ui == null) {
      return false;
    } else {
      return true;
    }
  }


  Future<FirebaseUser> getLoggedFirebaseUser() {
    return auth.currentUser();
  }


}

final AuthService authService = AuthService();
