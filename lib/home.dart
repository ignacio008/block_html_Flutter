import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:z06_blocks_notess/alert/paint.dart';
import 'package:z06_blocks_notess/alert/paint_design.dart';
import 'package:z06_blocks_notess/painter.dart';

import 'dart:ui' as ui;

import 'package:z06_blocks_notess/provider/paint_provider.dart';

class home1 extends StatefulWidget {
  home1({Key key}) : super(key: key);

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  String result = '';

  // final descripcion_servicios= TextEditingController();
  // File _imagen;
  File _imagen;
  List<Offset> _points = <Offset>[];
  bool showingDialog = false;

  PlatformFile objFile = null;
  final HtmlEditorController controller = HtmlEditorController();

  void changeView(bool nuevo) {
    setState(() {
      showingDialog = nuevo;
    });
  }

  @override
  Widget build(BuildContext context) {
    PaintProvider paintProviderVisibility =
        Provider.of<PaintProvider>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Block de notas"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            paintProviderVisibility.showingDialog == true
                ? Container()
                : HtmlEditor(
                    controller: controller,
                    hint: "Escribe aqui...",
                    options: const HtmlEditorOptions(
                      height: 250,
                    ),
                   toolbar: const [
                     
                    Style(),
                    Font(buttons: [FontButtons.bold, FontButtons.underline, FontButtons.italic]),
                     ColorBar(buttons:[  ColorButtons.backcolor, ColorButtons.forecolor]),
                
                  Insert(buttons:[InsertButtons.link,InsertButtons.hr,InsertButtons.table]),
                  Paragraph(),
                   FontSetting(),

],
                  ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () {
                controller.clear();
              },
           padding: EdgeInsets.only(left:20,top:17, right:20, bottom:17),
            child: Text("Limpiar"),
            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color:Colors.blue, width:2.0),
            ),
            ),               
            const SizedBox(
              width: 16,
            ),

            FlatButton(
               color:Colors.blue,
                 onPressed: () async {
                    final txt = await controller.getText();
                    setState(() {
                      result = txt;
                      print(txt);
                    });
                  },
           padding: const EdgeInsets.only(left:20,top:17, right:20, bottom:17),
            child: const Text("Enviar", style:TextStyle(color:Colors.white)),            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),    
            ),
            ),
            const SizedBox(
              width: 16,
            ),

            FlatButton(
               color:Colors.blue,
                 onPressed: () {
                   controller.setFullScreen();  
                  },
           padding: const EdgeInsets.only(left:20,top:17, right:20, bottom:17),
            child: const Text("Panlla completa", style:TextStyle(color:Colors.white)),            
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),    
            ),
            ),
              ]),

              const SizedBox(
              height: 15,
            ),
            Row(
               mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    controller.insertHtml(
                        "<input type=\"image\"  src=\"https://www.qries.com/images/banner_logo.png\" style=\"color: blue \">Google in blue</input>");
                  },
                  child: const Text("Insertar HTML",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 30),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (kIsWeb) {
                      getImageFile();
                    } else {
                      mostrarOpciones(context);
                    }
                  },
                  child: const Text("Insertar Imagen",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 30),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    setState(() {
                      //provider
                      if (kIsWeb) {
                        paintProviderVisibility.showingDialog = true;
                      }
                    });
                    mostrarPaint(context, controller, );
                  },
                  child: const Text("Dibujar",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void mostrarPaint( BuildContext context, controller,) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PaintDesign(controller,changeView);
        });
  }

  void mostrarOpciones(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              ListTile(
                title: const Text("Camara"),
                leading: const Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                  getImageFile();
                },
              ),
              ListTile(
                title: const Text("Gallery"),
                leading: const Icon(Icons.image),
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  void getImage(ImageSource tipp_Imagen) async {
    var images = await ImagePicker.pickImage(source: tipp_Imagen);
    setState(() {
      _imagen = images;
      print(tipp_Imagen);
      image2Base64();
      //
    });
  }

  void image2Base64() {
    final bytes = File(_imagen.path).readAsBytesSync();
    String base64Image = "data:image/png;base64," + base64Encode(bytes);
    print("img_pan : $base64Image");
    String html2 = "<img src=\"${base64Image}\" style=\" width:25% \" </img>";
    controller.insertHtml(html2);
    print(html2);
  }

  void getImageFile() async {
    if (kIsWeb) {
      final resulta = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: false);
      if (resulta.files.first != null) {
        var fileBytes = resulta.files.first.bytes;
        var fileName = resulta.files.first.name;
        print(String.fromCharCodes(fileBytes));
        image2Base64FilePicker(fileBytes);
      }
    } else {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        image2Base64FilePicker(file);
      } else {
      }
    }
  }

  image2Base64FilePicker(result) {
    if (kIsWeb) {
      String base64Image = "data:image/png;base64," + base64Encode(result);
      print("img_pan : $base64Image");
      String html2 = "<img src=\"${base64Image}\" style=\" width:25% \" </img>";
      controller.insertHtml(html2);
      print(html2);
    } else {
      final bytes = File(result.path).readAsBytesSync();
      String base64Image = "data:image/png;base64," + base64Encode(bytes);
      print("img_pan : $base64Image");
      String html2 = "<img src=\"${base64Image}\" style=\" width:25% \" </img>";
      controller.insertHtml(html2);
      print(html2);
    }
  }
}
