import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:new_york_times_app/views/locationView.dart';
//este es el componente para mostrar un mensaje con el pais de la persona
class LocalizationMobile extends StatefulWidget {
  const LocalizationMobile({Key? key, required this.position})
      : super(key: key);
  //se recibe su posicion actual
  final Position? position;

  @override
  State<LocalizationMobile> createState() => _LocalizationMobileState();
}

class _LocalizationMobileState extends State<LocalizationMobile> {
  //variable que contendra el país donde estas
  String? country = '';
  //aqui contendra la latitud
  late double latitud;
  //aqui la longitud
  late double longitud;

  @override
  initState() {
    //se inicializa desde el principio para obtener los datos pertinentes
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    //se asigna el valor de la latitud
    latitud = widget.position?.latitude as double;
    //se asigna el valor de la longitud
    longitud = widget.position?.longitude as double;
    //aca se obtiene el pais en el que esta el usuario
    List<Placemark> placemark =
    await placemarkFromCoordinates(latitud, longitud);
    setState(() {
      //aca se le asigna el pais correspondiente
      country = placemark[0].country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
      //boton para redireccionar a la vista donde se muestra la localizacion del
      //usuario en un mapa mundial digital
      child: TextButton(
        onPressed: (() {
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => LocationView(longitud:longitud, latitud: latitud,)));
        }),
        child: RichText(
          text: TextSpan(
            //texto inicial
            text: 'Good Morning ',
            style: DefaultTextStyle
                .of(context)
                .style,
            children: <TextSpan>[
              //nombre del pais
              TextSpan(
                  text: '$country,',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              //texto final
              TextSpan(
                  text: 'here are the most viewed articles for the last day!'),
            ],
          ),
        ),
      ),
    );
  }
}
