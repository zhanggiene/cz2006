import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRewardsText extends StatefulWidget {
  @override
  _UserRewardsTextState createState() => _UserRewardsTextState();
}

class _UserRewardsTextState extends State<UserRewardsText> {
  @override
  Widget build(BuildContext context) {
    final rewards = Provider.of<DocumentSnapshot>(context).data["rewards"];
    return Text(rewards.toString(),
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ));
  }
}
