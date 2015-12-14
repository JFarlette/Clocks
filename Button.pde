class Button
{
  int buttonX;
  int buttonY;
  int size;
  boolean clicked = false;
  boolean expanded = false;
  
  WindowPosition windowPosition;
  
  public Button(WindowPosition wp)
  {
    windowPosition = wp;
  }
  
  boolean mouseOverRect(int x, int y, int width, int height)  
  {
    return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
  }
  
  void drawExpandIcon(int x, int y, int size)
  {
    int offset = size/5;
    
    // Two top hoizontal lines
    line(x+offset, y+offset, x+(offset*2), y+offset);  line(x+size-offset, y+offset, x+size-(offset*2), y+offset);
    
    // Two left vertical lines
    line(x+offset, y+offset, x+offset, y+(offset*2)); line(x+offset, y+size-offset, x+offset, y+size-(offset*2));
    
    // Two bottom horizontal lines
     line(x+offset, y+size-offset, x+(offset*2), y+size-offset);  line(x+size-offset, y+size-offset, x+size-(offset*2), y+size-offset);
     
     // Two right vertical lines
     line(x+size-offset, y+offset, x+size-offset, y+(offset*2)); line(x+size-offset, y+size-offset, x+size-offset, y+size-(offset*2));
  }
  
  void drawContractIcon(int x, int y, int size)
  {
    int offset = size/10;
    
    // Two top hoizontal lines
    line(x+offset, y+(offset*2), x+(offset*2), y+(offset*2));  line(x+size-offset, y+(offset*2), x+size-(offset*2), y+(offset*2));
    
    // Two left vertical lines
    line(x+(offset*2), y+offset, x+(offset*2), y+(offset*2)); line(x+(offset*2), y+size-offset, x+(offset*2), y+size-(offset*2));
    
    // Two bottom horizontal lines
     line(x+offset, y+size-(offset*2), x+(offset*2), y+size-(offset*2));  line(x+size-offset, y+size-(offset*2), x+size-(offset*2), y+size-(offset*2));
     
     // Two right vertical lines
     line(x+size-(offset*2), y+offset, x+size-(offset*2), y+(offset*2)); line(x+size-(offset*2), y+size-offset, x+size-(offset*2), y+size-(offset*2));
  }
  
  void draw(int x, int y, int w, int h)
  {
    pushStyle();
    size = buttonPercentage*Math.min(w, h)/100;
    if (windowPosition == WindowPosition.UL)
    {
      buttonX = x;
      buttonY = y;
    }
    else if (windowPosition == WindowPosition.UR)
    {
      buttonX = x+(w-size); //<>//
      buttonY = y;
    }
    else if (windowPosition == WindowPosition.LL)
    {
      buttonX = x;
      buttonY = y+h-size;
    }
    else if (windowPosition == WindowPosition.LR)
    {
      buttonX = x+w-size;
      buttonY = y+h-size;
    }
    int f = 128;
    int s = 255;
    if (mouseOver())
    {
      f = 0;
      s = #FFFF00;
    }
    fill(f);
    stroke(s);
    rect(buttonX, buttonY, size-1, size-1);
    if (expanded)
    {
      drawContractIcon(buttonX, buttonY, size);
    }
    else
    {
      drawExpandIcon(buttonX, buttonY, size);
    }
    popStyle();
  }
  
  boolean mouseOver()
  {
     return mouseOverRect(buttonX, buttonY, size, size);
    
  }
  
  void setModeExpanded()
  {
    expanded = true;
  }
  
  void setModeContracted()
  {
    expanded = false;
  }
}