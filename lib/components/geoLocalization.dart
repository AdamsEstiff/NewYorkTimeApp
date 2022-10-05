import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:new_york_times_app/views/locationView.dart';

class LocalizationMobile extends StatefulWidget {
  const LocalizationMobile({Key? key, required this.position})
      : super(key: key);
  final Position? position;

  @override
  State<LocalizationMobile> createState() => _LocalizationMobileState();
}

class _LocalizationMobileState extends State<LocalizationMobile> {
  String? country = '';
  late double latitud;
  late double longitud;

  @override
  initState() {
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    latitud = widget.position?.latitude as double;
    longitud = widget.position?.longitude as double;
    List<Placemark> placemark =
    await placemarkFromCoordinates(latitud, longitud);
    setState(() {
      country = placemark[0].country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
      child: TextButton(
        onPressed: (() {
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => LocationView(longitud:longitud, latitud: latitud,)));
        }),
        child: RichText(
          text: TextSpan(
            text: 'Good Morning ',
            style: DefaultTextStyle
                .of(context)
                .style,
            children: <TextSpan>[
              TextSpan(
                  text: '$country,',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'here are the most viewed articles for the last day!'),
            ],
          ),
        ),
      ),
    );
  }
}
