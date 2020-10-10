class VaultRespModel {}

class VaultRows {
  int id;
  int mineType;
  String depositTokenName;
  int depositTokenType;
  String pic1;
  String pic2;
  String contractAddress;
  double apy;

  VaultRows(
      {this.id,
      this.mineType,
      this.depositTokenName,
      this.depositTokenType,
      this.pic1,
      this.pic2,
      this.contractAddress,
      this.apy});
}
