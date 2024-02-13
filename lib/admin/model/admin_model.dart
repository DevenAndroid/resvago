class AdminModel {
  dynamic adminCommission;
  dynamic userId;
  dynamic email;
  dynamic password;
  dynamic key;

  AdminModel({this.adminCommission, this.userId, this.email, this.password,this.key});

  AdminModel.fromJson(Map<String, dynamic> json) {
    adminCommission = json['admin_commission'];
    userId = json['UserId'];
    email = json['email'];
    password = json['Password'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_commission'] = this.adminCommission;
    data['UserId'] = this.userId;
    data['email'] = this.email;
    data['Password'] = this.password;
    data['key'] = this.key;
    return data;
  }
}
