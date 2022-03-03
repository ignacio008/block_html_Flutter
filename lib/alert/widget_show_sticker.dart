import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:z06_blocks_notess/model/model_sticker.dart';


class WidgetShowSticker extends StatefulWidget {
  ModelSticker iconmodellist;
  HtmlEditorController controller = HtmlEditorController();
  WidgetShowSticker(this.iconmodellist, this.controller);

  @override
  State<WidgetShowSticker> createState() => _WidgetShowStickerState();
}

class _WidgetShowStickerState extends State<WidgetShowSticker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        subirSticker(context);
      },
      child: Container(
        width:kIsWeb? MediaQuery.of(context).size.width* 0.1:MediaQuery.of(context).size.width* 0.20 ,
        height:kIsWeb?MediaQuery.of(context).size.height*0.18:MediaQuery.of(context).size.height*0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:Colors.white,
        ),
          child:ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),      
                  child: Image.network(widget.iconmodellist.imageSticker==null?"https://ep01.epimg.net/elpais/imagenes/2019/10/30/album/1572424649_614672_1572453030_noticia_normal.jpg":widget.iconmodellist.imageSticker,fit: BoxFit.cover,
    
                    loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
                     if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: Container(
                width:MediaQuery.of(context).size.width*0.65,
                height:MediaQuery.of(context).size.height*0.3,
                 decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),               
              ),
                child: Transform.scale(
                  scale:0.7,
                  child: CircularProgressIndicator(
                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                     strokeWidth:6.0,
                  ),
                ),
              ),
            );
                  },
                        )),
      ),
    );
  }

  void subirSticker(BuildContext context) {
       String html1 =  "<img src=\"${widget.iconmodellist.imageSticker}\" style=\" width:12% \" </img>";
      String html2 =  "<img src=\"${widget.iconmodellist.imageSticker}\" style=\" width:25% \" </img>";
      kIsWeb?
      widget.controller.insertHtml(html1):
      widget.controller.insertHtml(html2);
       Navigator.pop(context);
  }
}