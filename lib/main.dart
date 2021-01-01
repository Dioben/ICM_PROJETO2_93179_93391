import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/widgets/login.dart';
import 'package:track_keeper/widgets/mainmenu.dart';
import 'package:track_keeper/widgets/start-load.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: StartFuture(),
  theme: ThemeData(
    accentColor: Colors.greenAccent,
    primaryColor: Colors.green,
    // This is the theme of your application.
    //
    // Try running your application with "flutter run". You'll see the
    // application has a blue toolbar. Then, without quitting the app, try
    // changing the primarySwatch below to Colors.green and then invoke
    // "hot reload" (press "r" in the console where you ran "flutter run",
    // or simply save your changes to "hot reload" in a Flutter IDE).
    // Notice that the counter didn't reset back to zero; the application
    // is not restarted.
    primarySwatch: Colors.green,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: Colors.green)),
  )
  ));
}

class StartFuture extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:_initialization,
        builder: (context,snapshot){
         if (snapshot.hasError) {return Text("Failed to connect to firebase");}
         if (snapshot.connectionState==ConnectionState.done){
                FirebaseAuth auth = FirebaseAuth.instance;
                if (auth.currentUser==null) return LoginMenu();
                FirebaseApiClient.instance.setUser(auth.currentUser);
                  return MainMenu();}
         return StartLoad();
        });
  }
}
