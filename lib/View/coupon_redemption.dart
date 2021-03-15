import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/View/CouponTile.dart';
import 'package:cz2006/controller/CouponController.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/models/User.dart';
import 'package:flutter/material.dart';
import 'package:cz2006/models/Coupon.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class CouponRedemptionView extends StatefulWidget {
  // int userRewards;
  // CouponRedemptionView({this.userRewards});

  @override
  _CouponRedemptionViewState createState() => _CouponRedemptionViewState();
}

class _CouponRedemptionViewState extends State<CouponRedemptionView> {
  // int userRewards;
  // _CouponRedemptionViewStart(userRewards) {
  //   this.userRewards = userRewards;
  // }

  @override
  Widget build(BuildContext context) {
    User user;
    Future<void> getCurrentUser() async {
      user = locator.get<UserController>().currentuser;
    }

    getCurrentUser();

    return StreamProvider<List<Coupon>>.value(
      value: CouponController().coupons,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Coupon Redemption"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: CouponList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You have: ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      )),
                  CircleAvatar(
                      backgroundImage: AssetImage("images/coins.png"),
                      backgroundColor: Colors.yellow,
                      radius: 14.0),
                  SizedBox(width: 5.0),
                  Text(
                    user.coins.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0)
            ],
          )),
    );
  }
}
