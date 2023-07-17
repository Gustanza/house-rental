import 'package:chaurental/shared/rejea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Kulogin extends StatefulWidget {
  const Kulogin({super.key});

  @override
  State<Kulogin> createState() => _KuloginState();
}

class _KuloginState extends State<Kulogin> {
  TextEditingController baruaPepeCon = TextEditingController();
  TextEditingController nenoSiriCon = TextEditingController();
  bool nalodi = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('vifaa/usajili.jpg'), fit: BoxFit.cover)),
      child: SafeArea(
          child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(15)),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                jinaLaApp,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: baruaPepeCon,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Barua pepe ya mtumiaji',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nenoSiriCon,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Neno siri la mtumiaji',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: kToolbarHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: nalodi
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () async {
                          if (mcheckiFomu()) {
                            try {
                              setState(() {
                                nalodi = true;
                              });
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: baruaPepeCon.text.trim(),
                                      password: nenoSiriCon.text.trim());
                              setState(() {
                                nalodi = false;
                              });
                            } catch (shida) {
                              setState(() {
                                nalodi = false;
                              });
                              mjumbe(shida.toString());
                            }
                          }
                        },
                        child: const Text(
                          'Ingia',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Msajili()));
                      },
                      child: const Text('Jisajili')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const KuresetNenoSiri()));
                      },
                      child: const Text('Umesahau neno siri?'))
                ],
              )
            ],
          ),
        ),
      )),
    ));
  }

  mcheckiFomu() {
    if (baruaPepeCon.text.isEmpty) {
      mjumbe('Andika barua pepe');
      return false;
    }
    if (nenoSiriCon.text.isEmpty) {
      mjumbe('Andika neno siri ili kuendelea');
      return false;
    }
    return true;
  }

  mjumbe(String ujumbe) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ujumbe)));
  }
}

class Msajili extends StatefulWidget {
  const Msajili({super.key});

  @override
  State<Msajili> createState() => _MsajiliState();
}

class _MsajiliState extends State<Msajili> {
  TextEditingController jinafestCon = TextEditingController();
  TextEditingController jinalastCon = TextEditingController();
  TextEditingController baruapepeCon = TextEditingController();
  TextEditingController nenoSiriCon = TextEditingController();
  TextEditingController nenoSiriConCon = TextEditingController();
  FirebaseAuth kisajilishi = FirebaseAuth.instance;
  String mkoaSelected = mikoa[1];
  bool nalodi = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 32, right: 32),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('vifaa/usajili.jpg'), fit: BoxFit.cover)),
        //safe-area hapa ili ku allow container beyond statusbar
        child: SafeArea(
            child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(jinaLaApp,
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                mkoaDropy(),
                fomu(jinafestCon, 'Jina la kwanza'),
                const SizedBox(height: 8),
                fomu(jinalastCon, 'Jina la mwisho'),
                const SizedBox(height: 8),
                fomu(baruapepeCon, 'Barua pepe'),
                const SizedBox(height: 8),
                fomu(nenoSiriCon, 'Neno siri'),
                const SizedBox(height: 8),
                fomu(nenoSiriConCon, 'Hakiki neno siri'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: nalodi
                      ? const Center(child: CircularProgressIndicator())
                      : TextButton(
                          onPressed: () async {
                            if (mcheckiFomu()) {
                              try {
                                setState(() {
                                  nalodi = true;
                                });
                                await kisajilishi
                                    .createUserWithEmailAndPassword(
                                        email: baruapepeCon.text.trim(),
                                        password: nenoSiriCon.text.trim())
                                    .then(
                                  (value) async {
                                    await mratibuDeits();
                                    setState(() {
                                      nalodi = false;
                                    });
                                    rudi();
                                  },
                                );
                              } catch (shida) {
                                setState(() {
                                  nalodi = false;
                                });
                                mjumbe(shida.toString());
                              }
                            }
                          },
                          child: const Text(
                            'sajili sasa',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  fomu(TextEditingController con, String hint) {
    return TextField(
        controller: con,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.white)));
  }

  mcheckiFomu() {
    if (jinafestCon.text.isEmpty) {
      mjumbe('Jina la kwanza linahitajika');
      return false;
    }
    if (jinalastCon.text.isEmpty) {
      mjumbe('Jina la mwisho linahitajika');
      return false;
    }
    if (nenoSiriCon.text.isEmpty) {
      mjumbe('Andika neno siri');
      return false;
    }
    if (nenoSiriConCon.text.isEmpty) {
      mjumbe('Hakiki neno siri');
      return false;
    }
    if (nenoSiriCon.text != nenoSiriConCon.text) {
      mjumbe('Neno siri haliendani, Hakiki upya ili kuendelea');
      return false;
    }
    return true;
  }

  mkoaDropy() {
    return DropdownButton(
      iconEnabledColor: Colors.white,
      hint: Text(
        mkoaSelected,
        style: const TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      dropdownColor: Colors.green[200],
      items: List.generate(
          mikoa.length,
          (index) =>
              DropdownMenuItem(value: mikoa[index], child: Text(mikoa[index]))),
      onChanged: (iliyoguzwa) {
        setState(() {
          mkoaSelected = iliyoguzwa!;
        });
      },
    );
  }

  Future<void> mratibuDeits() async {
    var obj = FirebaseAuth.instance;
    //na update display name na profile picture
    await kisajilishi.currentUser
        ?.updateDisplayName('${jinafestCon.text} ${jinalastCon.text}');
    await kisajilishi.currentUser?.updatePhotoURL(pichaDefault);
    //mwisho hapa
    var mimi = obj.currentUser?.email;
    var picha = obj.currentUser?.photoURL;
    //process ya ku upload deits za yuza
    try {
      await FirebaseFirestore.instance.collection(usrCollection).doc(mimi).set({
        pichaUSR: picha,
        jinaUSR: obj.currentUser?.displayName,
        lokeshenUSR: mkoaSelected
      });
    } catch (shida) {
      mjumbe(shida.toString());
    }
  }

  mjumbe(String ujumbe) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ujumbe)));
  }

  rudi() {
    Navigator.of(context).pop();
  }
}

class KuresetNenoSiri extends StatefulWidget {
  const KuresetNenoSiri({super.key});

  @override
  State<KuresetNenoSiri> createState() => _KuresetNenoSiriState();
}

class _KuresetNenoSiriState extends State<KuresetNenoSiri> {
  TextEditingController baruaPepeCon = TextEditingController();
  bool nalodi = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(left: 32, right: 32),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('vifaa/usajili.jpg'), fit: BoxFit.cover)),
      child: SafeArea(
          child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: const BoxDecoration(color: Colors.black38),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Badili neno siri',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: baruaPepeCon,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Barua pepe ya mtumaiji',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: kToolbarHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: nalodi
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () async {
                          if (baruaPepeCon.text.isNotEmpty) {
                            try {
                              setState(() {
                                nalodi = true;
                              });
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: baruaPepeCon.text);
                              setState(() {
                                nalodi = false;
                              });
                              mjumbe(
                                  'Barua pepe ya ikuwezeshayo kubadili neno siri imetumwa kikamilifu');
                            } catch (shida) {
                              setState(() {
                                nalodi = false;
                              });
                              mjumbe(shida.toString());
                            }
                          } else {
                            mjumbe('Barua pepe inahitajika');
                          }
                        },
                        child: const Text(
                          'wasilisha',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
              ),
            ],
          ),
        ),
      )),
    ));
  }

  mjumbe(String ujumbe) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ujumbe)));
  }
}
