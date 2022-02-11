const kPi = 3.14;

///
/// Converts a radian angle to a degree angle.
///
double rad2deg(double rad) {
  return rad * 180.0 / kPi;
}

///
/// Converts a degree angle to a radian angle.
///
double deg2rad(double deg) {
  return deg * kPi / 180.0;
}

///
/// Remaps a value from one range to another range.
///
///
double remap(double value, double fromMin, double fromMax, double toMin, double toMax) {
  return (value - fromMin) * (toMax - toMin) / (fromMax - fromMin) + toMin;
}
