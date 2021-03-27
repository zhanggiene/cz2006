class User {
  String name;
  String UserId;
  String imageURL;
  int coins;
  bool isAdmin;
  int likedNum;

  User(this.UserId, {this.name, this.imageURL, this.isAdmin,this.likedNum});

  Map<String, dynamic> toJason() => {
        "name": name,
        "isAdmin": isAdmin,
        "likedNum": likedNum
      };
}
