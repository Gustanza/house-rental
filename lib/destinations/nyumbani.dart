import 'package:carousel_slider/carousel_slider.dart';
import 'package:chaurental/chattz/chatting.dart';
import 'package:chaurental/shared/mchanganyiko.dart';
import 'package:chaurental/shared/rejea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'kusearch.dart';

class Nyumbani extends StatefulWidget {
  const Nyumbani({super.key});

  @override
  State<Nyumbani> createState() => _NyumbaniState();
}

class _NyumbaniState extends State<Nyumbani> {
  TextEditingController searchCon = TextEditingController();
  final yemail = FirebaseAuth.instance.currentUser?.email;
  List<String> filterChaguzi = [
    kategoriaZote,
    mikoaAll,
    halizote,
    vyumba,
    madirisha,
    ainaYaMilango,
    ainaYaMabati,
    ainaYaVyoo
  ];
  TextEditingController gharamaLowCon = TextEditingController();
  TextEditingController gharamaHighCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Mtafutaji()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.search),
      ),
      body: Column(children: [
        Container(
          color: Colors.green,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      jinaLaApp,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () async {
                          FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      if (index < 8) {
                        return Container(
                          height: 20,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton(
                            iconEnabledColor: Colors.white,
                            alignment: Alignment.center,
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(20),
                            hint: Text(
                              filterChaguzi[index],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            dropdownColor: Colors.green[100],
                            items: List.generate(
                                opshenDipu[index].length,
                                (indexjr) => DropdownMenuItem(
                                    value: opshenDipu[index][indexjr],
                                    child: Text(
                                      opshenDipu[index][indexjr],
                                    ))),
                            onChanged: (iliyoguzwa) {
                              setState(() {
                                filterChaguzi[index] = iliyoguzwa!;
                              });
                            },
                          ),
                        );
                      } else {
                        return Container(
                          height: 20,
                          width: 250,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Text(
                                'Bei',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: TextField(
                                controller: gharamaLowCon,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.search,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                              const Text(
                                'hadi',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: TextField(
                                controller: gharamaHighCon,
                                cursorColor: Colors.white,
                                onEditingComplete: () {
                                  setState(() {});
                                  FocusScope.of(context).unfocus();
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.search,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection(matangazoC).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data as dynamic).docs.isEmpty) {
                return const Center(child: Text('Hakuna Tangazo'));
              }
              var dataZakuFix = (snapshot.data as dynamic).docs;
              dataZakuFix = anayeApplyFilter(dataZakuFix);
              return Expanded(
                child: dataZakuFix.length != 0
                    ? ListView.builder(
                        itemCount: dataZakuFix.length,
                        itemBuilder: (context, index) {
                          return RamaniYaTangazo(
                              data: dataZakuFix[index], emailYangu: yemail!);
                        })
                    : const Center(
                        child: Text('Hakuna tangazo lenye vigezo hivyo')),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
      ]),
    );
  }

  anayeApplyFilter(var dataZakuFix) {
    var dataFixed = [];
    for (var datamoja in dataZakuFix) {
      dataFixed.add(datamoja);
    }

    if (filterChaguzi[0] != opshenDipu[0][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja[ainaPangor] != filterChaguzi[0]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (filterChaguzi[1] != opshenDipu[1][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja[mkoaT] != filterChaguzi[1]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (filterChaguzi[2] != opshenDipu[2][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja[haliT] != filterChaguzi[2]) {
          dataFixed.remove(datamoja);
        }
      }
    }

    if (filterChaguzi[3] != opshenDipu[3][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja[rumnumT] != filterChaguzi[3]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (filterChaguzi[4] != opshenDipu[4][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja[madirishaT] != filterChaguzi[4]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (filterChaguzi[5] != opshenDipu[5][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja['milango'] != filterChaguzi[5]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (filterChaguzi[6] != opshenDipu[6][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja['paa'] != filterChaguzi[6]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (filterChaguzi[7] != opshenDipu[7][0]) {
      for (var datamoja in dataZakuFix) {
        if (datamoja['choo'] != filterChaguzi[7]) {
          dataFixed.remove(datamoja);
        }
      }
    }
    if (gharamaHighCon.text.isNotEmpty && gharamaLowCon.text.isNotEmpty) {
      for (var datamoja in dataZakuFix) {
        if (int.parse(datamoja[gharamaT]) < int.parse(gharamaLowCon.text) ||
            int.parse(datamoja[gharamaT]) > int.parse(gharamaHighCon.text)) {
          dataFixed.remove(datamoja);
        }
      }
    }

    return dataFixed;
  }
}

class RamaniYaTangazo extends StatelessWidget {
  var data;
  String emailYangu;
  RamaniYaTangazo({super.key, required this.data, required this.emailYangu});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 4, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => TangazoDeep(
                          data: data,
                        ))));
              },
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(data[pichaT][0]),
                        fit: BoxFit.cover)),
                alignment: Alignment.topLeft,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.place),
                Text(
                  data[mkoaT],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.house),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    data[ainaPangor],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.bed_outlined),
                const SizedBox(width: 4),
                Text(
                  'Vyumba: ${data[rumnumT]}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: processYaKuLike,
                    icon: data[likesT].contains(emailYangu)
                        ? const Icon(Icons.thumb_up)
                        : const Icon(Icons.thumb_up_alt_outlined)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Maoni(tangazoHili: data.id)));
                    },
                    icon: const Icon(Icons.comment_outlined)),
                IconButton(
                    onPressed: () {
                      if (data[ownerT] != emailYangu) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ZogoScreen(
                                  jinaLake: data[mkoaT],
                                  emailYake: data[ownerT],
                                )));
                      }
                    },
                    icon: data[ownerT] != emailYangu
                        ? const Icon(Icons.send)
                        : const Icon(Icons.check_circle_outline)),
              ],
            )
          ],
        ),
      ),
    );
  }

  processYaKuLike() {
    var refYaLikes =
        FirebaseFirestore.instance.collection(matangazoC).doc(data.id);
    var dataIngine = data[likesT];
    if (data[likesT].contains(emailYangu)) {
      dataIngine.remove(emailYangu);
      refYaLikes.update({likesT: dataIngine});
    } else {
      dataIngine.add(emailYangu);
      refYaLikes.update({likesT: dataIngine});
    }
  }
}

