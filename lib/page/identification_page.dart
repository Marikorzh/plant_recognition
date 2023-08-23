import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_recognition/page/possible_save_page.dart';
import 'package:tflite/tflite.dart';
import 'package:plant_recognition/model/info_model.dart';

class IdentiPage extends StatefulWidget {
  const IdentiPage({Key? key}) : super(key: key);

  @override
  State<IdentiPage> createState() => _IdentiPageState();
}

class _IdentiPageState extends State<IdentiPage> {
  String path = '';
  String result = "";
  String label = "Хвороба Рослини";
  String label2 = "Хвороба Рослини";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //головний заголовок
            Text(label, style: textTheme.headlineSmall!),
            SizedBox(
              height: 20,
            ),
            //перевірка чи зроблено фото для ідентифікації
            path == ''
                ? Image.asset("assets/img/image_placeholder.png", height: 200, width: 200, fit: BoxFit.fill,)
                : GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddEditSavePage(path: path, name: label2,)),
                );
              },
              child: Image.file(File(path), height: 200, width: 200, fit: BoxFit.cover,),
            ),
            Text('Обрати зображення', style: textTheme.headlineSmall),
            SizedBox(height: 20.0),
            //створення кнопки для вибору фото
            ElevatedButton(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 14, color: Colors.white))),
                onPressed: () async {
                  selectImage();
                  setState(() {});
                },
                child: const Text('Обрати зображення')),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final textTheme = Theme.of(context).textTheme;
          // створення поп-ап віконця для вибору способу завантаження фото
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              // створення області за межі якої текст та картинки не здатні вийти
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'Обрати зображення: ',
                      style: textTheme.titleLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buttonWidget("camera"),
                        buttonWidget("gallery"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buttonWidget(String name) {
    String img = (name == "camera") ? "assets/img/camera.png" : "assets/img/gallery.png";
    return GestureDetector(
      onTap: () async {
        path = await selectImageFrom(name == "camera");
        print('Image_Path:-$path');

        if (path != '') {
          Navigator.pop(context);
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No Image Captured !"),
          ));
        }
      },
      child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset(img, height: 60, width: 60),
              ],
            ),
          )),
    );
  }

  selectImageFrom(bool cameraOrGallery) async {
    ImageSource imageSource =
        (cameraOrGallery == true ? ImageSource.camera : ImageSource.gallery);
    XFile? file =
        await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
    if (file != null) {
      setState(() {
        path = file.path;
      });
      if(!cameraOrGallery)classifyImage();
      else{label = "Не хвороба";}
      return file.path;
    } else {
      return '';
    }
  }

  classifyImage() async {
    await Tflite.loadModel(
        model: "assets/model/model.tflite", labels: "assets/model/labels.txt");
    var output = await Tflite.runModelOnImage(path: path, numResults: 3,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,);

    setState(() {
      if(output != null) {
        if(double.parse("${output[0]["confidence"].toString()}") <= 0.8){
           label = "Не хвороба";
         }
        else {
          result = output[0]["label"].toString().substring(0, 2);
          label = namesUA[int.parse(result)];
          label = (output[0]["confidence"] == 1.0) ? label += " 100" : label += " ${output[0]["confidence"].toString().substring(0, 4)}";
          label2 = "${output[0]["label"]}";
        }

      }
    });
  }
}
