
  
 enum DisplayTransition
 {
   Expanding,
   Contracting,
   None
 };

int TransitionTimeInMS = 1000;

class WindowController
{
  
  WindowPosition displayMode = WindowPosition.All;
  WindowPosition targetDisplayMode = WindowPosition.All;
  DisplayTransition displayTransition = DisplayTransition.None;
  int transitionFrames = 0;
  int transitionFrameCounter = 0;
  
  Window windows[] = new Window[WindowPosition.Count.getValue()]; 
  Button buttons[] = new Button[WindowPosition.Count.getValue()];
    
  WindowController(Window ul, Window ur, Window ll, Window lr)
  {    
    windows[WindowPosition.UL.getValue()] = ul;
    buttons[WindowPosition.UL.getValue()] = new Button(WindowPosition.UL);
    
    windows[WindowPosition.UR.getValue()] = ur;
    buttons[WindowPosition.UR.getValue()] = new Button(WindowPosition.UR);
    
    windows[WindowPosition.LL.getValue()] = ll;
    buttons[WindowPosition.LL.getValue()] = new Button(WindowPosition.LL);
    
    windows[WindowPosition.LR.getValue()] = lr;
    buttons[WindowPosition.LR.getValue()] = new Button(WindowPosition.LR);
    
  }
  
  void draw(int x, int y, int w, int h)
  {
    if (displayTransition == DisplayTransition.None)
    {
      if (displayMode == WindowPosition.All)
      {
        windows[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        buttons[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        windows[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        buttons[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        windows[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        buttons[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        windows[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);
        buttons[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);
      }
      else if (displayMode == WindowPosition.UL)
      {
        windows[WindowPosition.UL.getValue()].draw(0, 0, w, h);
        buttons[WindowPosition.UL.getValue()].draw(0, 0, w, h);
      }
      else if (displayMode == WindowPosition.UR)
      {
        windows[WindowPosition.UR.getValue()].draw(0, 0, w, h);
        buttons[WindowPosition.UR.getValue()].draw(0, 0, w, h);
      }
      else if (displayMode == WindowPosition.LL)
      {
        windows[WindowPosition.LL.getValue()].draw(0, 0, w, h);
        buttons[WindowPosition.LL.getValue()].draw(0, 0, w, h);
      }
      else if (displayMode == WindowPosition.LR)
      {
        windows[WindowPosition.LR.getValue()].draw(0, 0, w, h);
        buttons[WindowPosition.LR.getValue()].draw(0, 0, w, h);
      }
    }
    else // Expanding or Contracting 
    {
      if (transitionFrames == 0 && transitionFrameCounter == 0)
      {
        transitionFrames = (int)(TransitionTimeInMS / (1000.0 / frameRate));
      }
      
      int windowW = 0;
      int windowH = 0;
      WindowPosition dm = WindowPosition.All;
      if (displayTransition == DisplayTransition.Expanding)
      {
        windowW = (int)map(transitionFrameCounter, 0, transitionFrames, w/2, w);
        windowH = (int)map(transitionFrameCounter, 0, transitionFrames, h/2, h);
        
        dm = targetDisplayMode;
      }
      else // DisplayTransition.Contracting 
      {
        windowW = (int)map(transitionFrameCounter, 0, transitionFrames, w, w/2);
        windowH = (int)map(transitionFrameCounter, 0, transitionFrames, h, h/2);
        
        dm = displayMode;
      }
      
      if (dm == WindowPosition.UL)
      {
        windows[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        buttons[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        windows[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        buttons[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        windows[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);
        buttons[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);
        
        windows[WindowPosition.UL.getValue()].draw(0, 0, windowW, windowH);
        buttons[WindowPosition.UL.getValue()].draw(0, 0, windowW, windowH);   
      }
      else if (dm == WindowPosition.UR)
      {
        windows[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        buttons[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        windows[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        buttons[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        windows[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);
        buttons[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);

        windows[WindowPosition.UR.getValue()].draw(width-windowW, 0, windowW, windowH);
        buttons[WindowPosition.UR.getValue()].draw(width-windowW, 0, windowW, windowH);
      }
      else if (dm == WindowPosition.LL)
      {
        windows[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        buttons[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        windows[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        buttons[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        windows[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);
        buttons[WindowPosition.LR.getValue()].draw(w/2, h/2, w/2, h/2);

        windows[WindowPosition.LL.getValue()].draw(0, height-windowH, windowW, windowH);
        buttons[WindowPosition.LL.getValue()].draw(0, height-windowH, windowW, windowH);
      }
      else if (dm == WindowPosition.LR)
      {
        windows[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        buttons[WindowPosition.UL.getValue()].draw(x, y, w/2, h/2);
        windows[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        buttons[WindowPosition.UR.getValue()].draw(w/2, 0, w/2, h/2);
        windows[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);
        buttons[WindowPosition.LL.getValue()].draw(0, h/2, w/2, h/2);

        windows[WindowPosition.LR.getValue()].draw(width-windowW, height-windowH, windowW, windowH);
        buttons[WindowPosition.LR.getValue()].draw(width-windowW, height-windowH, windowW, windowH);
      }
        
      transitionFrameCounter += 1;
      
      if (transitionFrameCounter >= transitionFrames)
      {
        if (displayTransition == DisplayTransition.Contracting)
        {
          buttons[displayMode.getValue()].setModeContracted();
        }
        else // Expanding
        {
          buttons[targetDisplayMode.getValue()].setModeExpanded();
        }
        
        displayTransition = DisplayTransition.None;
        displayMode = targetDisplayMode;
      }
    }
  }

  void mouseClicked()
  {
    if (displayTransition == DisplayTransition.None)
    {
      if (displayMode == WindowPosition.All)
      {
        if (buttons[WindowPosition.UL.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.UL;
          displayTransition = DisplayTransition.Expanding;
        }
        else if (buttons[WindowPosition.UR.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.UR;
          displayTransition = DisplayTransition.Expanding;
        }
        else if (buttons[WindowPosition.LL.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.LL;
          displayTransition = DisplayTransition.Expanding;
        }
        else if (buttons[WindowPosition.LR.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.LR;
          displayTransition = DisplayTransition.Expanding;
        }
      }
      else if (displayMode == WindowPosition.UL)
      {
        if (buttons[WindowPosition.UL.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.All;
          displayTransition = DisplayTransition.Contracting;
        }
      }
      else if (displayMode == WindowPosition.UR)
      {
        if (buttons[WindowPosition.UR.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.All;
          displayTransition = DisplayTransition.Contracting;
        }
      }
      else if (displayMode == WindowPosition.LL)
      {
        if (buttons[WindowPosition.LL.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.All;
          displayTransition = DisplayTransition.Contracting;
        }
      }
      else if (displayMode == WindowPosition.LR)
      {
        if (buttons[WindowPosition.LR.getValue()].mouseOver())
        {
          targetDisplayMode = WindowPosition.All;
          displayTransition = DisplayTransition.Contracting;
        }
      }
      transitionFrames = 0;
      transitionFrameCounter = 0;
    }
  }
}