class TangazoDeep extends StatefulWidget {
  final data;
  const TangazoDeep({super.key, required this.data});

  @override
  State<TangazoDeep> createState() => _TangazoDeepState();
}

class _TangazoDeepState extends State<TangazoDeep> {
  String? emailYangu = FirebaseAuth.instance.currentUser?.email;
  @override
  void initState() {
    if (!widget.data[viewsT].contains(emailYangu)) {
      var nowAmIn = widget.data[viewsT];
      nowAmIn.add(emailYangu);
      FirebaseFirestore.instance
          .collection(matangazoC)
          .doc(widget.data.id)
          .update({viewsT: nowAmIn});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text(jinaLaApp),
      ),
      body: ListView(shrinkWrap: true, children: [
        CarouselSlider.builder(
            options: CarouselOptions(
                autoPlay: true, height: 300, viewportFraction: 1),
            itemCount: widget.data[pichaT].length,
            itemBuilder: (context, itemIndex, pageViewIndex) {
              return SizedBox(
                width: double.infinity,
                child: Image.network(
                  widget.data[pichaT][itemIndex],
                  fit: BoxFit.cover,
                ),
              );
            }),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TZS ${widget.data[gharamaT]}',
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sofont'),
              ),
              Text(widget.data[ainaPangor],
                  style: const TextStyle(fontSize: 22, fontFamily: 'sofont')),
              const SizedBox(height: 12),
              const Text(
                'Taarifa zaidi:',
                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mkoa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data[mkoaT],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wilaya',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data[wilayaT],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mtaa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data[mtaaT],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hali',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data[haliT],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ukubwa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.data[sizeT]} m/mraba',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vyumba',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.data[rumnumT],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Umeme',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        activeColor: Colors.green,
                        value: widget.data[umemeT],
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Maji',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        activeColor: Colors.green,
                        value: widget.data[majiT],
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 16,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Paki',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        activeColor: Colors.green,
                        value: widget.data[parkingT],
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: kToolbarHeight,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green),
                child: TextButton(
                  onPressed: () {
                    if (widget.data[ownerT] != emailYangu) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ZogoScreen(
                                jinaLake: widget.data[mkoaT],
                                emailYake: widget.data[ownerT],
                              )));
                    }
                  },
                  child: const Text(
                    'wasiliana nami',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
