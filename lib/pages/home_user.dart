import 'package:flutter/material.dart';
import 'package:mirai_app/widgets/file.dart';
import 'package:mirai_app/widgets/header.dart';
import '../classes/mirai_user.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key, this.user});

  final MiraiUser? user;

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  bool srvState = false;

  final titles = ["Cost", "Errors", "Cost (Yearly)", "Files Hosted"];
  final colors = [Colors.blue, Colors.red, Colors.green, Colors.purple];

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
              const Header(title: "MiraiDB"),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.7,
                        mainAxisSpacing: 10),
                    itemBuilder: (context, index) => SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: colors[index],
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        bottomLeft: Radius.circular(100))),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 39, 58, 83),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        titles[index],
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color.fromARGB(255, 218, 218, 218),
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        (index == 0
                                                ? widget.user?.earnings ?? 0.0
                                                : index == 1
                                                    ? widget.user?.deadNodes ?? 0
                                                    : index == 2
                                                        ? widget.user
                                                                ?.earningsYearly ??
                                                            0.0
                                                        : widget.user?.files
                                                                ?.length ??
                                                            0)
                                            .toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    if(widget.user?.files != null)
                      for(var file in widget.user!.files!)
                          HostedFile(file: file)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
