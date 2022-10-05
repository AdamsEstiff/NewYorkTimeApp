import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//esta vista es para mostrar la ubicacion actual del usuario en cuestion
//utilizando un mapa global digital
class LocationView extends StatefulWidget {
  const LocationView({Key? key, required this.latitud, required this.longitud})
      : super(key: key);
  final double latitud;
  final double longitud;

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  Widget build(BuildContext context) {
    //se asignan la longitud y latitud a dos variables
    double latitud = widget.latitud;
    double longitud = widget.longitud;
    return Scaffold(
      appBar: AppBar(
        //mensaje guia para que el usuario sepa que es esta ventana
        title: Text(
          'Tu localización actual',
          style: TextStyle(color: Colors.black),
        ),
        //color de la barra
        backgroundColor: Colors.white,
        //para que el usuario pueda volver a home
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: Center(
          child: Container(
        child: Column(
          children: [
            Flexible(
              //aca es el mapa donde esta el usuario
                child: FlutterMap(
                  //aca se le pasa la longitud y la latitud del ya mencionado
              options: MapOptions(center: LatLng(latitud, longitud), zoom: 16),
              //como se ve el mapa
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                ),
              ],
              children: [
                //la configulacion de la vista
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    //aca el icono que muestra la ubicacion exacta
                    Marker(
                      //donde colocar el icono exactamente
                        point: LatLng(latitud, longitud),
                        builder: (ctx) => Icon(
                          //el tipo de icono
                              Icons.place,
                              //el tamaño
                              size: 70,
                              //el color
                              color: Colors.blue,
                            ))
                  ],
                )
              ],
            ))
          ],
        ),
      )),
    );
  }
}
