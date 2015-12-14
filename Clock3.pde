// Clock composed of three faces.  
// Each face rotates so that the current time is always at the top of the clock.
// Numbers for current time at top of clock are enlarged/shrunk as they pass through the top position

class Clock3 implements IDrawable
{
  int hourMode = HOUR_MODE_24;
  int clockMode = CLOCK_MODE_REGULAR;
  int colorMode = COLOR_MODE_WHITEONBLACK;
  
  ITimeSource timeSource;

  int bgColor = 0;
  int fgColor = 0;

  Clock3(int aHrMode, int aClockMode, int aColorMode, ITimeSource ts)
  {
    hourMode = aHrMode;
    clockMode = aClockMode;
    colorMode = aColorMode;

    if (colorMode == COLOR_MODE_WHITEONBLACK)
    {
      fgColor = White;
      bgColor = Black;
    } else
    {
      fgColor = Black;
      bgColor = White;
    }
    timeSource = ts;
  }

  boolean isNextIncrement(int i, int current, int max)
  {
    return (i-1 == current) || (i == 0 && current == max);
  }

  boolean isCurrentHr(int hourIndex, int hr, int hrMode)
  {
    return hourIndex == (hr % hrMode);
  }

  boolean isNextHr(int hourIndex, int hr, int hrMode)
  {  
    return isNextIncrement(hourIndex, hr % hrMode, hrMode-1);
  }

