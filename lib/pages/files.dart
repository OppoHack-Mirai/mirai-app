import 'package:flutter/material.dart';
import 'package:mirai_app/classes/mirai_user.dart';
import 'package:mirai_app/widgets/header.dart';
import 'package:mirai_app/widgets/file.dart';
import 'package:image_picker/image_picker.dart';

class Files extends StatefulWidget {
  const Files({super.key, this.user});

  final MiraiUser? user;

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 237, 237, 237),
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Header(title: "Files"),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Column(
                      children: [
                        widget.user?.type == "User" ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 175,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final List<XFile>? images = await _picker.pickMultiImage();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 78, 181)),
                                child: const Text("Add File"),
                              ),
                            ),
                          ],
                        ) : Container(),
                        if (widget.user?.files != null)
                          for (var file in widget.user!.files!) HostedFile(file: file)
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }
}
