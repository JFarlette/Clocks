class Clock3B implements IDrawable
{
  int hourMode = HOUR_MODE_24;
  int clockMode = CLOCK_MODE_REGULAR;
  int colorMode = COLOR_MODE_WHITEONBLACK;
  
   ITimeSource timeSource;

  int bgColor = 0;
  int fgColor = 0;

  Clock3B(int aHrMode, int aClockMode, int aColorMode, ITimeSource ts)
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

  void drawHand(float handAngleInDeg, int handLength, int tailLength, int handWidth)
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
      // Draw a single line
      line(0, 0, tipX, tipY);
      line(0, 0, tailX, tailY);
    } else
    {
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

  void drawHourClock(int hourMode, int hr, int min, int sec, int milli, int hourRadius)
  {
    pushMatrix();
    pushStyle();
    float hrangleincdeg = 360/hourMode;

    // For 12 hour rotate the coordianates -90 so the 0 degress is up
    // For 24 hour rotate 90 so the 0 degrees is down
    rotate(hourMode == 12 ? -NinetyDegInRad : NinetyDegInRad);

    int textSizeDiv_Min = 9;
    int textSizeDiv_Max = 25;

    int hourtextradius = hourRadius - hourRadius/10;
    // ellipse(0, 0, hourtextradius*2, hourtextradius*2);
    
    int hrTextSize = hourRadius / textSizeDiv_Max;
    // Display the hour dots and numbers
    for (int i = 0; i < hourMode; i++)
    {
      int tempHrTextRadius = hourtextradius;
      int tempHrTextSize = hrTextSize;

      if (min == 59 && sec == 59)
      {
        if (isCurrentHr(i, hr, hourMode))
        {
          tempHrTextSize = hourRadius / int(map(milli, 0, 1000, textSizeDiv_Min, textSizeDiv_Max));
        } else if (isNextHr(i, hr, hourMode))
        {
          tempHrTextSize = hourRadius / int(map(milli, 0, 1000, textSizeDiv_Max, textSizeDiv_Min));
        }   
      }
      else if (i == hr%hourMode)
      {
        tempHrTextSize = hourRadius/textSizeDiv_Min;
      }

      float hrangledeg = i * hrangleincdeg;
      float hranglerad = radians(hrangledeg);

      // Calc the point where the hour number should go
      float txtpointx = tempHrTextRadius * cos(hranglerad);
      float txtpointy = tempHrTextRadius * sin(hranglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      rotate(hourMode == 12 ? NinetyDegInRad : -NinetyDegInRad);
      fill(fgColor);
      String s = str(i == 0 ? hourMode : i);
      textSize(tempHrTextSize);
      float swidth = textWidth(s);
      text(s, -swidth/2, tempHrTextSize/2);
      popMatrix();
    }

    // Hour hand
    int hrHandLength = hourRadius/10*4;
    int hrTailLength = hourRadius/20;  
    stroke(fgColor);
    fill(colorMode == COLOR_MODE_BLACKONWHITE ? White : Black);
    float hrHandAngleInDeg = 0;
    if (min == 59 && sec == 59)
    {
      hrHandAngleInDeg = hr * hrangleincdeg + hrangleincdeg/1000 * milli;
    }
    else
    {
      hrHandAngleInDeg = hr * hrangleincdeg;
    }
    drawHand(hrHandAngleInDeg, hrHandLength, hrTailLength, hourRadius/40);
    fill(bgColor);

    popStyle();
    popMatrix();
  }

  void drawMinClock(int min, int sec, int milli, int minRadius)
  {
    pushMatrix();

    float minAngleIncDeg = 360/60;

    // rotate coordinates -90 so 0 degrees is up
    rotate(-NinetyDegInRad);

    int minTextSizeDiv_Min = 10;
    int minTextSizeDiv_Max = 26;

    int textSize = minRadius / minTextSizeDiv_Max;
    int minTextRadius = minRadius - minRadius/10;
    
    // ellipse(0, 0, minTextRadius*2, minTextRadius*2);

    // Draw the dial
    for (int i = 0; i < 60; i++)
    {
      float angledeg = i * minAngleIncDeg;
      float anglerad = radians(angledeg);

      int tempTextSize = textSize;

      if (sec == 59)
      {
        if (i == min)
        {
          tempTextSize = minRadius / int(map(milli, 0, 1000, minTextSizeDiv_Min, minTextSizeDiv_Max));
        } else if (isNextIncrement(i, min, 59))
        {
          tempTextSize = minRadius / int(map(milli, 0, 1000, minTextSizeDiv_Max, minTextSizeDiv_Min));
        }  
      }
      else
      {
        if (i == min)
        {
         tempTextSize = minRadius / minTextSizeDiv_Min;
        }
      }

      // Draw the numbers
      float txtpointx = minTextRadius * cos(anglerad);
      float txtpointy = minTextRadius * sin(anglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      rotate(NinetyDegInRad);
      fill(fgColor);
      String s = str(i);
      textSize(tempTextSize);
      float swidth = textWidth(s);
      text(s, -swidth/2, tempTextSize/2);
      popMatrix();
    }  

    // Min hand
    int minHandLength = minRadius/10*6;
    int minHandTailLenght = minRadius/20;
    fill(colorMode == COLOR_MODE_BLACKONWHITE ? White : Black);
    float minHandAngleInDeg;
    if (sec == 59)
    {
      minHandAngleInDeg = (min * minAngleIncDeg) + (minAngleIncDeg/1000 * milli);
    }
    else
    {  
      minHandAngleInDeg = (min * minAngleIncDeg);
    }
    drawHand(minHandAngleInDeg, minHandLength, minHandTailLenght, minRadius/40);

    fill(bgColor);
    popMatrix();
  }

  void drawSecClock(int min, int sec, int milli, int secRadius)
  {
    pushMatrix();

    float secAngleIncDeg = 360/60;

    // rotate coordinates -90 so 0 degrees is up
    rotate(-NinetyDegInRad);

    int secTextSizeDiv_Min = 10;
    int secTextSizeDiv_Max = 26;

    int textSize = secRadius / secTextSizeDiv_Max;
    int secTextRadius = secRadius - secRadius/10;
    
    // ellipse(0, 0, secTextRadius*2, secTextRadius*2);

    // Draw the dial
    for (int i = 0; i < 60; i++)
    {
      float angledeg = i * secAngleIncDeg;
      float anglerad = radians(angledeg);

      int tempTextSize = textSize;

      if (i == sec)
      {
        tempTextSize = secRadius / int(map(milli, 0, 999, secTextSizeDiv_Min, secTextSizeDiv_Max));
      } 
      else if (isNextIncrement(i, sec, 59))
      {
        tempTextSize = secRadius / int(map(milli, 0, 999, secTextSizeDiv_Max, secTextSizeDiv_Min));
      }

      // Draw the min/sec number
      float txtpointx = secTextRadius * cos(anglerad);
      float txtpointy = secTextRadius * sin(anglerad);

      pushMatrix();
      translate(txtpointx, txtpointy);
      //rotate(anglerad+NinetyDegInRad);
      rotate(NinetyDegInRad);
      fill(fgColor);
      String s = str(i);
      textSize(tempTextSize);
      float swidth = textWidth(s);
      text(s, -swidth/2, tempTextSize/2);
      popMatrix();
    }  

    // Sec hand
    int secHandLength = secRadius/10*9;
    int secHandTailLength = secRadius/20;
    fill(colorMode == COLOR_MODE_BLACKONWHITE ? White : Black);
    float secHandAngleInDeg = sec * secAngleIncDeg + (secAngleIncDeg/1000 * milli);
    drawHand(secHandAngleInDeg, secHandLength, secHandTailLength, 0); // secRadius/50);        

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

    translate(centerx, centery);

    // diameter is the clock face diameter
    int diameter = min(windowWidth, windowHeight)/10*9;

    // draw the main circle
    ellipse(0, 0, diameter, diameter);

    // from the diameter determine the radius for the different parts of the face
    int hourRadius = diameter/2;
    int minRadius = hourRadius - (hourRadius/30*5);
    int secRadius = hourRadius - (hourRadius/30*9);

    drawHourClock(hourMode, hr, min, sec, milli, hourRadius);
    drawMinClock(min, sec, milli, minRadius);
    drawSecClock(min, sec, milli, secRadius);

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