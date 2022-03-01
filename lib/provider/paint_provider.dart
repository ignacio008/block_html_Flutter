
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import 'dart:ui' as ui;

import 'package:z06_blocks_notess/painter.dart';

class PaintProvider extends ChangeNotifier{
    
  bool showingDialog= false;
    
   changeView(bool nuevo){   
      notifyListeners();
       showingDialog=nuevo;
     
  }
}