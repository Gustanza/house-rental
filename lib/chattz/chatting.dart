import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ZogoScreen extends StatefulWidget {
  final String jinaLake;
  final String emailYake;
  const ZogoScreen(
      {super.key, required this.jinaLake, required this.emailYake});

  @override
  State<ZogoScreen> createState() => _ZogoScreenState();
}

class _ZogoScreenState extends State<ZogoScreen> {
  TextEditingController kichatisho = TextEditingController();
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
  String? ohYeah;
  @override
  void initState() {
    initThatWaits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(widget.jinaLake),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ohYeah == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('zogo')
                            .doc(ohYeah)
                            .collection('jumbe')
                            .orderBy('muda', descending: true)
                            .snapshots(),
                        builder: (context, madini) {
                          if (madini.hasData) {
                            if ((madini.data as dynamic).docs.isEmpty) {
                              return const Center(
                                child: Text('Sema Hi'),
                              );
                            } else {
                              return HapaKati(
                                jumbe: (madini.data as dynamic).docs,
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )),
            TextField(
              controller: kichatisho,
              maxLines: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'Ujumbe',
                  suffixIcon: IconButton(
                      onPressed: () async {
                        if (kichatisho.text.isNotEmpty) {
                          if (ohYeah == 'no-shit') {
                            try {
                              //ongeza wahusika
                              var uhusika = await FirebaseFirestore.instance
                                  .collection('zogo')
                                  .add({
                                'wahusika': [mimi, widget.emailYake]
                              });
                              //weka ujumbe
                              await uhusika.collection('jumbe').add({
                                'ujumbe': kichatisho.text,
                                'mtumaji': jinaLangu,
                                'mpokeaji': widget.jinaLake,
                                'muda': DateTime.now()
                              });
                              kichatisho.clear();
                              initThatWaits();
                            } catch (shida) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(shida.toString())));
                            }
                          } else {
                            try {
                              FirebaseFirestore.instance
                                  .collection('zogo')
                                  .doc(ohYeah)
                                  .collection('jumbe')
                                  .add({
                                'ujumbe': kichatisho.text,
                                'mtumaji': jinaLangu,
                                'mpokeaji': widget.jinaLake,
                                'muda': DateTime.now()
                              });
                              kichatisho.clear();
                            } catch (shida) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(shida.toString())));
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.send))),
            )
          ],
        ),
      ),
    );
  }

  initThatWaits() async {
    var themchats = await FirebaseFirestore.instance
        .collection('zogo')
        .where('wahusika', arrayContains: mimi)
        .get();

    for (var thischat in themchats.docs) {
      if (thischat['wahusika'].contains(widget.emailYake)) {
        setState(() {
          ohYeah = thischat.id;
        });
        return;
      }
    }
    setState(() {
      ohYeah = 'no-shit';
    });
    return;
  }
}

class HapaKati extends StatelessWidget {
  final jumbe;
  const HapaKati({super.key, required this.jumbe});

  @override
  Widget build(BuildContext context) {
    String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
    return ListView.builder(
      itemCount: jumbe.length,
      reverse: true,
      itemBuilder: (context, hii) {
        return Row(
          mainAxisAlignment: jumbe[hii]['mtumaji'] == jinaLangu
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              constraints: const BoxConstraints(
                  minHeight: kBottomNavigationBarHeight,
                  minWidth: kBottomNavigationBarHeight,
                  maxWidth: 250),
              decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                jumbe[hii]['ujumbe'],
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        );
      },
    );
  }
}

class ChatZote extends StatefulWidget {
  const ChatZote({super.key});

  @override
  State<ChatZote> createState() => _ChatZoteState();
}

class _ChatZoteState extends State<ChatZote> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Mawasilano'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('zogo')
            .where('wahusika', arrayContains: mimi)
            .snapshots(),
        builder: (context, madini) {
          if (madini.hasData) {
            if ((madini.data as dynamic).docs.isEmpty) {
              return const Center(
                child: Text('Huna Chats'),
              );
            }
            return ListView.builder(
                padding: const EdgeInsets.only(top: 2),
                itemCount: (madini.data as dynamic).docs.length,
                itemBuilder: (context, index) {
                  for (var mhusika in (madini.data as dynamic).docs[index]
                      ['wahusika']) {
                    if (mhusika != mimi) {
                      return OneAvDem(
                        emailYake: mhusika,
                        id: (madini.data as dynamic).docs[index].id,
                      );
                    }
                  }
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class OneAvDem extends StatelessWidget {
  final String id;
  final String emailYake;
  const OneAvDem({super.key, required this.id, required this.emailYake});

  @override
  Widget build(BuildContext context) {
    String? jinaLangu = FirebaseAuth.instance.currentUser?.displayName;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('zogo')
          .doc(id)
          .collection('jumbe')
          .orderBy('muda', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: ListTile(
              tileColor: Colors.green[200],
              contentPadding: const EdgeInsets.only(left: 16),
              title: (snapshot.data as dynamic).docs[0]['mtumaji'] == jinaLangu
                  ? Text((snapshot.data as dynamic).docs[0]['mpokeaji'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'sofont'),
                      overflow: TextOverflow.ellipsis)
                  : Text((snapshot.data as dynamic).docs[0]['mtumaji'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'sofont'),
                      overflow: TextOverflow.ellipsis),
              subtitle: Text((snapshot.data as dynamic).docs[0]['ujumbe'],
                  overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.clear_all,
                    color: Colors.black54,
                  )),
              onTap: () {
                if ((snapshot.data as dynamic).docs[0]['mtumaji'] !=
                    jinaLangu) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ZogoScreen(
                          jinaLake: (snapshot.data as dynamic).docs[0]
                              ['mtumaji'],
                          emailYake: emailYake)));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ZogoScreen(
                          jinaLake: (snapshot.data as dynamic).docs[0]
                              ['mpokeaji'],
                          emailYake: emailYake)));
                }
              },
            ),
          );
        }
        return const ListTile(
          title: CircularProgressIndicator(),
        );
      },
    );
  }
}
