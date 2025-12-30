/// Temperature converter helper to standardize temperature display across the app
/// Always converts to Fahrenheit and adds the °F unit
class TemperatureConverterHelper {
  /// Convert temperature to Fahrenheit
  /// Assumes input is in Fahrenheit if it's already in typical Fahrenheit range (-50 to 150)
  /// Otherwise assumes it's Celsius and converts to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Format temperature with unit (°F)
  /// Input can be in any unit, will be standardized to °F
  static String formatTemperatureF(double? temperature) {
    if (temperature == null) return 'N/A';
    
    // If temperature is likely in Celsius range (-50 to 50), convert it
    // Otherwise assume it's already in Fahrenheit
    double fahrenheit = temperature;
    if (temperature > -50 && temperature < 50) {
      // Could be Celsius, check if conversion makes sense
      // If after conversion it's more reasonable (between -58 and 122), convert
      double converted = celsiusToFahrenheit(temperature);
      if (converted > -58 && converted < 122) {
        fahrenheit = converted;
      }
    }
    
    return '${fahrenheit.round()}°F';
  }

  /// Format temperature without unit (just the number)
  /// Useful when you want to add the unit separately
  static int formatTemperatureFValue(double? temperature) {
    if (temperature == null) return 0;
    
    double fahrenheit = temperature;
    if (temperature > -50 && temperature < 50) {
      double converted = celsiusToFahrenheit(temperature);
      if (converted > -58 && converted < 122) {
        fahrenheit = converted;
      }
    }
    
    return fahrenheit.round();
  }

  /// Get just the Fahrenheit value as double (rounded)
  static double getTemperatureFValue(double? temperature) {
    if (temperature == null) return 0.0;
    
    double fahrenheit = temperature;
    if (temperature > -50 && temperature < 50) {
      double converted = celsiusToFahrenheit(temperature);
      if (converted > -58 && converted < 122) {
        fahrenheit = converted;
      }
    }
    
    return fahrenheit;
  }
}
