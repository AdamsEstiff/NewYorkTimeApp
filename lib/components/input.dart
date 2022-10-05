import 'package:flutter/material.dart';
class Input extends StatelessWidget {
  const Input({Key? key, required this.controller}) : super(key: key);
  //contenido del input
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 65,
          margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
          //refresco de informacion a tiempo real
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, TextEditingValue value, __){
              //el widget que es el input que e estado haciendo referencia en
              //estos comentarios
              return TextFormField(
                //donde se almacena los datos
                controller: controller,
                //decoracion personalizada del input
                decoration: InputDecoration(
                  //la anchura del mismo
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignLabelWithHint: false,
                  //configuracion del borde, cuando se le da focus o no
                  //se define el color, lo grueso y sus bordes
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                      BorderSide(width: 1, color: Color(0xFFFAA82D))),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                      borderSide:
                      BorderSide(width: 1, color: Color(0x28DDDDDD))),
                  //stilo del placeholder
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  //el color del fondo del input
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(Icons.search_sharp),
                  //el placeholder
                  hintText: 'Search',
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
