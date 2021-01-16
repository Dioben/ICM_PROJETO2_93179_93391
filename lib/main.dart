import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/widgets/login.dart';
import 'package:track_keeper/widgets/mainmenu.dart';
import 'package:track_keeper/widgets/start-load.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
    .then((value) => runApp(MaterialApp(
      home: StartFuture(),
      theme: ThemeData(
        accentColor: Colors.green,
        primaryColor: Colors.green[800],
        primarySwatch: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: Colors.green)),
      )
    ))
  );
}

class StartFuture extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:_initialization,
        builder: (context,snapshot){
          if (snapshot.hasError) {
            return Text("Failed to connect to firebase");
          }
          if (snapshot.connectionState==ConnectionState.done) {
            FirebaseAuth auth = FirebaseAuth.instance;
            if (auth.currentUser==null) return LoginMenu();
            Future<bool> _setUser = FirebaseApiClient.instance.setUser(auth.currentUser);
            return FutureBuilder(
              future: _setUser,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Failed to set user");
                }
                if (snapshot.connectionState==ConnectionState.done) {
                  return MainMenu();
                }
                return StartLoad();
              },
            );
          }
          return StartLoad();
        });
  }
}
