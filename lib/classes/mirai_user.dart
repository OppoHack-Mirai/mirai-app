import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MiraiUser {
  User? user;
  int? deadNodes;
  double? earnings;
  double? earningsYearly;
  List? files;
  List? nodes;
  int? nodesRunning;
  Timestamp? time;
  String? type;

  MiraiUser(this.user, this.deadNodes, this.earnings, this.earningsYearly, this.files, this.nodes, this.nodesRunning, this.time, this.type);

  factory MiraiUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MiraiUser(
      null,
      data?["dead_nodes"],
      double.parse(data?["earnings"].toString() ?? ""),
      double.parse(data?["earningsYearly"].toString() ?? ""),
      data?["files"],
      data?["nodes"],
      data?["nodes_running"],
      data?["time"],
      data?["type"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "dead_nodes": deadNodes,
      "earnings": earnings,
      "earningsYearly": earningsYearly,
      "files": files,
      "nodes": nodes,
      "nodesRunning": nodesRunning,
      "time": time,
      "type": type,
    };
  }
}