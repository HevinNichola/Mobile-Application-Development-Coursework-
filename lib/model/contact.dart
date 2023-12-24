class Contact {
  int? id;
  String name;
  int contactno;
  String email;
  String image;
  String address;


  Contact({
    this.id,
    required this.name,
    required this.contactno,
    required this.email,
    required this.image,
    required this.address,

  });

  Contact.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        contactno = res["contactno"],
        email = res["email"],
        image = res["image"],
        address = res["address"];


  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name': name,
      'contactno': contactno,
      'email': email,
      'image': image,
      'address': address,

    };
  }

}