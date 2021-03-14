import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/View/CouponTile.dart';
import 'package:cz2006/controller/CouponController.dart';
import 'package:flutter/material.dart';
import 'package:cz2006/models/Coupon.dart';
import 'package:provider/provider.dart';

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
    return StreamProvider<List<Coupon>>.value(
      value: CouponController().coupons,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Coupon Redemption"),
          ),
          body: CouponList()),
    );
  }
}
