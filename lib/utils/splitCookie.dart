Map crsftoken(String? c) {
  var cookies = c!.split(";");
  var cookie0 = cookies[0].split("=");
  var cookie4 = cookies[4].split("=");
  var session = cookie4[2];
  var crsf = cookie0[1];
  var car = {'0': crsf, '1': session};
  return car;
}
