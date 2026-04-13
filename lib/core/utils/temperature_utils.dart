class TemperatureUtils {
  TemperatureUtils._();

  static double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;

  static double fahrenheitToCelsius(double fahrenheit) =>
      (fahrenheit - 32) * 5 / 9;
}
