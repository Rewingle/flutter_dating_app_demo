import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigText extends StatelessWidget {
  
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  BigText(
      {Key? key,
      this.color = const Color(0xFF332d2b), // it cant be variable, so we used hex 
      required this.text,
      this.size = 20,
      this.overFlow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
    maxLines: 1,
        overflow: overFlow,
        softWrap: false,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
              color: color, 
              fontWeight: FontWeight.w600,    
              fontSize: size),
        ));
  }
}
