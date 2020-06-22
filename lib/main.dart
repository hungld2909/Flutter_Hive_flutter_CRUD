import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'contact_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/contact.dart';

void main() async {
  //todo: bước 1 cần khởi tạo
  final appDoccumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDoccumentDirectory.path);
  Hive.registerAdapter(ContactAdapter(),);
  // final contactsBox = await Hive.openBox('contacts');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorial',
      home: FutureBuilder(
        future: Hive.openBox(
          'contacts',
          compactionStrategy: (int total, int deleted) {
            return deleted > 20;
          },
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return ContactPage();
          } else
            return Scaffold();
        },
      ),
    );
  }

  @override
  void dispose() {
    //! sử dụng dispose để đỡ tốn bộ nhớ khi tắt app
    Hive.box('contacts').compact();
    Hive.close();
    super.dispose();
  }
}
