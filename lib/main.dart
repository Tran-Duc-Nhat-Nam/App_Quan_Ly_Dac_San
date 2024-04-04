import 'dart:developer';

import 'package:app_dac_san/core/router/router_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

bool isDark = false;
String adminUID = "CvIh7wkVBzX0GE5EXPtevZeujoJ3";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // try {
  //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //     email: "admindacsan@gmail.com",
  //     password: "tranducnhatnam27",
  //   );
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'weak-password') {
  //     log('The password provided is too weak.');
  //   } else if (e.code == 'email-already-in-use') {
  //     log('The account already exists for that email.');
  //   }
  // } catch (e) {
  //   log(e.toString());
  // }

  // Admin UID = CvIh7wkVBzX0GE5EXPtevZeujoJ3

  runApp(ChangeNotifierProvider(
      create: (context) => DarkMode(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkMode>(context);
    return MaterialApp.router(
      title: 'Trang web quản lý dữ liệu Vina Food',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.dark),
          useMaterial3: true,
          brightness: Brightness.dark),
      // home: MyHomePage(changeTheme: changeTheme),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode.darkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.page});

  final Widget page;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkMode>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Trang quản lý dữ liệu"),
        actions: [
          Switch(
              value: themeMode.darkMode,
              onChanged: themeMode.changeMode,
              thumbIcon: const MaterialStatePropertyAll(Icon(Icons.dark_mode))),
        ],
      ),
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary),
            width: 90,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      sideBarItem("/dacsan", "Đặc sản",
                          Icons.food_bank_outlined, Icons.food_bank),
                      sideBarItem("/noiban", "Nơi bán", Icons.home_outlined,
                          Icons.home),
                      sideBarItem("/nguoidung", "Người dùng",
                          Icons.account_box_outlined, Icons.account_box),
                      sideBarItem("/tinhthanh", "Tỉnh thành",
                          Icons.map_outlined, Icons.map),
                      sideBarItem("/nguyenlieu", "Nguyên liệu",
                          Icons.science_outlined, Icons.science),
                      sideBarItem("/vungmien", "Vùng miền",
                          Icons.place_outlined, Icons.place),
                      sideBarItem("/muadacsan", "Mùa", Icons.ac_unit_outlined,
                          Icons.ac_unit),
                      sideBarItem("/thongke", "Thống kê",
                          Icons.bar_chart_outlined, Icons.bar_chart),
                    ],
                  ),
                )
              ],
            ),
          ),
          Flexible(flex: 1, child: widget.page),
        ],
      ),
    );
  }

  Column sideBarItem(
      String url, String name, IconData icon, IconData selectedIcon) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              context.go(url);
            });
          },
          isSelected: GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString() ==
              url,
          icon: Icon(
            icon,
            color: Theme.of(context).colorScheme.inverseSurface,
            size: 32,
          ),
          selectedIcon: Icon(
            selectedIcon,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
        ),
        Text(
          name,
          style: TextStyle(
              color: GoRouter.of(context)
                          .routeInformationProvider
                          .value
                          .uri
                          .toString() ==
                      url
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inverseSurface,
              fontWeight: FontWeight.w800),
        )
      ],
    );
  }
}

class DarkMode with ChangeNotifier {
  bool darkMode = true;

  ///by default it is true
  ///made a method which will execute while switching
  void changeMode(bool toogle) {
    darkMode = !darkMode;
    log(darkMode.toString());
    notifyListeners();

    ///notify the value or update the widget value
  }
}
