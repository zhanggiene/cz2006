import 'dart:io';

import 'package:cz2006/View/InputDecoration.dart';
import 'package:cz2006/controller/CouponController.dart';
import 'package:cz2006/widgets/ProfileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';

class AddCouponForm extends StatefulWidget {
  @override
  _AddCouponFormState createState() => _AddCouponFormState();
}

class _AddCouponFormState extends State<AddCouponForm> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  String _imageURL;
  int _couponValue;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 20),
          Text(
            "ADD A COUPON",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.green),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Coupon Title'),
            validator: (val) =>
                val.isEmpty ? "Please enter coupon title" : null,
            onChanged: (val) => setState(() => _title = val),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Coupon Value'),
            validator: (val) =>
                val.isEmpty ? "Please enter coupon value" : null,
            onChanged: (val) => setState(() => _couponValue = int.parse(val)),
          ),
          SizedBox(height: 40.0),
          Text("  Choose Coupon Image:", style: TextStyle(fontSize: 16)),
          SizedBox(height: 20.0),
          ProfileImage(
            url: _imageURL,
            onTap: () async {
              PickedFile pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              File selected = File(pickedFile.path);
              String imageURL =
                  await CouponController().uploadCouponImage(selected, _title);
              setState(() => _imageURL = imageURL);

              print("uploading coupon pic " + _imageURL);
            },
          ),
          SizedBox(height: 20.0),
          Center(
            child: RaisedButton(
              onPressed: () async {
                print("added");
                print(_title + " $_couponValue " + _imageURL);
                if (_formKey.currentState.validate() &&
                    Uri.parse(_imageURL).isAbsolute) {
                  await CouponController()
                      .addCoupon(_title, _couponValue, _imageURL);
                  Navigator.of(context).pop();
                }
              },
              color: Colors.green,
              child: Text(
                "ADD",
                style: TextStyle(
                    fontSize: 14, letterSpacing: 2, color: Colors.white),
              ),
            ),
          )
        ]));
  }
}
