import 'dart:io';
import 'package:chaurental/akaunti_stuff/page_kabla_ya_kupost.dart';
import 'package:chaurental/akaunti_stuff/uchambuzi.dart';
import 'package:chaurental/shared/rejea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Akauntee extends StatefulWidget {
  const Akauntee({super.key});

  @override
  State<Akauntee> createState() => _AkaunteeState();
}

class _AkaunteeState extends State<Akauntee> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  TextEditingController jinaCon = TextEditingController();
  bool sifanyiKitu = true;
  CroppedFile? croppedFile;
  XFile? softPicked;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: const Text('Akaunti'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(usrCollection)
              .doc(mimi)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      'Taarifa kukuhusu',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data as dynamic).data()[pichaUSR]),
                        ),
                        title: const Text(
                          'Picha',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        trailing: sifanyiKitu
                            ? IconButton(
                                onPressed: setPicha,
                                icon: const Icon(Icons.forward))
                            : const CircularProgressIndicator(
                                color: Colors.green,
                              ),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.account_circle_rounded,
                          size: 35,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).data()[jinaUSR],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: haririJinaLog,
                            icon: const Icon(Icons.forward)),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.place,
                          size: 35,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).data()[lokeshenUSR],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ScreenYaLocation()));
                            },
                            icon: const Icon(Icons.forward)),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          size: 35,
                        ),
                        title: Text(
                          (snapshot.data as dynamic).id,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.green,
                            )),
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Matangazo yako',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Container(
                      height: 60,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle,
                      ),
                      child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const PageKablaYaPostn()));
                          },
                          child: const Text(
                            'tengeneza',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ))),
                  const SizedBox(
                    height: 200,
                    child: MySheet(),
                  )
                ],
              ),
            );
          },
        ));
  }

  setPicha() async {
    final ImagePicker softPicker = ImagePicker();
    var source = ImageSource.gallery;
    var softPicked = await softPicker.pickImage(source: source);
    if (softPicked != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: softPicked.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Badili picha ya profaili',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          sifanyiKitu = false;
        });
        try {
          var idYaPicha = const Uuid().v1();
          var softSRef =
              FirebaseStorage.instance.ref().child("pichaZaProfile/$idYaPicha");

          await softSRef.putFile(File(croppedFile.path));
          String urlYaPicha = await softSRef.getDownloadURL();

          FirebaseFirestore.instance
              .collection(usrCollection)
              .doc(mimi)
              .update({pichaUSR: urlYaPicha});
          setState(() {
            sifanyiKitu = true;
          });
        } catch (shida) {
          setState(() {
            sifanyiKitu = true;
          });
          print('shida iliyopo ni: $shida');
        }
      }
    }
  }

  haririJinaLog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              titlePadding: const EdgeInsets.only(top: 16, bottom: 8, left: 16),
              title: const Text('Hariri Jina'),
              content: TextField(
                controller: jinaCon,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection(usrCollection)
                          .doc(mimi)
                          .update({jinaUSR: jinaCon.text});
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      size: 40,
                      color: Colors.green,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.red,
                    )),
              ],
            ));
  }

  softPhotoCap(bool cameraHuh) async {
    final ImagePicker softPicker = ImagePicker();
    var source = cameraHuh ? ImageSource.camera : ImageSource.gallery;
    softPicked = await softPicker.pickImage(source: source);
  }

  softPhotoCapDone() async {
    if (softPicked != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: softPicked!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: jinaLaApp,
              toolbarColor: Colors.green,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: jinaLaApp,
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        moove();
      }
    }
  }

  moove() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => const PageKablaYaPostn())));
  }
}

class ScreenYaLocation extends StatefulWidget {
  const ScreenYaLocation({super.key});

  @override
  State<ScreenYaLocation> createState() => _ScreenYaLocationState();
}

class _ScreenYaLocationState extends State<ScreenYaLocation> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Chagua Eneo'),
      ),
      body: ListView.builder(
        itemCount: mikoa.length,
        padding: const EdgeInsets.only(left: 4, top: 2, right: 4),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 2.5)),
            child: ListTile(
              onTap: () {
                FirebaseFirestore.instance
                    .collection(usrCollection)
                    .doc(mimi)
                    .update({lokeshenUSR: mikoa[index]});
                Navigator.of(context).pop();
              },
              title: Text(
                mikoa[index],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MySheet extends StatefulWidget {
  const MySheet({super.key});

  @override
  State<MySheet> createState() => _MySheetState();
}

class _MySheetState extends State<MySheet> {
  String? mimi = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(matangazoC)
            .where(ownerT, isEqualTo: mimi)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data as dynamic).docs.isEmpty) {
              return const Center(
                child: Text('Huna matangazo bado'),
              );
            }
            var data = (snapshot.data as dynamic).docs;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Uchambuzi(data: data[index])));
                  },
                  onLongPress: () async {
                    await dialogYaKufuta(data[index].id);
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                        border: Border.all(width: 8, color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(data[index][pichaT][0]),
                            fit: BoxFit.cover)),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        data[index][mtaaT],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<void> dialogYaKufuta(String aidii) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              'Je, unahitaji kufuta hili Tangazo',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection(matangazoC)
                        .doc(aidii)
                        .delete();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ndio', style: TextStyle(fontSize: 16))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Napana', style: TextStyle(fontSize: 16))),
            ],
          );
        });
  }
}
