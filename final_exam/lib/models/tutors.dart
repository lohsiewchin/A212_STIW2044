class Tutor {
  String? tutor_id;
  String? tutor_email;
  String? tutor_phone;
  String? tutor_name;
  String? tutor_password;
  String? tutor_description;
  String? tutor_datereg;
  String? subject_owned;

  Tutor(
    this.tutor_id,
    {this.tutor_email, 
    this.tutor_phone, 
    this.tutor_name,
    this.tutor_password, 
    this.tutor_description, 
    this.tutor_datereg,
    this.subject_owned,
    });

  Tutor.fromJson(Map<String, dynamic> json) {
    tutor_id = json['tutor_id'];
    tutor_email = json['tutor_email'];
    tutor_phone = json['tutor_phone'];
    tutor_name = json['tutor_name'];
    tutor_password = json['tutor_password'];
    tutor_description = json['tutor_description'];
    tutor_datereg = json['tutor_datereg'];
    subject_owned = json['subject_owned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutor_id;
    data['tutor_email'] = tutor_email;
    data['tutor_phone'] = tutor_phone;
    data['tutor_name'] = tutor_name;
    data['tutor_password'] = tutor_password;
    data['tutor_description'] = tutor_description;
    data['tutor_datereg'] = tutor_datereg;
    data['subject_owned'] = subject_owned;
    return data;
  }
}