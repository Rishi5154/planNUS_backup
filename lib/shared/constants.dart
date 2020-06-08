import 'package:flutter/material.dart';

const textInputDecorationProfile = InputDecoration(
    icon: Icon(Icons.person_outline, color: Colors.white),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
    )
);

const textInputDecorationPassword = InputDecoration(
    icon: Icon(Icons.lock, color: Colors.white),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
    )
);

const textInputDecorationEmail = InputDecoration(
    icon: Icon(Icons.alternate_email, color: Colors.white),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
    )
);
