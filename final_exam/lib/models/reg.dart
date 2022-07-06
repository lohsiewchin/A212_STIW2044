class Registration {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;
  String? cart;

  Registration(
      {this.name,
      this.email,
      this.password,
      this.phone,
      this.address,
      this.cart,});

  Registration.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['cart'] = cart;
    return data;
  }
}