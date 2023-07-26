import 'package:flutter/material.dart';
import 'package:fwechat/constant/constant.dart';
import 'package:fwechat/pages/chatPage.dart';
import 'package:fwechat/pages/contactsPage.dart';
import 'package:fwechat/pages/me.dart';
import 'package:fwechat/pages/messagePage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  runApp(const MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}


class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("${Constant.assetsImages}LaunchImage.png"),
            fit: BoxFit.cover
          )
        ),
      )
    );
  }
}

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MessagePage(),
    ContactsPage(),
    MePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        backgroundColor: Colors.white38,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon:  Image.asset('assets/images/icon/tabbar_mainframe_25x23.png', width: 25, height: 23),
            activeIcon: Image.asset('assets/images/icon/tabbar_mainframeHL_25x23.png', width: 25, height: 23),
            label: '微信',
          ),
          BottomNavigationBarItem(
            icon:  Image.asset('assets/images/icon/tabbar_contacts_27x23.png', width: 25, height: 23),
            activeIcon: Image.asset('assets/images/icon/tabbar_contactsHL_27x23.png', width: 25, height: 23),
            label: '通讯录',
          ),
          BottomNavigationBarItem(
            icon:  Image.asset('assets/images/icon/tabbar_me_23x23.png', width: 25, height: 23),
            activeIcon: Image.asset('assets/images/icon/tabbar_meHL_23x23.png', width: 25, height: 23),
            label: '我',
          )
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:  Colors.white24),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/chatPage': (context) => ChatPage()
      },
    );
  }
}
