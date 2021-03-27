import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/controller/CouponController.dart';
import 'package:cz2006/controller/EmailService.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Coupon.dart';
import 'package:cz2006/models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponTile extends StatelessWidget {
  final Coupon coupon;
  CouponTile({this.coupon});

  User currentUser = locator.get<UserController>().currentuser;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 0.0),
          child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(coupon.imageURL),
                radius: 30.0,
              ),
              title: Text(coupon.title,
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage("images/coins.png"),
                      backgroundColor: Colors.yellow,
                      radius: 15.0),
                  SizedBox(width: 5.0),
                  Text("${coupon.couponValue}"),
                  if (currentUser.isAdmin)
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete this coupon?"),
                                content: Text(coupon.title),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.grey))),
                                  FlatButton(
                                      onPressed: () async {
                                        CouponController()
                                            .deleteCoupon(coupon.title);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Delete",
                                          style: TextStyle(color: Colors.red))),
                                ],
                              );
                            });
                      },
                    ),
                ],
              ),
              onTap: () {
                if (!currentUser.isAdmin) {
                  // normal user -> tap to redeem
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm of redemption?"),
                          content: Text(coupon.title),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            FlatButton(
                                onPressed: () async {
                                  int userRewards = await locator
                                      .get<UserController>()
                                      .getCoins();
                                  if (userRewards >= coupon.couponValue) {
                                    print("user coins: $userRewards -> redeem");
                                    UserController()
                                        .updateCoins(-coupon.couponValue);
                                    EmailService()
                                        .sendMail(currentUser, coupon);
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: const Text(
                                              "Coupon redemption successfully!",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            children: [
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Center(
                                                child: Text(
                                                    "Check your mail box to use the voucher",
                                                    style: TextStyle(
                                                        fontSize: 15.0)),
                                              ),
                                              SizedBox(
                                                height: 25.0,
                                              ),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Return",
                                                      style: TextStyle(
                                                          color: Colors.green)))
                                            ],
                                          );
                                        });
                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: const Text(
                                              "Coupon redemption failed!",
                                            ),
                                            children: [
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Center(
                                                child:
                                                    Text("Insufficient balance",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        )),
                                              ),
                                              SizedBox(
                                                height: 25.0,
                                              ),
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Return",
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.green)))
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text("Redeem")),
                          ],
                        );
                      });
                }
              }),
        ));
  }
}

class CouponList extends StatefulWidget {
  @override
  _CouponListState createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  @override
  Widget build(BuildContext context) {
    final coupons = Provider.of<List<Coupon>>(context);
    print(coupons);

    return ListView.builder(
        itemCount: coupons?.length ?? 0,
        itemBuilder: (context, index) {
          return CouponTile(coupon: coupons[index]);
        });
  }
}
