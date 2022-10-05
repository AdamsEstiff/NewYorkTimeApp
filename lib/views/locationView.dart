import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
    double latitud = widget.latitud;
    double longitud = widget.longitud;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tu localización actual',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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
                child: FlutterMap(
              options: MapOptions(center: LatLng(latitud, longitud), zoom: 16),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                        point: LatLng(latitud, longitud),
                        builder: (ctx) => Icon(
                              Icons.place,
                              size: 70,
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
