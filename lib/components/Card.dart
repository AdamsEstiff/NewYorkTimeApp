import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//este componente es para ordenar la informacion que llega en la api y mostrar
//un card donde se vea todo como se quiere
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

  //metodo para abrir el link de redireccionamiento
  void _launchUrl() async {
    Uri _url = Uri.parse(url);
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }

  //
  @override
  Widget build(BuildContext context) {
    //se asigna la imagen con mayor resolución
    dynamic image = media["media-metadata"][2];
    return Container(
      //todo el estilo que tendra el contenedor de la información
      decoration: BoxDecoration(
        //configuracion de los bordes del contenedor
        borderRadius: BorderRadius.all(Radius.circular(25)),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      //el margen del contenedor
      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
      //una columna para poder poner multiples widgets
      child: Column(
        children: [
          //se decide si la imagen se ve, dependiendo de si existe o no
          Visibility(
            visible: image['url'] != null,
            //establecer border redondeados en la imagen
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(0.0),
                  bottomLeft: Radius.circular(0.0),
                ),
                child: Image.network(image['url'])),
          ),
          //margen entre widgets
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
            //el texto del titulo
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
            //el texto del abstrac
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
          //aca se manda al link donde leeran la noticia completa
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
