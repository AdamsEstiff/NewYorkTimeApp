import 'package:flutter/material.dart';
class Input extends StatelessWidget {
  const Input({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 65,
          margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, TextEditingValue value, __){
              return TextFormField(
                controller: controller,
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignLabelWithHint: false,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                      BorderSide(width: 1, color: Color(0xFFFAA82D))),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                      borderSide:
                      BorderSide(width: 1, color: Color(0x28DDDDDD))),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(Icons.search_sharp),
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
