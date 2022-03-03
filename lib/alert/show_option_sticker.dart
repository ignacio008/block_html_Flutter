import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:z06_blocks_notess/alert/paint_design.dart';
import 'package:z06_blocks_notess/alert/show_sticker.dart';
import 'package:z06_blocks_notess/firebase/fetch_data.dart';
import 'package:z06_blocks_notess/firebase/query.dart';
import 'package:z06_blocks_notess/model/model_sticker.dart';


class ShowOptionSticker extends StatefulWidget {
  HtmlEditorController controller = HtmlEditorController();
  ShowOptionSticker(this.controller);

  @override
  State<ShowOptionSticker> createState() => _ShowOptionStickerState();
}

class _ShowOptionStickerState extends State<ShowOptionSticker> {
  
 List<ModelSticker>iconmodellistSticker=[];

String id_variable="";
String generateRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  id_variable= List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  return id_variable;
}


  void getTopSticker()async{
    iconmodellistSticker = await FetchData().getTopSticker();
    var tamano= iconmodellistSticker.length;
    print("EL TAMAÑO DE LA LISTA ES: ${tamano}");   
  }
 @override
  void initState() {
    // TODO: implement initState
    getTopSticker();
    generateRandomString(10);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  SimpleDialog(
      
        insetPadding:  const EdgeInsets.only(top: kIsWeb?290:0),
            children: <Widget>[
              ListTile(
                title: const Text("Mostrar Sticker"),
                leading: const Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                 // getImageFile();

                 mostrarSticker(context, widget.controller);
                },
              ),
              ListTile(
                title: const Text("Subir Sticker"),
                leading: const Icon(Icons.image),
                onTap: () {
                  Navigator.pop(context);
                //  getImage(ImageSource.gallery);
              
                getImageFile();

               // mostrarInsertSticker(context, widget.controller);
                },
              ),
            ],
          );
  }

  void mostrarSticker( BuildContext context, controller,) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowSticker(controller,iconmodellistSticker);
        });
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

        //cel
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
         //subirFirebase(file);
        image2Base64FilePicker(file);
      } else {
      }
    }
  }

   image2Base64FilePicker(result) {
    if (kIsWeb) {
      var bytes=result;
      String base64Image = "data:image/png;base64," + base64Encode(result);
      print("img_pan : $base64Image");
      String html2 = "<img src=\"${base64Image}\" style=\" width:12% \" </img>";
      widget.controller.insertHtml(html2);  
      subirFirebase(bytes);
      print(html2);
    
    } else {//cel
      final bytes = File(result.path).readAsBytesSync();
      String base64Image = "data:image/png;base64," + base64Encode(bytes);
      subirFirebase(bytes);
      print("img_pan : $base64Image");
      String html2 = "<img src=\"${base64Image}\" style=\" width:25% \" </img>";
      widget.controller.insertHtml(html2);
      print(html2);
    }
  }



   void subirFirebase(fileBytes)async {
    
    DateTime hoy = DateTime.now();
       final Reference storageReference = FirebaseStorage.instance.ref().child("Photos").child(id_variable);
    final UploadTask uploadTask = storageReference.putData(fileBytes);
    var dowurl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    String url = dowurl.toString();
 
      // UsuarioModel adminmodel = await FetchData().getAdmin(user.uid);
      bool erroguardar=await QuerysService().SaveGeneralInfoSticker(reference: "stickers", id:id_variable, collectionValues:ModelSticker().toJsonBody(id_variable,url,hoy),);
   if(erroguardar){
      }else{
        
      }
  }


 

}