  void drawHourClock(int hourMode, int hr, int min, int sec, int milli, int hourradius)
  {
    pushMatrix();
    pushStyle();
    float hrangleincdeg = 360/hourMode;
    float hrAngleInDeg = hr * hrangleincdeg;
    if (min == 59 && sec == 59)
    {
      hrAngleInDeg += (hrangleincdeg/1000 * milli);
    }
    float hrAngleInRad = radians(hrAngleInDeg);
    // For 12 hour rotate the coordianates -90 so the 0 degress is up
    // For 24 hour rotate 90 so the 0 degrees is down
    rotate(hourMode == 12 ? -NinetyDegInRad - hrAngleInRad : -NinetyDegInRad - hrAngleInRad);
    
    int textSizeDiv_Min = 9;
    int textSizeDiv_Max = 25;

    int hourtextradius = hourradius - hourradius/10;
    int hrTextSize = hourradius / textSizeDiv_Max;
    // Display the hours dial
    for (int i = 0; i < hourMode; i++)
    {
      int tempHrTextRadius = hourtextradius;
      int tempHrTextSize = hrTextSize;
      
     
      if (min == 59 && sec == 59)
      {
        if (isCurrentHr(i, hr, hourMode))
        {
           tempHrTextSize = hourradius / int(map(milli, 0, 999, textSizeDiv_Min, textSizeDiv_Max));
           tempHrTextRadius -= (tempHrTextSize - hrTextSize)/2;
        }
        else if (isNextHr(i, hr, hourMode))
        {
          tempHrTextSize = hourradius / int(map(milli, 0, 999, textSizeDiv_Max, textSizeDiv_Min));
          tempHrTextRadius -= (tempHrTextSize - hrTextSize)/2;
        }   
      }
      else if (i == hr%hourMode)
      {
        tempHrTextSize = hourradius/textSizeDiv_Min;
        tempHrTextRadius -= ((tempHrTextSize - hrTextSize)/2);
      }
      
      float hrangledeg = i * hrangleincdeg;
      float hranglerad = radians(hrangledeg);

      // Calc the point where the hour number should go
      float txtpointx = tempHrTextRadius * cos(hranglerad);
      float txtpointy = tempHrTextRadius * sin(hranglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      rotate(hranglerad+NinetyDegInRad);
      fill(fgColor);
      String s = str(i == 0 ? hourMode : i);
      textSize(tempHrTextSize);
      float swidth = textWidth(s);
      text(s, -(swidth/2), 0);
      popMatrix();
    }
   
    popStyle();
    popMatrix();
  }

 void drawMinClock(int min, int sec, int milli, int minsecradius)
  {
    pushMatrix();
    
    // draw the main circle
    ellipse(0, 0, minsecradius*2, minsecradius*2);
    
    float secminangleincdeg = 360/60;
    float minangledeg = min * secminangleincdeg;
    if (sec == 59)
    {
      minangledeg += secminangleincdeg/1000 * milli;
    }

    float minanglerad = radians(minangledeg);

    // Rotate the clock so the current value is always up
    // rotate coordinates -90 so 0 degrees is up
    rotate(-NinetyDegInRad-minanglerad); 

    int secTextSizeDiv_Min = 10;
    int secTextSizeDiv_Max = 26;

    int textSize = minsecradius / secTextSizeDiv_Max;
    int minsectextradius = minsecradius - minsecradius/10;

    // Draw the minute dial
    for (int i = 0; i < 60; i++)
    {
      float angledeg = i * secminangleincdeg;
      float anglerad = radians(angledeg);
      
      int tempTextSize = textSize;
      int tempTextRadius = minsectextradius;
      
      if (sec == 59)
      {
        if (i == min)
        {
           tempTextSize = minsecradius / int(map(milli,0,999,secTextSizeDiv_Min, secTextSizeDiv_Max));
           tempTextRadius -= (tempTextSize - textSize)/2;
        }
        else if (isNextIncrement(i, min, 59))
        {
          tempTextSize = minsecradius / int(map(milli,0, 999, secTextSizeDiv_Max,secTextSizeDiv_Min));
          tempTextRadius -= (tempTextSize - textSize)/2;
        }   
      }
      else
      {
        if (i == min)
        {
           tempTextSize = minsecradius / secTextSizeDiv_Min;
           tempTextRadius -= (tempTextSize - textSize)/2;
        }
      }
      
      // Draw the numbers
      float txtpointx = tempTextRadius * cos(anglerad);
      float txtpointy = tempTextRadius * sin(anglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      rotate(anglerad+NinetyDegInRad);
      fill(fgColor);
      String s = str(i);
      textSize(tempTextSize);
      float swidth = textWidth(s);
      text(s, -(swidth/2), 0);
      popMatrix();
    }  

    fill(bgColor);
    popMatrix();
  }
  
  void drawSecClock(int min, int sec, int milli, int minsecradius)
  {
    pushMatrix();
    
     // draw the main circle
    ellipse(0, 0, minsecradius*2, minsecradius*2);
    
    float secminangleincdeg = 360/60;
    float secangledeg = sec * secminangleincdeg + (secminangleincdeg/1000 * milli);

    float secanglerad = radians(secangledeg);

    // Rotate the clock so the current value is always up
    // rotate coordinates -90 so 0 degrees is up
    rotate(-NinetyDegInRad-secanglerad); 

    int secTextSizeDiv_Min = 10;
    int secTextSizeDiv_Max = 26;

    int textSize = minsecradius / secTextSizeDiv_Max;
    int minsectextradius = minsecradius - minsecradius/10;
        
    // Draw the dial
    for (int i = 0; i < 60; i++)
    {
      float angledeg = i * secminangleincdeg;
      float anglerad = radians(angledeg);
      
      int tempTextSize = textSize;
      int tempTextRadius = minsectextradius;
      
      if (i == sec)
      {
         tempTextSize = minsecradius / int(map(milli,0,999,secTextSizeDiv_Min, secTextSizeDiv_Max));
         tempTextRadius -= (tempTextSize - textSize)/2;
      }
      else if (isNextIncrement(i, sec, 59))
      {
        tempTextSize = minsecradius / int(map(milli,0, 999, secTextSizeDiv_Max,secTextSizeDiv_Min));
        tempTextRadius -= (tempTextSize - textSize)/2;
      }
      
      // Draw the min/sec number
      float txtpointx = tempTextRadius * cos(anglerad);
      float txtpointy = tempTextRadius * sin(anglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      rotate(anglerad+NinetyDegInRad);
      fill(fgColor);
      String s = str(i);
      textSize(tempTextSize);
      float swidth = textWidth(s);
      text(s, -(swidth/2), 0);
      popMatrix();
    }  

    fill(bgColor);
    popMatrix();
  }

  void drawClock(int originX, int originY, int windowWidth, int windowHeight, int hourMode, int hr, int min, int sec, int milli)
  {
    pushMatrix();
    pushStyle();
    clip(originX, originY, originX+windowWidth, originY+windowHeight);

    stroke(fgColor);
    fill(bgColor);
    rect(originX, originY, originX+windowWidth-1, originY+windowHeight-1);

    // Set the origin to the cener of the window
    int centerx = originX + (windowWidth/2);
    int centery = originY + (windowHeight/2);
    //int centerx = originX + (windowWidth/2);
    //int centery = originY + (windowHeight + (windowHeight/10*14));

    translate(centerx, centery);

    // diameter is the clock face diameter
    int diameter = min(windowWidth, windowHeight)/10*9;
    //int diameter = min(windowWidth, windowHeight)*4;

    // draw the main circle
    ellipse(0, 0, diameter, diameter);

    // from the diameter determine the radius for the different parts of the face
    int hourradius = diameter/2;
    int minradius = hourradius - (hourradius/30*5);
    int secradius = hourradius - (hourradius/30*9);

    drawHourClock(hourMode, hr, min, sec, milli, hourradius);
    // drawMinSecClock(min, sec, milli, minsecradius);
    drawMinClock(min, sec, milli, minradius);
    drawSecClock(min, sec, milli, secradius);

    // draw the center point
    ellipse(0, 0, diameter/100, diameter/100);

    popStyle();
    popMatrix();
  }

  void draw(int originX, int originY, int clockWidth, int clockHeight)
  {
    LocalDateTime now = timeSource.getDateTime();
    drawClock(originX, originY, clockWidth, clockHeight, hourMode, now.getHour(), now.getMinute(), now.getSecond(), now.getNano()/1000000);
  }
}