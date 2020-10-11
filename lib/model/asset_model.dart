class AssetModel {

  int id;

  String tokenName;

  int tokenType;

  int precision;

  String tokenAddress;



  AssetModel({this.id, this.tokenName, this.tokenType, this.precision,  this.tokenAddress});

  AssetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tokenName = json['tokenName'];
    tokenType = json['tokenType'];
    precision = json['precision'];
    tokenAddress = json['tokenAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tokenName'] = this.tokenName;
    data['precision'] = this.precision;
    data['tokenAddress'] = this.tokenAddress;
    return data;
  }

}