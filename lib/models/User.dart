class User {
  String name;
  String UserId;
  String imageURL;
  int coins;
  bool isAdmin;

  User(this.UserId, {this.name, this.imageURL,this.isAdmin});

  Map<String, dynamic> toJason() => {
        "name": name,
        "isAdmin": isAdmin,
      };
}
