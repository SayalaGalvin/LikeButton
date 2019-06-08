import 'package:flutter_notification/publishpost.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_id/device_id.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PublishPost(),

    );
  }

}
