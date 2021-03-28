import 'package:cz2006/View/CreatePost.dart';
import 'package:cz2006/View/details.dart';
import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPost extends StatefulWidget {
  ViewPost({Key key}) : super(key: key);

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  List<Post> posts;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    print("to get all posts");
    locator.get<PostController>().getPostByTime().then((value) {
      posts = value;
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.amber),
          title: Text('profile'),
          backgroundColor: Colors.white,
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      child: ListTile(
                        leading: Image.network(
                          //"https://guardiandigital.com/images/url-defense.png",
                          posts[index].images[0],
                          //await _storageService.getUserProfileImage(currentuser.UserId)
                          //posts[index].
                          width: 120,
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(posts[index].title),
                        subtitle: Text(DateFormat('yyyy-MM-dd').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                posts[index].timeOfCreation))),
                      ),
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Detail(post: posts[index])))
                            .then((value) => setState(() {
                                  getdata();
                                }));
                      });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.black,
                  );
                },
                itemCount: posts.length),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadPhotoPage()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ));
  }
}
