import java.time.LocalDateTime;
import java.lang.Math;

class SunCalculator
{
  private double longitude;
  private double latituteInRadians;
  private double longituteTimeZone;
  private boolean useSummerTime;

  public SunCalculator()
  {
  }

  public SunCalculator(double longitude, double latitude, double longituteTimeZone, boolean useSummerTime)
  {
    this.longitude = longitude;
    latituteInRadians = MathEx.ConvertDegreeToRadian(latitude);
    this.longituteTimeZone = longituteTimeZone;
    this.useSummerTime = useSummerTime;
  }

  public LocalDateTime CalculateSunRise(LocalDateTime dateTime)
  {
    int dayNumberOfDateTime = ExtractDayNumber(dateTime);
    double differenceSunAndLocalTime = CalculateDifferenceSunAndLocalTime(dayNumberOfDateTime);
    double declanationOfTheSun = CalculateDeclination(dayNumberOfDateTime);
    double tanSunPosition = CalculateTanSunPosition(declanationOfTheSun);
    int sunRiseInMinutes = CalculateSunRiseInternal(tanSunPosition, differenceSunAndLocalTime);
    return CreateDateTime(dateTime, sunRiseInMinutes);
  }

  public LocalDateTime CalculateSunSet(LocalDateTime dateTime)
  {
    int dayNumberOfDateTime = ExtractDayNumber(dateTime);
    double differenceSunAndLocalTime = CalculateDifferenceSunAndLocalTime(dayNumberOfDateTime);
    double declanationOfTheSun = CalculateDeclination(dayNumberOfDateTime);
    double tanSunPosition = CalculateTanSunPosition(declanationOfTheSun);
    int sunSetInMinutes = CalculateSunSetInternal(tanSunPosition, differenceSunAndLocalTime);
    return CreateDateTime(dateTime, sunSetInMinutes);
  }

  public double CalculateMaximumSolarRadiation(LocalDateTime dateTime)
  {
    int dayNumberOfDateTime = ExtractDayNumber(dateTime);
    double differenceSunAndLocalTime = CalculateDifferenceSunAndLocalTime(dayNumberOfDateTime);
    int numberOfMinutesThisDay = GetNumberOfMinutesThisDay(dateTime, differenceSunAndLocalTime);
    double declanationOfTheSun = CalculateDeclination(dayNumberOfDateTime);
    double sinSunPosition = CalculateSinSunPosition(declanationOfTheSun);
    double cosSunPosition = CalculateCosSunPosition(declanationOfTheSun);
    double sinSunHeight = sinSunPosition + cosSunPosition * Math.cos(2.0 * Math.PI * (numberOfMinutesThisDay + 720.0) / 1440.0) + 0.08;
    double sunConstantePart = Math.cos(2.0 * Math.PI * dayNumberOfDateTime);
    double sunCorrection = 1370.0 * (1.0 + (0.033 * sunConstantePart));
    return CalculateMaximumSolarRadiationInternal(sinSunHeight, sunCorrection);
  }

  private double CalculateDeclination(int numberOfDaysSinceFirstOfJanuary)
  {
    return Math.asin(-0.39795 * Math.cos(2.0 * Math.PI * (numberOfDaysSinceFirstOfJanuary + 10.0) / 365.0));
  }

  private int ExtractDayNumber(LocalDateTime dateTime)
  {
    return dateTime.getDayOfYear();
  }

  private LocalDateTime CreateDateTime(LocalDateTime dateTime, int timeInMinutes)
  {
    int hour = timeInMinutes / 60;
    int minute = timeInMinutes - (hour * 60);
    return LocalDateTime.of(dateTime.getYear(), dateTime.getMonth(), dateTime.getDayOfMonth(), hour, minute, 00);
  }

  private int CalculateSunRiseInternal(double tanSunPosition, double differenceSunAndLocalTime)
  {
    int sunRise = (int)(720.0 - 720.0 / Math.PI * Math.acos(-tanSunPosition) - differenceSunAndLocalTime);
    sunRise = LimitSunRise(sunRise);
    return sunRise;
  }


  private int CalculateSunSetInternal(double tanSunPosition, double differenceSunAndLocalTime)
  {
    int sunSet = (int)(720.0 + 720.0 / Math.PI * Math.acos(-tanSunPosition) - differenceSunAndLocalTime);
    sunSet = LimitSunSet(sunSet);
    return sunSet;
  }

  private double CalculateTanSunPosition(double declanationOfTheSun)
  {
    double sinSunPosition = CalculateSinSunPosition(declanationOfTheSun);
    double cosSunPosition = CalculateCosSunPosition(declanationOfTheSun);
    double tanSunPosition = sinSunPosition / cosSunPosition;
    tanSunPosition = LimitTanSunPosition(tanSunPosition);
    return tanSunPosition;
  }

  private double CalculateCosSunPosition(double declanationOfTheSun)
  {
    return Math.cos(latituteInRadians) * Math.cos(declanationOfTheSun);
  }

  private double CalculateSinSunPosition(double declanationOfTheSun)
  {
    return Math.sin(latituteInRadians) * Math.sin(declanationOfTheSun);
  }

  private double CalculateDifferenceSunAndLocalTime(int dayNumberOfDateTime)
  {
    double ellipticalOrbitPart1 = 7.95204 * Math.sin((0.01768 * dayNumberOfDateTime) + 3.03217);
    double ellipticalOrbitPart2 = 9.98906 * Math.sin((0.03383 * dayNumberOfDateTime) + 3.46870);

    double differenceSunAndLocalTime = ellipticalOrbitPart1 + ellipticalOrbitPart2 + (longitude - longituteTimeZone) * 4;

    if (useSummerTime)
      differenceSunAndLocalTime -= 60;
    return differenceSunAndLocalTime;
  }

  private double LimitTanSunPosition(double tanSunPosition)
  {
    if (((int)tanSunPosition) < -1)
    {
      tanSunPosition = -1.0;
    }
    if (((int)tanSunPosition) > 1)
    {
      tanSunPosition = 1.0;
    }
    return tanSunPosition;
  }

  private int LimitSunSet(int sunSet)
  {
    if (sunSet > 1439)
    {
      sunSet -= 1439;
    }
    return sunSet;
  }

  private int LimitSunRise(int sunRise)
  {
    if (sunRise < 0)
    {
      sunRise += 1440;
    }
    return sunRise;
  }

  private double CalculateMaximumSolarRadiationInternal(double sinSunHeight, double sunCorrection)
  {
    double maximumSolarRadiation;
    if ((sinSunHeight > 0.0) && MathEx.Abs(0.25 / sinSunHeight) < 50.0)
    {
      maximumSolarRadiation = sunCorrection * sinSunHeight * MathEx.Exp(-0.25 / sinSunHeight);
    } else
    {
      maximumSolarRadiation = 0;
    }
    return maximumSolarRadiation;
  }

  private int GetNumberOfMinutesThisDay(LocalDateTime dateTime, double differenceSunAndLocalTime)
  {
    return dateTime.getHour() * 60 + dateTime.getMinute() + (int)differenceSunAndLocalTime;
  }
}