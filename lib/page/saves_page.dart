import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_recognition/model/info_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../db/saves_db.dart';
import '../model/saves_model.dart';
import 'info_detail_page.dart';

class SavesPage extends StatefulWidget {
  @override
  _SavesPageState createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  late List<Save> notes;
  late List<Info> infos;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
    refreshInfo();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await SavesDatabase.instance.readAllSaves();

    setState(() => isLoading = false);
  }

  Future refreshInfo() async {

    this.infos = await SavesDatabase.instance.readAllInfo();

  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
              ? Text(
            'No Saves',
            style: TextStyle(color: Colors.white, fontSize: 24),
          )
              : buildNotes(),
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes!.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InfoDetailPage(noteId: note.id!, clasImg: note.clas,),
              ));

              refreshNotes();
            },
            child: SaveCardWidget(
                note: note, index: index), // створює дизайн сейвів
          );
        },
      );
}

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class SaveCardWidget extends StatelessWidget {
  SaveCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Save note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: 150),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              note.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.file(File(note.path)),
          ],
        ),
      ),
    );
  }
}

class SaveFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? clas;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedClas;

  const SaveFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.clas = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedClas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        readOnly: true,
        maxLines: 5,
        initialValue: clas,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedClas,
      );
}
