class ImageUtils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'static/images/splash/$name.$format';
  }
}