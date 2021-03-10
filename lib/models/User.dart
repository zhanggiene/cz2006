class User {
  String name;
  String UserId;
  String imageURL;
  int coins;
  bool isAdmin;

  User(this.UserId, {this.name, this.imageURL});

  Map<String, dynamic> toJason() => {
        "name": name,
      };
}
