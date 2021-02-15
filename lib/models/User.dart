class User {
  String name;
  String UserId;
  String imageURL;

  User(this.UserId,{this.name,this.imageURL});

  get getCurrentUserid => null;
  Map<String, dynamic> toJason() => {
        "name": name,
      };
}
