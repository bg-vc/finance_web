class CommonProvider {
  static int _homeIndex = 0;

  static int get homeIndex => _homeIndex;

  static changeHomeIndex(int value) {
    _homeIndex = value;
  }

  static List<String> _homeList = [
    '机枪池',
    '兑换交易',
    '连接钱包',
  ];
  static List<String> get homeList => _homeList;

}
