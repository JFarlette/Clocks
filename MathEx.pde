static class MathEx
{
  private static double E = 2.71828182845904523536;

  /// <summary>
  /// Returns e raised to the specified power
  /// </summary>
  /// <param name="x">A number specifying a power</param>
  /// <returns>e raised to x</returns>
  static public double Exp(double x)
  {
    int n = 1;
    double ex = 1.0;
    double m = 1.0;

    // exp(x+y) = exp(x) * exp(y)
    // http://www.quinapalus.com/efunc.html
    while (x > 10.000F) { 
      m *= 22026.4657948067f; 
      x -= 10F;
    }
    while (x > 01.000F) { 
      m *= E; 
      x -= 1F;
    }
    while (x > 00.100F) { 
      m *= 1.10517091807565f; 
      x -= 0.1F;
    }
    while (x > 00.010F) { 
      m *= 1.01005016708417f; 
      x -= 0.01F;
    }

    // if (Abs(x) < (double.Epsilon * 2)) return m;

    // Uses Taylor series 
    // http://www.mathreference.com/ca,tfn.html
    for (int y = 1; y <= 4; y++)
    {
      double c = Math.pow(x, y);
      ex += c / n;
      n *= (y + 1);
    }

    return ex * m;
  }
  
  static public double Abs(double d)
  {
    return (d < 0 ? d * -1 : d);
  }
  
  static public  double ConvertDegreeToRadian(double degree)
  {
    return degree * Math.PI / 180;
  }
}