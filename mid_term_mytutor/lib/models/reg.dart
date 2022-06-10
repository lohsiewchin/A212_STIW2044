class Registration {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;

  Registration(
      {this.name,
      this.email,
      this.password,
      this.phone,
      this.address,});

  Registration.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}