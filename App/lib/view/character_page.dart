import 'package:flutter/material.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => CharacterPageState();
}

class CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("育成ページ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
    );
  }


  //タブを選択した時に行う再描画処理
  void reload() {

  }
}