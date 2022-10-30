import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//
// const primaryColor = Color(0xFF2697FF);
// const secondaryColor = Color(0xFF0B0B10);
// const bgColor = Color(0xFFE8E8E8);
const textColor=Color(0xFF203A43);
var toptextColor=Color(0xFF2980B9);

const lightThemeColor=Colors.black45;
const darkThemeColor=Colors.white70;
const defaultPadding = 12.0;
const kCompleted='Completed';
const kProcessing='Processing';
const kCancelled='Cancelled';
const darkBlue=Color(0xff1C64CC);
const dullGrey=Color(0xff707070);
const lightBlue=Color(0xff2FA1FD);
const headingColor=Color(0xff555557);
const fillColor=Color(0xff7AB9F7);
const dialogueColor=Colors.white;
const picQuality=60;
ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      centerTitle: true,

    ),
//scaffoldBackgroundColor: tarawera,
    //backgroundColor: Colors.black45,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      displayColor:Colors.black,
      bodyColor: Colors.black,
    ),
    hintColor: darkThemeColor,
    inputDecorationTheme: InputDecorationTheme(
      iconColor: darkThemeColor,
      focusedBorder:OutlineInputBorder(
        borderSide: BorderSide(width: 1 , color: darkBlue),
        borderRadius: BorderRadius.circular(20.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1 , color: darkBlue),
        borderRadius: BorderRadius.circular(20.0),
      ),
      border:  OutlineInputBorder(),

      labelStyle: const TextStyle(
        color:darkThemeColor,

      ),),



    focusColor: Colors.white,
    brightness: Brightness.light,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black12,
      selectionColor: Colors.black12,
      selectionHandleColor:Colors.black12,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape:MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),

          ),),

          backgroundColor: MaterialStateProperty.all<Color>(Colors.purpleAccent),
          textStyle:  MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
          )),
        )
    )
);

ThemeData lightTheme = ThemeData(

    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      centerTitle: true,

    ),
    // scaffoldBackgroundColor: Colors.lightBlue,
    //backgroundColor: Colors.black45,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      displayColor:Colors.black,
      bodyColor: Colors.black,
    ),
    hintColor: darkThemeColor,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1 , color: darkBlue),
        borderRadius: BorderRadius.circular(20.0),
      ),
      iconColor: darkThemeColor,
      focusedBorder:OutlineInputBorder(
        borderSide: BorderSide(width: 1, color:darkBlue),
        borderRadius: BorderRadius.circular(20.0),
      ),
      border: const OutlineInputBorder(),
      labelStyle: const TextStyle(
        color:darkThemeColor,

      ),),



    focusColor: Colors.white,
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black12,
      selectionColor: Colors.black12,
      selectionHandleColor: Colors.black12,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape:MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),

          ),),

          backgroundColor: MaterialStateProperty.all<Color>(Colors.purpleAccent),
          textStyle:  MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
          )),
        )
    )
);