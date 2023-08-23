import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_recognition/page/glossary_page.dart';
import 'package:plant_recognition/page/identification_page.dart';
import 'package:plant_recognition/page/saves_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(_TabsNonScrollableDemo());
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(1);

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  static final String title = 'Plant Recognition';

  @override
  Widget build(BuildContext context) {
    const tabs = [
      Tab(icon: Icon(Icons.bookmark)),
      Tab(icon: Icon(Icons.document_scanner)),
      Tab(icon: Icon(Icons.book)),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
            headlineMedium: TextStyle(color: Colors.white),
            headlineSmall: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text("PlantDiseasI"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              for (final tab in tabs) tab,
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SavesPage(),
            IdentiPage(),
            GlossaryPage(),
          ],
        ),
      ),
    );
  }
}

