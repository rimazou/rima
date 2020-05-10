import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/auth.dart';
import 'package:winek/screensRima/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:winek/UpdateMarkers.dart';

class SignoutWait extends StatefulWidget {
  @override
  _SignoutWaitState createState() => _SignoutWaitState();
  static String id = 'waitSignout';
}

class _SignoutWaitState extends State<SignoutWait> {
  @override
  void initState() {
    super.initState();
    _signOut();
  }

  _signOut() async {
    try {
      print(' debutsignout');
      /*print(authService.connectedID());
       authService.connectedID()!=null? print('theres is a user connected') : print ('pas de uuser ') ;
      print('avant singnout');
      authService.auth.signOut();
      print('apres signout');
      authService.connectedID()!='noUser'? print('theres is a user connected') : print ('pas de uuser ') ;

       // authService.googleSignIn.signOut();*/
      // Provider.of<AuthService>(context, listen: false).positionStream.cancel();
      // Provider.of<DeviceInformationService>(context, listen: false).stopBroadcast();
      await authService.connectedID().then((val) {
        print(val);
        authService.auth.signOut();
        authService.userRef.document(val).updateData({'connecte': false});
        print('plus d user');
      }).catchError((onError) {
        print('an error occured ');
      });
      print(' fin signout');
      Navigator.pushNamed(context, WelcomeScreen.id);
    } on Exception catch (e) {
      print(e.toString());
    }

    // await authService.userRef.document('').updateData({'connecte':false}) ;
    /*authService.auth.signOut().then((onValue) {
      print(authService.isLog());
      authService.connectedID() != null
          ? print('theres is a user connected')
          : print('pas de uuser ');
    });*/
    //  authService.connectedID()!=null? print('theres is a user connected') : print ('pas de uuser ') ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      ),
    );
  }
}
