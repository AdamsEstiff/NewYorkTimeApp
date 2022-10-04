import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:new_york_times_app/components/input.dart';
import 'package:new_york_times_app/components/CardList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Future<News> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=Lqo0YKENCZ9CxQJa9djDu0tJM0g4nulQ'));
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    futureNews = fetchNews();
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/The_New_York_Times_Logo.svg/2560px-The_New_York_Times_Logo.svg.png'),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
              child: Center(
                  child: Container(
                child: Text(
                  'Good Morning Costa Rica, here are the most viewed articles for the las day!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              )),
            ),
            Form(
                key: _formKey,
                child: Input(
                  controller: title,
                )),
            SingleChildScrollView(child: CardList(futureNews: futureNews))
          ],
        ));
  }
}
