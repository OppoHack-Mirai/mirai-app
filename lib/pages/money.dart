import 'package:flutter/material.dart';
import 'package:mirai_app/widgets/doughnut_chart.dart';
import 'package:mirai_app/widgets/file.dart';
import 'package:mirai_app/widgets/header.dart';

import '../classes/mirai_user.dart';

class Money extends StatefulWidget {
  const Money({super.key, this.user});

  final MiraiUser? user;

  @override
  State<Money> createState() => _MoneyState();
}

class _MoneyState extends State<Money> {

  final titles = ["Storage", "OCR                ", "Hosting", "Classification"];
  final colors = [const Color(0xff0293ee), const Color(0xff845bef), const Color(0xff13d38e), const Color(0xfff8b250)];

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
              const Header(title: "Balance"),
              const SizedBox(
                height: 20,
              ),
              DoughnutChart(earnings: widget.user?.earnings ?? 0.0,),
              const SizedBox(height: 30,),
              GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 6,
                        mainAxisSpacing: 1), itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                  decoration: BoxDecoration(
                                    color: colors[index],
                                    borderRadius: BorderRadius.circular(100)
                                  ),
                              ),
                              const SizedBox(width: 3,),
                              Text(titles[index])
                            ],
                          );
                        }),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Details', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),),
                    const Divider(color: Colors.black87,),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const ListTile(
                            title: Text('Served 4GFQvEfDoT7qbLtntYMo'),
                            subtitle: Text('Oct 22nd, 2022'),
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const ListTile(
                            title: Text('Stored 4ylwBgBNGTnvDCzKYF8A'),
                            subtitle: Text('Oct 22nd, 2022'),
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const ListTile(
                            title: Text('Served Gseov8T0t1TenqKaTBBp'),
                            subtitle: Text('Oct 22nd, 2022'),
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const ListTile(
                            title: Text('OCR on SErDtrYgpeylkw6ilMeL'),
                            subtitle: Text('Oct 22nd, 2022'),
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const ListTile(
                            title: Text('Classified ZfYg3LVCGKoMbyZIwqDi'),
                            subtitle: Text('Oct 22nd, 2022'),
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: const ListTile(
                            title: Text('Served 4GFQvEfDoT7qbLtntYMo'),
                            subtitle: Text('Oct 22nd, 2022'),
                          ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}