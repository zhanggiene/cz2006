import 'dart:io';

import 'package:cz2006/controller/UserController.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    this.url,
    this.onTap,
  });
  final String url;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
          child: url == null
              ? CircleAvatar(
                  radius: 50.0,
                  child: Icon(Icons.photo_camera),
                )
              : CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(url),
                )),
    );
  }
}
