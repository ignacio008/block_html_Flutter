import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:z06_blocks_notess/painter.dart';

import 'dart:ui' as ui;

import 'package:z06_blocks_notess/provider/paint_provider.dart';

class PaintDesign extends StatefulWidget {
  HtmlEditorController controller = HtmlEditorController();
  Function changeView;
  PaintDesign(this.controller, this.changeView);

  @override
  State<PaintDesign> createState() => _PaintDesignState();
}

class _PaintDesignState extends State<PaintDesign> {
  bool nuevoShowDialog = false;
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    PaintProvider paintProviderVisibility =
        Provider.of<PaintProvider>(context, listen: true);
    return AlertDialog(
      
      
        contentPadding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        title: const Text("Dibujar"),
        content: Container(
          width: MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height ,
          color: Colors.red,
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
        actions: <Widget>[
          FlatButton(
            child:
                const Text("Cancelar", style: (TextStyle(color: Colors.blue))),
            onPressed: () {
              Navigator.pop(context);

              if (kIsWeb) {
                paintProviderVisibility.changeView(nuevoShowDialog);
              }
            },
          ),
          FlatButton(
            child:
                const Text("Guardar", style: (TextStyle(color: Colors.blue))),
            onPressed: () {
              convertCanvasToB64();
              if (kIsWeb) {
               
              }
            },
          ),
        ]);
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
    Navigator.pop(context);

    return imgBase64;
  }
}
