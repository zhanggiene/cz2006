import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/View/AddCouponForm.dart';
import 'package:cz2006/View/CouponTile.dart';
import 'package:cz2006/controller/CouponController.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/models/User.dart';
import 'package:flutter/material.dart';
import 'package:cz2006/models/Coupon.dart';
import 'package:provider/provider.dart';

import '../locator.dart';
import 'UserRewardsText.dart';

class CouponRedemptionView extends StatefulWidget {
  @override
  _CouponRedemptionViewState createState() => _CouponRedemptionViewState();
}

class _CouponRedemptionViewState extends State<CouponRedemptionView> {
  @override
  Widget build(BuildContext context) {
    User currentUser;
    Future<void> getCurrentUser() async {
      currentUser = locator.get<UserController>().currentuser;
    }

    getCurrentUser();

    void _showAddCouponPanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: AddCouponForm());
          });
    }

    return StreamProvider<List<Coupon>>.value(
      value: CouponController().coupons,
      child: Scaffold(
          appBar: AppBar(
            title: !currentUser.isAdmin
                ? Text("Coupon Redemption")
                : Text("Manage Coupon"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: CouponList()),
              !currentUser.isAdmin
                  ? Row(
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
                        StreamProvider<DocumentSnapshot>.value(
                          value: UserController().userSnapshot,
                          child: UserRewardsText(),
                        ),
                      ],
                    )
                  : RaisedButton(
                      onPressed: () {
                        _showAddCouponPanel();
                      },
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "ADD A COUPON",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
              SizedBox(height: 10.0)
            ],
          )),
    );
  }
}
