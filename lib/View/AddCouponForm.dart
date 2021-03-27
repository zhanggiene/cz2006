import 'package:cz2006/View/InputDecoration.dart';
import 'package:cz2006/controller/CouponController.dart';
import 'package:flutter/material.dart';

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
        child: Column(children: [
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
          SizedBox(height: 20.0),
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: 'Image URL'),
            validator: (val) => val.isEmpty ? "Please enter image URL" : null,
            onChanged: (val) => setState(() => _imageURL = val),
          ),
          SizedBox(height: 20.0),
          CircleAvatar(
            backgroundImage: NetworkImage(Uri.parse(_imageURL ?? ' ').isAbsolute
                ? _imageURL
                : 'https://lh3.googleusercontent.com/EbXw8rOdYxOGdXEFjgNP8lh-YAuUxwhOAe2jhrz3sgqvPeMac6a6tHvT35V6YMbyNvkZL4R_a2hcYBrtfUhLvhf-N2X3OB9cvH4uMw=w1064-v0'),
            radius: 50.0,
          ),
          SizedBox(height: 20.0),
          RaisedButton(
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
          )
        ]));
  }
}
