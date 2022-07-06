class Cart {
  String? cart_id;
  String? subject_id;
  String? subject_name;
  String? subject_price;
  String? cart_qty;
  String? price_total;

  Cart(
      {this.cart_id,
      this.subject_id,
      this.subject_name,
      this.subject_price,
      this.cart_qty,
      this.price_total});

  Cart.fromJson(Map<String, dynamic> json) {
    cart_id = json['cart_id'];
    subject_id = json['subject_id'];
    subject_name = json['subject_name'];
    subject_price = json['subject_price'];
    cart_qty = json['cart_qty'];
    price_total = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cart_id;
    data['subject_id'] = subject_id;
    data['subject_name'] = subject_name;
    data['subject_price'] = subject_price;
    data['cart_qty'] = cart_qty;
    data['price_total'] = price_total;
    return data;
  }
}