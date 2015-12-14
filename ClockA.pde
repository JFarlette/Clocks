// Clock capable of showing either 12 or 24 hour modes //<>//
// 24 hour mode can display sunrise and sunset

class ClockA implements IDrawable
{
  int hourMode = HOUR_MODE_24;
  int clockMode = CLOCK_MODE_REGULAR;
  int colorMode = COLOR_MODE_WHITEONBLACK;

  int bgColor = 0;
  int fgColor = 0;

  ITimeSource timeSource;

  boolean sunRiseSetMode = true;
  SunCalculator sunCalc = null;
  LocalDateTime sunRise = null;
  LocalDateTime sunSet = null;

  LocalDateTime currentDate = null;

  ClockA(int aHrMode, int aClockMode, int aColorMode, ITimeSource ts, SunCalculator sc)
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
    sunCalc = sc;
  }

  void setCurrentDate(LocalDateTime date)
  {
    currentDate = date;   
    if (sunCalc != null)
    {
      sunRise = sunCalc.CalculateSunRise(currentDate);
      sunSet = sunCalc.CalculateSunSet(currentDate);
    }
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

  void drawHand(float handAngleInDeg, int handLength, int tailLength, int handWidth, int fgColor, int bgColor)
  {
    float handAngleInRad = radians(handAngleInDeg);

    // Tip
    float tipX = handLength * cos(handAngleInRad);
    float tipY = handLength * sin(handAngleInRad);

    // Tail
    float tailX = tailLength * cos(handAngleInRad+PI);
    float tailY = tailLength * sin(handAngleInRad+PI);

    if (handWidth <= 0)
    {
      //fill(bgColor);
      stroke(fgColor);
      // Draw a single line
      line(0, 0, tipX, tipY);
      line(0, 0, tailX, tailY);
    } else
    {
      fill(fgColor);
      stroke(bgColor);
      
      // Draw an diamond shaped polygon
      float side1X = handWidth * cos(handAngleInRad+HALF_PI);
      float side1Y = handWidth * sin(handAngleInRad+HALF_PI);

      float side2X = handWidth * cos(handAngleInRad-HALF_PI);
      float side2Y = handWidth * sin(handAngleInRad-HALF_PI);

      beginShape();
      vertex(tipX, tipY);
      vertex(side1X, side1Y);
      vertex(tailX, tailY);
      vertex(side2X, side2Y);
      endShape(CLOSE);
    }
  }

  void drawHourClock(int hourMode, int hr, int min, int sec, int hrRadius)
  {
    pushMatrix();
    pushStyle();
    // For 12 hour rotate the coordianates -90 so the 0 degress is up
    // For 24 hour rotate 90 so the 0 degrees is down
    rotate(hourMode == 12 ? -NinetyDegInRad : NinetyDegInRad);

    int hrTextRadius = hrRadius - hrRadius/14;

    // Display the hour dots and numbers
    int textSize = hrRadius/16;
    textSize(textSize);
    float hrangleincdeg = 360/hourMode;
    for (int i = 0; i < hourMode; i++)
    {
      float hrangledeg = i * hrangleincdeg;
      float hranglerad = radians(hrangledeg);
      float dotpointx = hrRadius * cos(hranglerad);
      float dotpointy = hrRadius * sin(hranglerad);

      fill(bgColor);
      stroke(fgColor);

      if (isCurrentHr(i, hr, hourMode))
      {
        if (bgColor == White)
        {
          int c = int(map(min, 0, 59, 0, 255));
          fill(c, 255, c);
        } else
        {
          int c = int(map(min, 0, 59, 255, 0));
          fill(bgColor, c, bgColor);
        }
      } else if (isNextHr(i, hr, hourMode))
      {
        if (bgColor == White)
        {
          int c = int(map(min, 0, 59, 255, 0));
          fill(c, 255, c);
        } else 
        {
          int c = int(map(min, 0, 59, 0, 255));
          fill(bgColor, c, bgColor);
        }
      }

      ellipse(dotpointx, dotpointy, hrRadius/35, hrRadius/35);

      // Draw the hour number
      float txtpointx = hrTextRadius * cos(hranglerad);
      float txtpointy = hrTextRadius * sin(hranglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      rotate(hourMode == 12 ? NinetyDegInRad : -NinetyDegInRad);
      fill(fgColor);
      String s = str(i == 0 ? hourMode : i);
      float swidth = textWidth(s);
      text(s, -(swidth/2), (textSize/2));
      popMatrix();
    }

    if (hourMode == HOUR_MODE_24 && sunRiseSetMode)
    {
      int w1 = hrRadius+(hrRadius/10*2);
      int w2 = hrRadius+(hrRadius/10*1);
      if (colorMode == COLOR_MODE_WHITEONBLACK)
      {
        int sunRiseMinutes = sunRise.getHour()*60+sunRise.getMinute();
        int sunSetMinutes = sunSet.getHour()*60+sunSet.getMinute();
        float sunRiseRad = map(sunRiseMinutes, 0, 24*60, 0, 2*PI);
        float sunSetRad = map(sunSetMinutes, 0, 24*60, 0, 2*PI);

        // draw a yellow arc on the top representing sun up period
        fill(255, 255, 0);
        arc(0, 0, w1, w1, sunRiseRad, sunSetRad);
        fill(bgColor);
        arc(0, 0, w2, w2, sunRiseRad, sunSetRad);
      } else
      {
        int sunSetMinutes = sunSet.getHour()*60+sunSet.getMinute();
        int sunRiseMinutes = sunRise.getHour()*60+sunRise.getMinute();
        float sunSetRad = map(sunSetMinutes, 0, 24*60, 0, 2*PI);
        float sunRiseRad = map(sunRiseMinutes, 0, 24*60, 0, 2*PI);
        float sunDownRad = 2*PI-sunSetRad+sunRiseRad;

        // draw a black arc on the bottom representing sun down period
        fill(0);
        arc(0, 0, w1, w1, sunSetRad, sunSetRad+sunDownRad);
        fill(bgColor);
        arc(0, 0, w2, w2, sunSetRad, sunSetRad+sunDownRad);
      }
    }

    drawDate(hrRadius);

    // Hour hand
    int hrHandLength = hrRadius/10*5;
    int hrTailLength = hrRadius/20;  
    //stroke(bgColor);
    //fill(colorMode == COLOR_MODE_BLACKONWHITE ? Black : White);
    float hrHandAngleInDeg = hr * hrangleincdeg + (hrangleincdeg/3600 * (min * 60 + sec));
    drawHand(hrHandAngleInDeg, hrHandLength, hrTailLength, hrRadius/40, fgColor, bgColor);
    fill(bgColor);

    popStyle();
    popMatrix();
  }

  void drawDate(int radius)
  {
    pushMatrix();
    rotate(hourMode == HOUR_MODE_24 ? NinetyDegInRad+PI : NinetyDegInRad);
    fill(bgColor);
    int textSize = radius/12;
    textSize(textSize);
    String s = currentDate.getMonth().toString() + " " + str(currentDate.getDayOfMonth());
    float swidth = textWidth("SEPTEMBER 31");  // so the box size doesn't change
    float boxwidth = swidth + (swidth/4);
    float boxheight = textSize + (textSize/3);

    int offset = radius/4;
    int br = radius/30;

    fill(128);
    rect(-boxwidth/2, -(offset+(offset/5)), boxwidth, boxheight, br, br, br, br );

    fill(bgColor);
    swidth = textWidth(s);  
    text(s, -(swidth/2), (textSize/2)-offset);

    s = str(currentDate.getYear());
    swidth = textWidth(s);

    boxwidth = swidth + (swidth/4);
    boxheight = textSize + (textSize/4);
    fill(128);
    rect(-boxwidth/2, offset+(offset/4)-boxheight, boxwidth, boxheight, br, br, br, br );
    fill(bgColor);
    text(s, -(swidth/2), (textSize/2)+offset);

    popMatrix();
  }

  void drawMinSecClock(int min, int sec, int milli, int minsecradius)
  {
    pushMatrix();
    // rotate coordinates -90 so 0 degrees is up
    rotate(-NinetyDegInRad); 
    int minsectextradius = minsecradius - minsecradius/10;

    // Draw the 60 minute/second dial
    int textSize = minsecradius/18;
    textSize(textSize);
    float secminangleincdeg = 360/60;
    for (int i = 0; i < 60; i++)
    {
      float angledeg = i * secminangleincdeg;
      float anglerad = radians(angledeg);
      float dotpointx = minsecradius * cos(anglerad);
      float dotpointy = minsecradius * sin(anglerad);
      fill(bgColor);

      if (i == min)
      {
        if (bgColor == White)
        {
          int c = int(map(sec, 0, 59, 0, 255));
          fill(c, c, 255);
        } else
        {
          int c = int(map(sec, 0, 59, 255, 0));
          fill(bgColor, bgColor, c);
        }
      } else if (isNextIncrement(i, min, 59))
      {
        if (bgColor == White)
        {
          int c = int(map(sec, 0, 59, 255, 0));
          fill(c, c, 255);
        } else 
        {
          int c = int(map(sec, 0, 59, 0, 255));
          fill(bgColor, bgColor, c);
        }
      }

      if (i == sec)
      {
        if (bgColor == White)
        {
          int c = int(map(milli, 0, 999, 0, 255));
          fill(255, c, c);
        } else
        {
          int c = int(map(milli, 0, 999, 255, 0));
          fill(c, bgColor, bgColor);
        }
      } else if (isNextIncrement(i, sec, 59))
      {
        if (bgColor == White)
        {
          int c = int(map(milli, 0, 999, 255, 0));
          fill(255, c, c);
        } else
        {
          int c = int(map(milli, 0, 999, 0, 255));
          fill(c, bgColor, bgColor);
        }
      }
      ellipse(dotpointx, dotpointy, minsecradius/35, minsecradius/35);

      if (i % 5 == 0)
      {
        // Draw the min/sec number
        float txtpointx = minsectextradius * cos(anglerad);
        float txtpointy = minsectextradius * sin(anglerad);

        pushMatrix();
        translate(txtpointx, txtpointy);
        rotate(NinetyDegInRad);
        fill(fgColor);
        String s = str(i);
        float swidth = textWidth(s);
        text(s, -(swidth/2), (textSize/2));
        popMatrix();
      }
    }  

    // Min hand
    //stroke(bgColor);
    int minHandLength = minsecradius/10*8;
    int minHandTailLenght = minsecradius/20;
    //fill(colorMode == COLOR_MODE_BLACKONWHITE ? Black : White);
    float minHandAngleInDeg = (min * secminangleincdeg) + (secminangleincdeg/60 * sec);
    drawHand(minHandAngleInDeg, minHandLength, minHandTailLenght, minsecradius/40, fgColor, bgColor);

    // Sec hand
    //stroke(fgColor);
    int secHandLength = minsecradius/10*9;
    int secHandTailLength = minsecradius/20;
    //fill(colorMode == COLOR_MODE_BLACKONWHITE ? Black : White);
    float secHandAngleInDeg = sec * secminangleincdeg + (secminangleincdeg/1000 * milli);
    drawHand(secHandAngleInDeg, secHandLength, secHandTailLength, 0, fgColor, bgColor); 

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
    int centerX = originX + (windowWidth/2);
    int centerY = originY + (windowHeight/2);
    translate(centerX, centerY);

    // diameter is the clock face diameter
    int diameter = min(windowWidth, windowHeight)/10*9;

    // draw the main circle
    ellipse(0, 0, diameter, diameter);

    // from the diameter determine the radius for the different parts of the face
    int hrRadius = diameter/2;
    int minsecradius = hrRadius - (hrRadius/30*5);

    drawHourClock(hourMode, hr, min, sec, hrRadius);
    drawMinSecClock(min, sec, milli, minsecradius);

    // draw the center point
    ellipse(0, 0, diameter/100, diameter/100);

    popStyle();
    popMatrix();
  }

  boolean isDateChanged(LocalDateTime now)
  {
    if (currentDate == null) return true;
    int doy = now.getDayOfYear();
    return doy > currentDate.getDayOfYear() || doy == 1 && doy < currentDate.getDayOfYear();
  }

  void draw(int originX, int originY, int width, int height)
  {
    LocalDateTime now = timeSource.getDateTime();
    if (isDateChanged(now))
    {
      setCurrentDate(now);
    }
    drawClock(originX, originY, width, height, hourMode, now.getHour(), now.getMinute(), now.getSecond(), now.getNano()/1000000);
  }
}