import 'package:flutter/cupertino.dart';

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}



// API Url
String apiUrl='http://icpd.icpbd-erp.com/api/app/login.php';

spancer({
  double w = 0,
  double h = 0,
}) {
  return SizedBox(
    height: h,
    width: w,
  );
}

EdgeInsets spacing({double h = 0, double v = 0}) {
  return EdgeInsets.symmetric(
    horizontal: h,
    vertical: v,
  );
}