import 'package:flutter/material.dart';


class TipWidget extends StatefulWidget{

  final String tip;

  const TipWidget( this.tip) ;

  @override
  TipWidgetState createState() {
    return TipWidgetState();
  }
}

class TipWidgetState extends State<TipWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      decoration: BoxDecoration(
        color: const Color(0xFF21316B),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(top: 4.0),
      padding:
      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Text(widget.tip,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          color: Color(0xFFFEFEFE),
        ),
      ),
    );
  }
}