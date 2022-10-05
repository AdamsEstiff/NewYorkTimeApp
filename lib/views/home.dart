import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:new_york_times_app/components/Card.dart';
import 'package:new_york_times_app/components/input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_york_times_app/components/geoLocalization.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<News> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=Lqo0YKENCZ9CxQJa9djDu0tJM0g4nulQ'));

  return News.fromJson(jsonDecode(response.body));
}

class News {
  final List<dynamic> results;

  const News({required this.results});

  factory News.fromJson(json) {
    return News(results: json['results']);
  }
}

class _HomeState extends State<Home> {
  late Future<News> futureNews;
  late Future<Position> position;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  late var newsFilter;

  @override
  void initState() {
    futureNews = fetchNews();
    position = _determinePosition();
    listeners();
    super.initState();
  }

  listeners() {
    title.addListener(() {
      if (title.value.text == title.value.text) {
        setState(() {
          title.value.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/The_New_York_Times_Logo.svg/2560px-The_New_York_Times_Logo.svg.png'),
              ),
              FutureBuilder<Position>(
                  future: position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Position data = snapshot.data!;
                      return LocalizationMobile(position: data);
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.black, fontSize: 11),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              Form(
                  key: _formKey,
                  child: Input(
                    controller: title,
                  )),
              FutureBuilder<News>(
                future: futureNews,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.results;
                    newsFilter = data.where((element) {
                      return element['title']
                          .toLowerCase()
                          .contains(title.value.text.trim().toLowerCase());
                    }).toList();
                    return Column(
                      children: [
                        for (var items in newsFilter)
                          Container(
                            child: CardNews(
                                title: items['title'],
                                abstract: items['abstract'],
                                url: items['url'],
                                media: items['media'][0]),
                          ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.black, fontSize: 11),
                    );
                  }
                  return Center(child: const CircularProgressIndicator());
                },
              ),
            ],
          )),
    );
  }
}
