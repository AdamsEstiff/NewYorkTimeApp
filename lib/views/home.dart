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
  //En esta parte verifica los permisos que le concede el usuario
  // Prueba si los servicios de ubicación están habilitados.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    //  Si los servicios de ubicación no están habilitados, no continua
    return Future.error('Los servicios de ubicación están deshabilitados.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Los permisos están denegados, la próxima vez podría intentarlo
      return Future.error('Los permisos de ubicación están denegados');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Los permisos se deniegan para siempre, maneje adecuadamente.
    return Future.error(
        'Los permisos de ubicación se niegan permanentemente, no podemos solicitar permisos.');
  }

  // Cuando llegamos aquí, se otorgan los permisos y podemos
  // continuamos accediendo a la posición del dispositivo.
  return await Geolocator.getCurrentPosition();
}

//esta parte es para consumir Api de new york times, claro de manera asincrona
Future<News> fetchNews() async {
  //aca se le pasa la direccion de la api con la respectiva api key
  final response = await http.get(Uri.parse(
      'https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=Lqo0YKENCZ9CxQJa9djDu0tJM0g4nulQ'));
  //aqui se pasa la informacion deseada pero en formato Json
  return News.fromJson(jsonDecode(response.body));
}

//aqui se define que datos vamos a necesitar para consumir api
class News {
  //en este caso solo queria uno, un dato de tipo List para luego darle el
  // formato que yo necesitara
  final List<dynamic> results;

  const News({required this.results});

  factory News.fromJson(json) {
    return News(results: json['results']);
  }
}

class _HomeState extends State<Home> {
  //aqui esta el contenedor para tener los datos del api
  late Future<News> futureNews;

  //variable para saber la posicion del dispositivo
  late Future<Position> position;

  //esta parte es para utilizar bien el input de la busqueda
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //aca la parte para utilizar el input y obtener todo lo que se le introduzca
  TextEditingController title = TextEditingController();

  //este dato de tipo dynamic se utiliza para introducirle la información
  //modificada segun lo que el usuario escriba en el input o no escriba
  late dynamic newsFilter;

  @override
  void initState() {
    //se asignan los valores de las noticias para posteriormente mostrarlos
    // en pantalla
    futureNews = fetchNews();
    //se le da la posición actual del dispositivo
    position = _determinePosition();
    //aca se activaa el listener para que se refresque la vista cada vez que se
    // utiliza el input
    listeners();
    super.initState();
  }

  @override
  void dispose() {
    //si se sale de esta vista, aqui se encarga de no este activo el input
    title.dispose();
  }

  listeners() {
    //aca se escucha cuando hay un cambio en el input y se refresca en pantalla
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
        //se determina el color del fondo
          color: Colors.white,
          child: ListView(
            //para colocar mas de un widget y que se pueda hacer scroll
            children: [
              //imagen de logo
              Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/The_New_York_Times_Logo.svg/2560px-The_New_York_Times_Logo.svg.png'),
              ),
              //se muestra un mensaje con el pais donde este el usuario
              FutureBuilder<Position>(
                  future: position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Position data = snapshot.data!;
                      //se muestra un mensaje donde el usuario se encuentra
                      //tambien se envia su latitud y longitud
                      return LocalizationMobile(position: data);
                      //verifica errores que pueden ocurrir
                    } else if (snapshot.hasError) {
                      //mensaje donde informa del error
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.black, fontSize: 11),
                      );
                    }
                    //lo que se muestra en pantalla mientras los datos se cargan
                    //ya que son datos asincronos
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              //aca el imput para buscar informacion dentro de las noticias
              Form(
                  key: _formKey,
                  //aqui un componente hecho por su servidor para que se
                  // parezca a la propuesta
                  child: Input(
                    controller: title,
                  )),
              //aca se muestra la informacion de las noticias
              FutureBuilder<News>(
                future: futureNews,
                builder: (context, snapshot) {
                  //verifica si la informacion ya a llegado
                  if (snapshot.hasData) {
                    //en esta parte se ordena la información segun la necesidad
                    var data = snapshot.data!.results;
                    //aca es donde se filtra segun lo escrito en el input
                    newsFilter = data.where((element) {
                      return element['title']
                          .toLowerCase()
                          .contains(title.value.text.trim().toLowerCase());
                    }).toList();
                    //aqui se hace una columna donde se pondran todas las Cards
                    return Column(
                      children: [
                        //iteracion de elementos
                        for (var items in newsFilter)
                          Container(
                            //componente para mostrar los elementos ordenados
                            child: CardNews(
                                title: items['title'],
                                abstract: items['abstract'],
                                url: items['url'],
                                media: items['media'][0]),
                          ),
                      ],
                    );
                    // si a ocurrido un error, se mostrara un mensaje
                  } else if (snapshot.hasError) {
                    //aqui esta el mensaje
                    return Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.black, fontSize: 11),
                    );
                  }
                  //si la informacion aun no se a cargado, pues aca se le
                  // muestra un circulo de carga
                  return Center(child: const CircularProgressIndicator());
                },
              ),
            ],
          )),
    );
  }
}
