import 'package:flutter/material.dart';
import 'package:new_york_times_app/components/Card.dart';
import 'package:new_york_times_app/views/home.dart';

class CardList extends StatelessWidget {
  const CardList({Key? key, required this.futureNews}) : super(key: key);
  final Future<News>? futureNews;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<News>(
      future: futureNews,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data!.results;
          return Column(
                children: [
                  for (var items in data)
                    Container(
                      child: CardNews(
                          title: items['title'],
                          abstract: items['abstract'],
                          url: items['url'],
                          media: items['media'][0]),
                    ),
                ],
              );
          // return ListView.builder(
          //   itemCount: data.length,
          //   itemBuilder: (context, idx) {
          //     var items = data[idx];
          //     String title = items['title'];
          //     String abstract = items['abstract'];
          //     String url = items['url'];
          //     dynamic media = items['media'][0];
          //     dynamic image = media["media-metadata"][2];
          //     return Container(
          //       child: CardNews(
          //           title: title,
          //           abstract: abstract,
          //           url: url,
          //           media: image),
          //     );
          //   },
          // );
        } else if (snapshot.hasError) {
          return Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.black, fontSize: 11),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
