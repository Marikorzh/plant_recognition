import 'dart:io';

import 'package:flutter/material.dart';

import '../db/saves_db.dart';
import '../model/info_model.dart';
import '../model/saves_model.dart';

class AddEditSavePage extends StatefulWidget {
  final Save? note;
  final String path;
  final String name;

  const AddEditSavePage({
    Key? key,
    this.note,
    required this.path,
    required this.name,
  }) : super(key: key);
  @override
  _AddEditSavePageState createState() => _AddEditSavePageState();
}

class _AddEditSavePageState extends State<AddEditSavePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late String clasImg;
  late String clasInfo;
  late String title;
  late String path;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    clasImg = widget.note?.clas ?? widget.name;
    title = widget.note?.title ?? '';
    path = widget.note?.path ?? widget.path;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: SaveFormWidget(
        isImportant: isImportant,
        clas: clasImg,
        title: title,
        path: path,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedClas: (clas) => setState(() => this.clasImg = clas),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedPath: (path) =>
            setState(() => this.path = path),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && path.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Зберегти'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      clas: clasImg,
      title: title,
      path: path,
    );

    await SavesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Save(
      title: title,
      isImportant: true,
      clas: clasImg,
      path: path,
      createdTime: DateTime.now(),
    );

    await SavesDatabase.instance.create(note);
  }
}

class SaveFormWidget extends StatelessWidget {
  final bool? isImportant;
  final String? clas;
  final String? title;
  final String? path;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<String> onChangedClas;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedPath;

  const SaveFormWidget({
    Key? key,
    this.isImportant = false,
    this.clas = '',
    this.title = '',
    this.path = '',
    required this.onChangedImportant,
    required this.onChangedClas,
    required this.onChangedTitle,
    required this.onChangedPath,
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
          buildInfo(),
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
      hintText: 'Введіть назву',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'Назва не може бути порожньою' : null,
    onChanged: onChangedTitle,
  );

  Widget buildInfo() {
    int index = int.parse(clas!.substring(0,2));
    return Column(
      children: [
        Text(
          namesUA[index],
          style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Center(child: path?.substring(0,1) == 'a' ? Image.asset(path!) : Image.file(File(path!))),
        SizedBox(height: 8),
        TextForSaves("Короткиий опис", infos[index].description),
        TextForSaves("Інфекція", infos[index].infection),
        TextForSaves("Сиптоми", infos[index].symptoms),
        TextForSaves("Запобігання захворювання", infos[index].prevention),
      ],
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
}

