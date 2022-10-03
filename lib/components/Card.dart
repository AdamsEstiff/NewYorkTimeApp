import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  const Card(
      {Key? key,
      required this.title,
      required this.abstract,
      required this.url,
      required this.image})
      : super(key: key);
  final String title;
  final String abstract;
  final String url;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
