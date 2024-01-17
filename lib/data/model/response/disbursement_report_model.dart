class DisbursementReportModel {
  int? totalSize;
  String? limit;
  String? offset;
  double? pending;
  double? completed;
  double? canceled;
  int? completeDay;
  List<Disbursements>? disbursements;

  DisbursementReportModel(
      {this.totalSize,
        this.limit,
        this.offset,
        this.pending,
        this.completed,
        this.canceled,
        this.completeDay,
        this.disbursements});

  DisbursementReportModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    pending = json['pending']?.toDouble();
    completed = json['completed']?.toDouble();
    canceled = json['canceled']?.toDouble();
    completeDay = json['complete_day'];
    if (json['disbursements'] != null) {
      disbursements = <Disbursements>[];
      json['disbursements'].forEach((v) {
        disbursements!.add(Disbursements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['pending'] = pending;
    data['completed'] = completed;
    data['canceled'] = canceled;
    data['complete_day'] = completeDay;
    if (disbursements != null) {
      data['disbursements'] = disbursements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Disbursements {
  int? id;
  int? disbursementId;
  int? restaurantId;
  int? deliveryManId;
  double? disbursementAmount;
  int? paymentMethod;
  String? status;
  String? createdAt;
  String? updatedAt;
  WithdrawMethod? withdrawMethod;

  Disbursements(
      {this.id,
        this.disbursementId,
        this.restaurantId,
        this.deliveryManId,
        this.disbursementAmount,
        this.paymentMethod,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.withdrawMethod});

  Disbursements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    disbursementId = json['disbursement_id'];
    restaurantId = json['restaurant_id'];
    deliveryManId = json['delivery_man_id'];
    disbursementAmount = json['disbursement_amount'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    withdrawMethod = json['withdraw_method'] != null
        ? WithdrawMethod.fromJson(json['withdraw_method'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['disbursement_id'] = disbursementId;
    data['restaurant_id'] = restaurantId;
    data['delivery_man_id'] = deliveryManId;
    data['disbursement_amount'] = disbursementAmount;
    data['payment_method'] = paymentMethod;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (withdrawMethod != null) {
      data['withdraw_method'] = withdrawMethod!.toJson();
    }
    return data;
  }
}

class WithdrawMethod {
  int? id;
  int? restaurantId;
  int? deliveryManId;
  int? withdrawalMethodId;
  String? methodName;
  MethodFields? methodFields;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  WithdrawMethod(
      {this.id,
        this.restaurantId,
        this.deliveryManId,
        this.withdrawalMethodId,
        this.methodName,
        this.methodFields,
        this.isDefault,
        this.createdAt,
        this.updatedAt});

  WithdrawMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    deliveryManId = json['delivery_man_id'];
    withdrawalMethodId = json['withdrawal_method_id'];
    methodName = json['method_name'];
    methodFields = json['method_fields'] != null
        ? MethodFields.fromJson(json['method_fields'])
        : null;
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['delivery_man_id'] = deliveryManId;
    data['withdrawal_method_id'] = withdrawalMethodId;
    data['method_name'] = methodName;
    if (methodFields != null) {
      data['method_fields'] = methodFields!.toJson();
    }
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MethodFields {
  String? transactionId;

  MethodFields({this.transactionId});

  MethodFields.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    return data;
  }
}