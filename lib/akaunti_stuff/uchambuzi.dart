import 'package:carousel_slider/carousel_slider.dart';
import 'package:chaurental/shared/rejea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Uchambuzi extends StatefulWidget {
  final data;
  const Uchambuzi({super.key, required this.data});

  @override
  State<Uchambuzi> createState() => _UchambuziState();
}

class _UchambuziState extends State<Uchambuzi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.green,
        title: const Text('Hali ya Tangazo'),
      ),
      body: ListView(
        children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TZS ${widget.data[gharamaT]}/= ',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sofont'),
                ),
                Text(
                  widget.data[ainaPangor],
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'sofont'),
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
                          'Idadi ya watazamaji',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.data[viewsT].length.toString(),
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
                          'Idadi ya walioguswa na tangazo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.data[likesT].length.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Maoni',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        mfetchMaoni(widget.data.id)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  mfetchMaoni(String utambulisho) {
    var stream = FirebaseFirestore.instance
        .collection(matangazoC)
        .doc(utambulisho)
        .collection(maoniC)
        .limit(3)
        .snapshots();
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data as dynamic).docs.isEmpty) {
            return const Center(child: Text('Hakuna Maoni'));
          }
          var doks = (snapshot.data as dynamic).docs;
          return Column(
              children: doks
                  .map((oneDok) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          contentPadding: const EdgeInsets.all(8),
                          tileColor: Colors.green[100],
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(oneDok[pichaM]),
                          ),
                          title: Text(
                            oneDok[jinaM],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'sofont'),
                          ),
                          subtitle: Text(oneDok[contentM]),
                        ),
                      ))
                  .toList()
                  .cast<Widget>());
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
