String getRating(List<double> stars) {
  var rating = 0.0;
  for (int i = 0; i < stars.length; ++i) {
    rating += stars[i];
  }
  rating = rating / stars.length;
  double rez = double.parse((rating).toStringAsFixed(1));
  return rez.toString();
}

double getRatingAsDouble(List<double> stars) {
  var rating = 0.0;
  for (int i = 0; i < stars.length; ++i) {
    rating += stars[i];
  }
  rating = rating / stars.length;
  return rating;
}
