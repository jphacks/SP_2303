class SafeAreaUtil {
  factory SafeAreaUtil() => _cache;
  SafeAreaUtil._internal();
  static final SafeAreaUtil _cache = SafeAreaUtil._internal();

  static double unSafeAreaBottomHeight = 0.0;
  static double unSafeAreaTopHeight = 0.0;
  bool get hasUnSafeAreaBottomHeight => unSafeAreaBottomHeight != 0.0;
  bool get hasUnSafeAreaTopHeight => unSafeAreaTopHeight != 0.0;
}