import 'package:flutter/material.dart';
import 'package:plant_recognition/page/info_detail_page.dart';
import 'package:plant_recognition/page/possible_save_page.dart';

import '../model/saves_model.dart';

class GlossaryPage extends StatelessWidget {
  const GlossaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          notCute("assets/img/pepper.png", "Розділ: Перець", "цей розділ нараховує 1 хворобу", context),
          newCard('Плямистість бактеріальна чорна', "9 pepper bell spot", context, 8),

          notCute("assets/img/potato.png", "Розділ: Картопля", "цей розділ нараховує 2 хвороби", context),
          newCard('Альтернаріоз', "11 potato early blight", context, 9),
          newCard('Фітофтороз', "12 potato late blight", context, 10),

          notCute("assets/img/tomato.png", "Розділ: Томати", "цей розділ нараховує 11 хвороб", context),
          newCard('Плямистість бактеріальна чорна', "1 tomato spot", context, 0),
          newCard('Листова цвіль', "2 tomato leaf mod", context, 1),
          newCard('Септоріоз', "3 tomato septoria", context, 2),
          newCard('Павутинні кліщі', "4 tomato spider", context, 3),
          newCard('Фітофтороз', "5 tomato late blight", context, 4),
          newCard('Альтернаріоз', "6 tomato early blight", context, 5),
          newCard('Мозаїка', "7 tomato mosaic", context, 6),
          newCard('Жовта кучерявість листя', "8 tomato yellow leaf", context, 7),
          newCard('Плямистість', "14 tomato target", context, 11),

        ],
      ),
    );
  }

  Card notCute(String path, String firstLine, String secondLine, BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        //splashColor: Colors.blue.withAlpha(30),
        child: ListTile(
          leading: Image.asset(path),
          title: Text(
            firstLine,
          ),
          subtitle: Text(
            secondLine,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  Widget newCard(String text, String clas, BuildContext context, int list) {
    List<String> paths = [
      "assets/example/1 TomatoBact.Sp.JPG",
      "assets/example/2 TomatoL.Mold.JPG",
      "assets/example/3 Tomato.S_CG.JPG",
      "assets/example/4 TomatoSpM_FL.JPG",
      "assets/example/5 TomatoLate.B.JPG",
      "assets/example/6 TomatoErly.B.JPG",
      "assets/example/7 TomatoVirusMos.JPG",
      "assets/example/8 TomatoYellowL.JPG",
      "assets/example/9 PB_B.Spot.JPG",
      "assets/example/11 PotatoEarly.B.JPG",
      "assets/example/12 PotatoLB.JPG",
      "assets/example/14 TomatoTgS.JPG"];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        color: Colors.blueGrey.shade700,
        margin: EdgeInsets.only(left: 20),
        child: ListTile(
            title: Text(text),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEditSavePage(name: clas, path: paths[list])),
              );
            }),
      ),
    );
  }
}
