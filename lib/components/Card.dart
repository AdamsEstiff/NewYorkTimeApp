import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardNews extends StatelessWidget {
  const CardNews(
      {Key? key,
      required this.title,
      required this.abstract,
      required this.url,
      required this.media})
      : super(key: key);
  final String title;
  final String abstract;
  final String url;
  final dynamic media;

  //metodo para abir el link de redireccionamiento
  void _launchUrl() async {
    Uri _url = Uri.parse(url);
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    dynamic image = media["media-metadata"][2];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
              ),
              child: Visibility(
                  visible: image['url'] != null,
                  child: Image.network(image['url']))),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: "times new roman",
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              abstract,
              style: TextStyle(
                fontFamily: "times new roman",
                decoration: TextDecoration.none,
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: _launchUrl,
                child: Text(
                  'Read More',
                  style: TextStyle(color: Colors.black),
                )),
          )
        ],
      ),
    );
  }
}
