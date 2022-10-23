import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class File extends StatefulWidget {
  const File({super.key, required this.file});

  final DocumentReference file;

  @override
  State<File> createState() => _FileState();
}

class _FileState extends State<File> {
  @override
  void initState() {
    super.initState();
  }

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
                ),
              );
            }
          }
          return const SizedBox();
        }));
  }
}
