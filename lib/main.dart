import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';
import 'package:z06_blocks_notess/home.dart';
import 'package:z06_blocks_notess/provider/paint_provider.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   HtmlEditorController controller = HtmlEditorController();
    PaintProvider paintProvider= PaintProvider();
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<PaintProvider>(create: (_)=>paintProvider)
      ],
      child: MaterialApp(
        title: 'Aplicacion Basica',
        debugShowCheckedModeBanner:false,
        home: home1(),
      ),
    );
  }
}
