import 'package:chaurental/akaunti_stuff/akaunti_page.dart';
import 'package:chaurental/chattz/chatting.dart';
import 'package:chaurental/issuezausajili/usajili.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'destinations/nyumbani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Kulogin(),
      ));
    } else {
      runApp(const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Hoster(),
      ));
    }
  });
}

class Hoster extends StatefulWidget {
  const Hoster({super.key});

  @override
  State<Hoster> createState() => _HosterState();
}

class _HosterState extends State<Hoster> {
  List<Widget> destinationTop = const [Nyumbani(), ChatZote(), Akauntee()];
  final pagecontroller = PageController(initialPage: 0);
  int indexCurrent = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: indexCurrent,
          onTap: (hiiapahii) {
            setState(() {
              indexCurrent = hiiapahii;
            });
            pagecontroller.jumpToPage(indexCurrent);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'nyumbani',
                backgroundColor: Colors.yellow),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'mawasiliano',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'akaunti',
                backgroundColor: Colors.blue)
          ]),
      body: SafeArea(
          child: PageView(
        controller: pagecontroller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [Nyumbani(), ChatZote(), Akauntee()],
      )),
    );
  }
}
