class RoleModal {
  int? state;
  bool? status;
  String? message;
  dynamic errorMessage;
  List<RoleData>? data;

  RoleModal({
    this.state,
    this.status,
    this.message,
    this.errorMessage,
    this.data,
  });

  RoleModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    errorMessage = json['ErrorMessage'];

    if (json['Data'] != null) {
      data = <RoleData>[];
      json['Data'].forEach((v) {
        data!.add(RoleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['State'] = state;
    json['Status'] = status;
    json['Message'] = message;
    json['ErrorMessage'] = errorMessage;
    if (data != null) {
      json['Data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class RoleData {
  int? roleID;
  int? officeID;
  String? roleName;
  bool? isMainRole;
  String? enumRoleName;
  int? userID;
  String? officeNameEn;

  RoleData({
    this.roleID,
    this.officeID,
    this.roleName,
    this.isMainRole,
    this.enumRoleName,
    this.userID,
    this.officeNameEn,
  });

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return RoleData(
      roleID: json['RoleID'],
      officeID: json['OfficeID'],
      roleName: json['RoleName'],
      isMainRole: json['IsMainRole'],
      enumRoleName: json['EnumRoleName'],
      userID: json['UserID'],
      officeNameEn: json['OfficeNameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['RoleID'] = roleID;
    json['OfficeID'] = officeID;
    json['RoleName'] = roleName;
    json['IsMainRole'] = isMainRole;
    json['EnumRoleName'] = enumRoleName;
    json['UserID'] = userID;
    json['OfficeNameEn'] = officeNameEn;
    return json;
  }

  // ✅ IMPORTANT for Dropdown selection
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoleData && other.roleID == roleID;
  }

  @override
  int get hashCode => roleID.hashCode;
}
