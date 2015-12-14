class TestTimeSource implements ITimeSource
{
  int year = 2015;
  int monthOfYear = 12;
  int dayOfMonth = 31;
  int hourOfDay = 0;
  int minOfHour = 0;
  int secOfMin = 0;
  int millisOfSec = 0;
  int milliIncrement;
  
  TestTimeSource(int yr, int m, int d, int hr, int min, int sec, int mi)
  {
    year = yr;
    monthOfYear = m;
    dayOfMonth = d;
    hourOfDay = hr;
    minOfHour = min;
    secOfMin = sec;
    milliIncrement = mi;
  }
  
  void IncrementTime()
  {
    // Advance the time counters by the milliIncrement amount
    millisOfSec += milliIncrement;
    if (millisOfSec >= 1000)
    {
      millisOfSec = 0;
      secOfMin += 1;
      if (secOfMin >= 60) 
      {
        secOfMin = 0;
        minOfHour += 1;
        if (minOfHour >= 60)
        {
          minOfHour = 0;
          hourOfDay += 1;
          if (hourOfDay >= 24) 
          {
            hourOfDay = 0;
            dayOfMonth += 1;
            if (dayOfMonth > 31)  // Need to fix this?
            {
              dayOfMonth = 1;
              monthOfYear += 1;
              if (monthOfYear > 12)
              {
                monthOfYear = 1;
                
                year += 1;
              }
            }
          }
        }
      }
    }
  }
  
  LocalDateTime getDateTime()
  {
    // Construct a LocalDateTime from the counters and return it
    LocalDateTime t = LocalDateTime.of(year, monthOfYear, dayOfMonth, hourOfDay, minOfHour, secOfMin, millisOfSec*1000000);
    IncrementTime();
    return t;
  }
}