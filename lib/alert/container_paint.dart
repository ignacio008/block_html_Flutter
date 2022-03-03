import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:z06_blocks_notess/painter.dart';


import 'dart:ui' as ui;
class ContainerPaint extends StatefulWidget {
   HtmlEditorController controller = HtmlEditorController();
  Function changeView;
  ContainerPaint(this.controller, this.changeView);

  @override
  State<ContainerPaint> createState() => _ContainerPaintState();
}

class _ContainerPaintState extends State<ContainerPaint> {
  List<Offset> _points = <Offset>[];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
                      width:MediaQuery.of(context).size.width*0.5,
                      height:MediaQuery.of(context).size.height*0.3,
                      color:Colors.red,
                      child: ClipRect(
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      RenderBox referenceBox = context.findRenderObject();
                      Offset localPosition =
                          referenceBox.globalToLocal(details.globalPosition);
                      _points = List.from(_points)..add(localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) => _points.add(null),
                  child: CustomPaint(painter: SignaturePainter(_points)),
                ),
              ),
                    ),

            FlatButton(
            child:
                const Text("Guardar", style: (TextStyle(color: Colors.blue))),
            onPressed: () {
              convertCanvasToB64();
              if (kIsWeb) {
              // paintProviderVisibility.changeView(nuevoShowDialog);
              }
            },
          ),
          FlatButton(
            child:
                const Text("Limpir Dibujo", style: (TextStyle(color: Colors.blue))),
            onPressed: () {
              LimpiarDrawer();
            },
          ),

      ],
    );
  }


  
  Future<ui.Image> get rendered {
    var size = context.size;
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(_points);
    painter.paint(canvas, size);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  Future<String> convertCanvasToB64() async {
    final img = await rendered;
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final imgBase64 = base64.encode(pngBytes.buffer.asUint8List());
    String base64Image = "data:image/png;base64," + imgBase64;
    String html3 = "<img src=\"${base64Image}\" style=\" width:25% \" </img>";

    if (kIsWeb) {
     
      widget.controller.insertHtml(html3);
      print("se hizo");
    }else{
    widget.controller.insertHtml(html3);
    }

    

    
    print(html3);

    return imgBase64;
  }

  void LimpiarDrawer() {
    List<Offset> _pointse = <Offset>[];
    setState(() {
     _points = _pointse;
    });


  }
}