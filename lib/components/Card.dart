import 'package:flutter/material.dart';

class CardNews extends StatelessWidget {
  const CardNews(
      {Key? key,
      required this.title,
      required this.abstract,
      required this.url,
      required this.image})
      : super(key: key);
  final String title;
  final String abstract;
  final String url;
  final dynamic image;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Colors.black, fontSize: 11),
    );
  }
}
