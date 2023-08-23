import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/saves_db.dart';
import '../model/info_model.dart';
import '../model/saves_model.dart';

class InfoDetailPage extends StatefulWidget {
  final int noteId;
  final String clasImg;

  const InfoDetailPage({
    Key? key,
    required this.noteId,
    required this.clasImg,
  }) : super(key: key);

  @override
  _InfoDetailPageState createState() => _InfoDetailPageState();
}

class _InfoDetailPageState extends State<InfoDetailPage> {
  late Save note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await SavesDatabase.instance.readSave(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    int index = int.parse(note.clas.toString().substring(0, 2));
    return Scaffold(
      appBar: AppBar(
        actions: [deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 8),
                  Center(child: Image.file(File(note.path))),
                  SizedBox(height: 8),
                  Text(
                    namesUA[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextForSaves("Короткиий опис", infos[index].description),
                  TextForSaves("Інфекція", infos[index].infection),
                  TextForSaves("Сиптоми", infos[index].symptoms),
                  TextForSaves("Запобігання захворювання", infos[index].prevention),
                ],
              ),
            ),
    );
  }

  Widget TextForSaves(String section, String text) => Column(
    children: [
      SizedBox(height: 12),
      Text(
        section,
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
      Text(
        text,
        style: TextStyle(color: Colors.white70, fontSize: 18),
      )
    ],
  );

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await SavesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
