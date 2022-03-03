import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:z06_blocks_notess/alert/widget_show_sticker.dart';
import 'package:z06_blocks_notess/model/model_sticker.dart';

class ShowSticker extends StatefulWidget {
  HtmlEditorController controller = HtmlEditorController();
  List<ModelSticker> iconmodelSticker;
  ShowSticker(this.controller,this.iconmodelSticker);

  @override
  State<ShowSticker> createState() => _ShowStickerState();
}

class _ShowStickerState extends State<ShowSticker> {
  ScrollController controller;

  @override
  void initState() {
     controller= ScrollController();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      insetPadding:  const EdgeInsets.only(top: kIsWeb?290:10),
        contentPadding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        title: const Text("Selecciona tu Sticker"),
        content: Container(
            width:MediaQuery.of(context).size.width*0.95,
            height:kIsWeb?MediaQuery.of(context).size.height*0.3:MediaQuery.of(context).size.height*0.11,
           // color:Colors.blue[100],
            padding:EdgeInsets.all(10),

            child: Scrollbar(
              isAlwaysShown: true,
                controller:controller,
              child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                itemCount: widget.iconmodelSticker.length,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  // ignore: avoid_unnecessary_containers
                  return  Row(
                              mainAxisAlignment: MainAxisAlignment.center,              
                              children: [              
              widget.iconmodelSticker.isEmpty?CircularProgressIndicator(): SizedBox(width:20), WidgetShowSticker(widget.iconmodelSticker[index], widget.controller),
                            ],);


                },
              ),
            ),
        ),
         actions: <Widget>[
          FlatButton(
            child:
                const Text("Cancelar", style: (TextStyle(color: Colors.blue))),
            onPressed: () {
              Navigator.pop(context);

              if (kIsWeb) {
               // paintProviderVisibility.changeView(nuevoShowDialog);
              }
            },
          ),
          
        ]
        );
    
  }
}