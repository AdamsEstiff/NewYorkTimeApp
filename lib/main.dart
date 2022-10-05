import 'package:flutter/material.dart';
import 'package:new_york_times_app/views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //no se muestre ninguna etiqueta en la app
      debugShowCheckedModeBanner: false,
      //el titulo de la app
      title: 'NewYork Times',
      //configuraciones globales de estilo de la app
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "times new roman",
      ),
      // aca redirecciona a la primera vista llamada Home
      home: Home(),
    );
  }
}
