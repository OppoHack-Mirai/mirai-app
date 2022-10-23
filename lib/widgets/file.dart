import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HostedFile extends StatefulWidget {
  const HostedFile({super.key, required this.file});

  final DocumentReference file;

  @override
  State<HostedFile> createState() => _HostedFileState();
}

class _HostedFileState extends State<HostedFile> {
  @override
  void initState() {
    super.initState();
  }

  List images = ["png", "jpg", "tiff", "gif"];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.file.get(), builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              var data = snapshot.data;
              var date = DateTime.fromMillisecondsSinceEpoch(data?['time_created'] * 1000);
              String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: ListTile(
                  title: Text(data?['real_name'] ?? ""),
                  subtitle: Text(formattedDate),
                  trailing: SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 22,
                          width: 22,
                          child: IconButton(onPressed: () async {
                            Uri url = Uri.parse("http://cdn.yale26.com/perform_service/${snapshot.data?.id}/zip");
                            Directory appDocDir = await getApplicationDocumentsDirectory();
                            final now = DateTime.now();
                            String fileName = now.microsecondsSinceEpoch.toString();
                            String path = "${appDocDir.path}/$fileName.zip";
                            http.get(url).then((response) async {
                              await File(path).writeAsBytes(response.bodyBytes);
                              Share.shareFiles([path]);
                            });
                          }, icon: const Icon(Icons.folder_zip)),
                        ),
                        if(images.contains(data?["real_name"].split('.').last))
                          Row(
                            children: [
                              const SizedBox(width: 10,),
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: IconButton(onPressed: () async {
                                  Uri url = Uri.parse("http://cdn.yale26.com/perform_service/${snapshot.data?.id}/image_recognition");
                                  Directory appDocDir = await getApplicationDocumentsDirectory();
                                  final now = DateTime.now();
                                  String fileName = now.microsecondsSinceEpoch.toString();
                                  String path = "${appDocDir.path}/$fileName.txt";
                                  http.get(url).then((response) async {
                                    await File(path).writeAsBytes(response.bodyBytes);
                                    Share.shareFiles([path]);
                                  });
                                }, icon: const Icon(Icons.image),),
                              )
                            ],
                          ),
                        if(images.contains(data?["real_name"].split('.').last))
                          Row(
                            children: [
                              const SizedBox(width: 10,),
                              SizedBox(
                                height: 22,
                                width: 22,
                                child: IconButton(onPressed: () async {
                                  print('here');
                                  Uri url = Uri.parse("http://cdn.yale26.com/perform_service/${snapshot.data?.id}/ocr");
                                  Directory appDocDir = await getApplicationDocumentsDirectory();
                                  final now = DateTime.now();
                                  String fileName = now.microsecondsSinceEpoch.toString();
                                  String path = "${appDocDir.path}/$fileName.txt";
                                  http.get(url).then((response) async {
                                    await File(path).writeAsBytes(response.bodyBytes);
                                    Share.shareFiles([path]);
                                  });
                                }, icon: const Icon(Icons.text_fields),),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return const SizedBox();
        }));
  }
}
