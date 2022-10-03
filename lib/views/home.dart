import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:new_york_times_app/components/Card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Future<News> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=Lqo0YKENCZ9CxQJa9djDu0tJM0g4nulQ'));
  print(response.body);
  return News.fromJson(jsonDecode(response.body));
}

class News {
  final List<dynamic> results;

  const News({required this.results});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(results: json['results']);
  }
}

class _HomeState extends State<Home> {
  late Future<News> futureNews;

  @override
  void initState() {
    futureNews = fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: FutureBuilder<News>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data!.results;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, idx) {
                  var items = data[idx];
                  String title = items['title'];
                  String abstract = items['abstract'];
                  String url = items['url'];
                  dynamic media = items['media'];
                  return Container(
                    child: CardNews(
                        title: title,
                        abstract: abstract,
                        url: url,
                        image: media),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.black, fontSize: 11),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
