
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:winek/auth.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/register_screen.dart';
import '../UpdateMarkers.dart';
import '../classes.dart';
import 'package:winek/screensRima/resetmail.dart';
import 'resetmail.dart';
import '../auth.dart';
import 'dart:async';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';


void getUserLocation() async {
  var val = await authService.connectedID();
  if (val != null) // ca permetra de faire lappel seulement quand le user est co
      {
    try {
      var geolocator = Geolocator();
      var locationOptions = LocationOptions(
          accuracy: LocationAccuracy.high, distanceFilter: 10);
      StreamSubscription<Position> positionStream = geolocator
          .getPositionStream(locationOptions).listen(
              (Position position) {
            GeoFirePoint geoFirePoint = authService.geo.point(
                latitude: position.latitude, longitude: position.longitude);
            authService.userRef.document(val).updateData(
                {'location': geoFirePoint.data});
            print(geoFirePoint.data.toString());
          });
    } catch (e) {
      print('ya eu une erreur pour la localisation');
    }
  }
}

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pwd, mail, errMl, errPwd;

  final GlobalKey<ScaffoldState> _loginKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _loginKey,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            //tce widget permet de faire en sorte de scroller la page et pas la cacher avec le clavier
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),

                Container(

                  height: 120.0,
                  child: Image.asset('images/logo.png', fit: BoxFit.fill,height: 120.0,width: 120.0,),
                ),
                Text(
                  'Winek',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                    color:Color(0XFF3B466B),

                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Connexion',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0XFF389490),//vert
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    mail = value;
                    setState(() {
                      !Validator.email(mail) ? errMl = null : errMl =
                      "Veuillez introduire une adresse valide";
                    });
                  },

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',

                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    labelText: 'Adresse mail',
                    hoverColor: Colors.black87,
                    errorText: errMl,
                    errorStyle: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Montserrat',

                        fontWeight: FontWeight.bold),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    pwd=value ;
                  },
                  obscureText: true,
                  autocorrect: false,

                  style: TextStyle(
                    fontFamily: 'Montserrat',

                    color: Colors.black87,
                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blueGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blueGrey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'mot de passe oublie ?',
                    style: TextStyle(
                      color:Color(0XFF389490),

                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ResetMailScreen.id);
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),

                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        color:Color(0XFF3B466B),

                        child: MaterialButton(

                          onPressed: () =>
                              Navigator.pushNamed(
                                  context, RegistrationScreen.id), //_signInG(),
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(

                            "S'inscrire",

                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color:Colors.white,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color:Color(0XFF389490),

                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () => connect(),

                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'Se connecter',

                            style: TextStyle(
                              color: Colors.white ,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold ,

                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                  child: Material(
                    color: Colors.white,

                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () => _signInWithGoogle(),

                      height: 42.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(

                              height: 42,
                              child: Image.asset(
                                  'images/googlelogo.png', fit: BoxFit.fill)),
                          Text(
                            'Google',

                            style: TextStyle(
                              color: Color(0XFF707070),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  Future<String> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await authService.googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await authService.auth.signInWithCredential(
          credential)).user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await authService.auth.currentUser();
      assert(user.uid == currentUser.uid);

      print('loggein is cette personnnee');
      print(currentUser.email);
      if (user != null) {
        authService.db.collection('Utilisateur').document(user.uid).updateData(
            {'connecte': true});
        print('user logged in');
        // getUserLocation();
        // Provider.of<DeviceInformationService>(context, listen: false)
        //   .broadcastBatteryLevel(user.uid);
      }
      else {
        print('failed google authetication');
      }
    }
    catch (logIn) {
      if (logIn is PlatformException) {
        if (logIn.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          _loginKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                  'Veuillez verifiez votre connexion internet et reessayez',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600),),
                duration: Duration(seconds: 5),
              ));
        }
        else {
          print(logIn);
        }
      }
    }
  }

  connect() async {
    try {
      if (pwd.isEmpty) {
        _loginKey.currentState.showSnackBar(
            SnackBar(
              content: Text('veuillez introduire un mot de passe',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),),
              duration: Duration(seconds: 3),
            ));
      } else {
        final user = await authService.auth.signInWithEmailAndPassword(
            email: mail,
            password: pwd);
        if (user != null) {
          getUserLocation();
          Provider.of<DeviceInformationService>(context, listen: false)
              .broadcastBatteryLevel(user.user.uid);
          authService.userRef.document(user.user.uid).updateData(
              {'connecte': true});
          DocumentSnapshot snapshot = await authService.userRef.document(
              user.user.uid).get();

          if (snapshot != null) {
            Utilisateur utilisateur = Utilisateur.fromdocSnapshot(snapshot);
            Navigator.pushNamed(context, Home.id);
            /* Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProfileScreen(utilisateur)
          ));*/
            print(utilisateur.pseudo);
            print(utilisateur.tel);
          }
        }
      }
    }
    catch (logIn) {

        if (logIn is PlatformException) {
          if (logIn.code == 'ERROR_USER_NOT_FOUND') {
            setState(() {
              errMl = 'Utilisateur inexistant';
            });
            _loginKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(errMl,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),),
                  duration: Duration(seconds: 3),
                ));
            /*final snackBar = SnackBar(
                content: Text(errMl),
                action: SnackBarAction(
                    label: 'Refresh',
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },));
            Scaffold.of(context).showSnackBar(snackBar);*/
            print(logIn);
            print(errMl);

          } else {
            print(logIn);
            setState(() {
              errMl = null;
            });
          }
          if (logIn.code == 'ERROR_INVALID_EMAIL') {
            print(logIn);
            setState(() {
              errMl = "Veuillez introduire une adresse valide";
            });
            _loginKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(errMl,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),),
                  duration: Duration(seconds: 3),
                ));
          } else {
            print(logIn);
            setState(() {
              errMl = null;
            });
          }
          if (logIn.code == 'ERROR_WRONG_PASSWORD') {
            print(logIn);
            setState(() {
              errPwd = 'Mot de passe errone';


            });
            _loginKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(errPwd,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),),
                  duration: Duration(seconds: 3),
                ));
          }
          else {
            setState(() {
              errPwd = null;
            });
          }
          if (logIn.code == 'ERROR_NETWORK_REQUEST_FAILED') {
            _loginKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                    'Veuillez verifiez votre connexion internet et reessayez',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),),
                  duration: Duration(seconds: 5),
                ));

          }
          else {
            setState(() {
              errPwd = null;
            });
          }
        }
    }
  }

  Widget showSpinner() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Color(0XFF389490),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String message, String heading,
      String buttonOKTitle) {
    // set up the buttons
    Widget OKButton = FlatButton(
      child: Text(buttonOKTitle),
      onPressed: () => Navigator.pop(context),
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      actions: [

        OKButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
