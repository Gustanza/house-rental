import 'package:chaurental/shared/rejea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Maoni extends StatefulWidget {
  final String tangazoHili;
  const Maoni({super.key, required this.tangazoHili});

  @override
  State<Maoni> createState() => _MaoniState();
}

class _MaoniState extends State<Maoni> {
  var endPointYaMaoni = FirebaseFirestore.instance.collection(matangazoC);
  var jinaLangu = FirebaseAuth.instance.currentUser!.displayName;
  var emailYangu = FirebaseAuth.instance.currentUser!.email;
  var pichaYangu = FirebaseAuth.instance.currentUser!.photoURL;
  TextEditingController oniLenyewe = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          title: const Text('Maoni')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: endPointYaMaoni
                  .doc(widget.tangazoHili)
                  .collection(maoniC)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = (snapshot.data as dynamic).docs;
                  if (data.isEmpty) {
                    return const Center(child: Text('Hakuna Maoni'));
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ListTile(
                          tileColor: Colors.green[100],
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            backgroundImage: NetworkImage(data[index][pichaM]),
                          ),
                          title: Text(data[index][jinaM]),
                          subtitle: Text(data[index][contentM]),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Container(
            color: Colors.green[50],
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: oniLenyewe,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  hintText: 'Andika Hapa',
                  suffixIcon: IconButton(
                      onPressed: kutumaOni, icon: const Icon(Icons.send))),
            ),
          )
        ],
      ),
    );
  }

  kutumaOni() async {
    if (oniLenyewe.text.isNotEmpty) {
      await endPointYaMaoni.doc(widget.tangazoHili).collection(maoniC).add({
        pichaM: pichaYangu,
        jinaM: jinaLangu,
        mmilikiM: emailYangu,
        contentM: oniLenyewe.text
      });
      oniLenyewe.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Huwezi kutuma nafasi tupu')));
    }
  }
}
