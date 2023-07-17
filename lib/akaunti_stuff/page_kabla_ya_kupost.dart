import 'dart:io';
import 'dart:typed_data';
import 'package:chaurental/shared/rejea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:uuid/uuid.dart';

class PageKablaYaPostn extends StatefulWidget {
  const PageKablaYaPostn({super.key});

  @override
  State<PageKablaYaPostn> createState() => _PageKablaYaPostnState();
}

class _PageKablaYaPostnState extends State<PageKablaYaPostn> {
  final yuzor = FirebaseAuth.instance.currentUser?.displayName;
  final yemail = FirebaseAuth.instance.currentUser?.email;
  final softOBJ = FirebaseMessaging.instance;
  TextEditingController sizeCon = TextEditingController();
  TextEditingController wilayaCon = TextEditingController();
  TextEditingController rumCon = TextEditingController();
  TextEditingController beiCon = TextEditingController();
  TextEditingController mtaaCon = TextEditingController();
  List<Uint8List> pichaZaMaonyesho = [];
  String ainaYaPango = ainaPangor;
  String mkoa = mkoar;
  String hali = haly;
  String hintmadirisha = madirisha;
  String hintMilango = ainaYaMilango;
  String hintPaa = ainaYaMabati;
  String hintChoo = ainaYaVyoo;
  String umri = 'three';
  List<CroppedFile?> mapichapicha = [null, null, null, null, null, null];
  List<String?> mapichapichaURL = [null, null, null, null, null, null];
  bool napandisha = false;
  bool parking = false;
  bool maji = false;
  bool umeme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor: Colors.green,
            title: const Text('Posti Tangazo')),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            const SizedBox(height: 24),
            const Icon(
              size: 50,
              color: Colors.green,
              Icons.check_circle,
            ),
            ainaYaPangoDropy(ainaZaPangow),
            const Text(
              'Chagua Picha',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'Chagua picha 6 zenye mvuto ili kusaidia tangazo lako kuonekana kwa urahisi',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 6,
            ),
            wekaPicha(),
            const SizedBox(
              height: 8,
            ),
            mkoaDropy(mikoa),
            softInput(wilayaCon, TextInputType.name, 'Wilaya au Manispaa'),
            softInput(mtaaCon, TextInputType.name, 'Mtaa au Kata'),
            softInput(sizeCon, TextInputType.number,
                'Saizi ya Eneo katika Mita za Mraba'),
            haliDropy(haliZotee),
            softInput(rumCon, TextInputType.number, 'Idadi ya Vyumba'),
            softInput(beiCon, TextInputType.number, 'Gharama'),
            madirishaDropy(ainaYaMadirisha),
            milangoDropy(doorCategories),
            paaDropy(roofCategories),
            chooDropy(toiletCategories),
            CheckboxListTile(
                title: const Text(
                  'Mahala Pa Kupaki Gari',
                  style: TextStyle(color: Colors.black54),
                ),
                value: parking,
                onChanged: (whatnow) {
                  setState(() {
                    parking = whatnow!;
                  });
                }),
            CheckboxListTile(
                title: const Text(
                  'Huduma ya Maji',
                  style: TextStyle(color: Colors.black54),
                ),
                value: maji,
                onChanged: (whatnow) {
                  setState(() {
                    maji = whatnow!;
                  });
                }),
            CheckboxListTile(
                title: const Text(
                  'Huduma ya Umeme',
                  style: TextStyle(color: Colors.black54),
                ),
                value: umeme,
                onChanged: (whatnow) {
                  setState(() {
                    umeme = whatnow!;
                  });
                }),
            const SizedBox(
              height: 18,
            ),
            softSubmit(),
            const SizedBox(
              height: 18,
            ),
          ],
        ));
  }

  softInput(
      TextEditingController softcon, TextInputType nini, String softhint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: softcon,
        maxLines: null,
        keyboardType: nini,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: softhint),
      ),
    );
  }

  mjumbe(String ujumbe) {
    final snackbar = SnackBar(content: Text(ujumbe));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  wekaPicha() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () async {
                  await softPhotoCap(index);
                },
                child: Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.green)),
                    child: mapichapichaURL[index] == null
                        ? const Icon(Icons.add)
                        : Image.file(
                            File(mapichapicha[index]!.path),
                            fit: BoxFit.cover,
                          )),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () async {
                  await softPhotoCap(index + 3);
                },
                child: Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.green)),
                    child: mapichapichaURL[index + 3] == null
                        ? const Icon(Icons.add)
                        : Image.file(
                            File(mapichapicha[index + 3]!.path),
                            fit: BoxFit.cover,
                          )),
              );
            }),
          ),
        ],
      ),
    );
  }

  softPhotoCap(int yangapi) async {
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
              toolbarTitle: 'Hariri Picha',
              toolbarColor: Colors.green,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Hariri Picha',
          )
        ],
      );
      if (croppedFile != null) {
        // ku indicate kwamba na upload picha
        SimpleFontelicoProgressDialog subiri =
            SimpleFontelicoProgressDialog(context: context);
        subiri.show(
            message: 'Subiri...',
            type: SimpleFontelicoProgressDialogType.threelines);
        // inaishia hapa
        mapichapichaURL[yangapi] = await anayeUploadPicha(croppedFile);
        subiri.hide();
        if (mapichapichaURL[yangapi] != null) {
          setState(() {
            mapichapicha[yangapi] = croppedFile;
          });
        }
      }
    }
  }

  ainaYaPangoDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(ainaYaPango),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          ainaYaPango = iliyoguzwa!;
        });
      },
    );
  }

  mkoaDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(mkoa),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          mkoa = iliyoguzwa!;
        });
      },
    );
  }

  haliDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(hali),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          hali = iliyoguzwa!;
        });
      },
    );
  }

  madirishaDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(hintmadirisha),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          hintmadirisha = iliyoguzwa!;
        });
      },
    );
  }

  milangoDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(hintMilango),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          hintMilango = iliyoguzwa!;
        });
      },
    );
  }

  paaDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(hintPaa),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          hintPaa = iliyoguzwa!;
        });
      },
    );
  }

  chooDropy(List<String> vitoto) {
    return DropdownButton(
      elevation: 30,
      hint: Text(hintChoo),
      dropdownColor: Colors.green[200],
      items: List.generate(
          vitoto.length,
          (index) => DropdownMenuItem(
              value: vitoto[index], child: Text(vitoto[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          hintChoo = iliyoguzwa!;
        });
      },
    );
  }

  //button ya ku submit
  softSubmit() {
    return GestureDetector(
      onTap: () async {
        if (checker()) {
          await operationYaKuSubmit();
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.green, borderRadius: BorderRadius.circular(10)),
        child: napandisha
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'wasilishaPost',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }

  checker() {
    if (ainaYaPango == ainaPangor) {
      mjumbe('Tufahamishe Kategoria Nyumba Yako');
      return false;
    }
    if (mapichapichaURL[0] == null ||
        mapichapichaURL[1] == null ||
        mapichapichaURL[2] == null ||
        mapichapichaURL[3] == null ||
        mapichapichaURL[4] == null ||
        mapichapichaURL[5] == null) {
      mjumbe('Tufadhali Chagua Picha Angalau 6');
      return false;
    }
    if (mkoa == mkoar) {
      mjumbe('Tufahamishe Mkoa');
      return false;
    }
    if (wilayaCon.text.isEmpty) {
      mjumbe('Tufahamishe Wilaya');
      return false;
    }
    if (mtaaCon.text.isEmpty) {
      mjumbe('Tufahamishe Mtaa');
      return false;
    }
    if (sizeCon.text.isEmpty) {
      mjumbe('Tufahamishe Saizi Ya Eneo');
      return false;
    }
    if (hali == haly) {
      mjumbe('Tufahamishe Hali');
      return false;
    }
    if (rumCon.text.isEmpty) {
      mjumbe('Tufahamishe Idadi Ya Vyumba Vya Kulala');
      return false;
    }
    if (beiCon.text.isEmpty) {
      mjumbe('Tufahamishe Idadi Ya Bafu');
      return false;
    }
    if (hintmadirisha == madirisha) {
      mjumbe('Chagua aina ya madirisha');
      return false;
    }
    if (hintMilango == ainaYaMilango) {
      mjumbe('Chagua aina ya milango');
      return false;
    }
    if (hintPaa == ainaYaMabati) {
      mjumbe('Chagua aina ya paa');
      return false;
    }
    if (hintChoo == ainaYaVyoo) {
      mjumbe('Chagua aina ya choo');
      return false;
    }
    return true;
  }

  operationYaKuSubmit() async {
    String sahivi = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    setState(() {
      napandisha = true;
    });
    try {
      await FirebaseFirestore.instance.collection(matangazoC).add({
        ainaPangor: ainaYaPango,
        pichaT: mapichapichaURL,
        mkoaT: mkoa,
        wilayaT: wilayaCon.text,
        mtaaT: mtaaCon.text,
        sizeT: sizeCon.text,
        haliT: hali,
        rumnumT: rumCon.text,
        gharamaT: beiCon.text,
        parkingT: parking,
        majiT: maji,
        mudaT: sahivi,
        umemeT: umeme,
        viewsT: [],
        likesT: [],
        ownerT: yemail,
        'madirisha': hintmadirisha,
        'milango': hintMilango,
        'paa': hintPaa,
        'choo': hintChoo
      }).then((value) {
        setState(() {
          napandisha = false;
        });
        rudi();
      });
    } catch (shida) {
      setState(() {
        napandisha = false;
      });
      print(shida);
    }
  }

  Future<String?> anayeUploadPicha(CroppedFile picha) async {
    String? url;
    try {
      var idYaPicha = const Uuid().v1();
      await FirebaseStorage.instance
          .ref()
          .child('postZote/$idYaPicha')
          .putFile(File(picha.path))
          .then((snapshot) async {
        url = await snapshot.ref.getDownloadURL();
        return url;
      });
    } catch (shida) {
      print('oyaaaaaaa: $shida');
    }
    return url;
  }

  rudi() {
    mjumbe('Hongera, bidhaa imewekwa sokoni kikamilifu');
    Navigator.of(context).pop();
  }
}
