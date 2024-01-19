class AdminModel {
  dynamic adminCommission;
  dynamic userId;
  dynamic email;
  dynamic password;

  AdminModel({this.adminCommission, this.userId, this.email, this.password});

  AdminModel.fromJson(Map<String, dynamic> json) {
    adminCommission = json['admin_commission'];
    userId = json['UserId'];
    email = json['email'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_commission'] = this.adminCommission;
    data['UserId'] = this.userId;
    data['email'] = this.email;
    data['Password'] = this.password;
    return data;
  }
}
