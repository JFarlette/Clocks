public enum WindowPosition
{
  UL(0), UR(1), LL(2), LR(3), Count(4), All(4);
  
  private WindowPosition(int v)
  {
    value = v;
  }
  private final int value;
  public int getValue()
  { return value; }
} 
  
class Window
{
  Window(WindowPosition wp, int bp, IDrawable c)
  {
    windowPosition = wp;
    buttonPercentage = bp;
    content = c;
  }
  
  int buttonPercentage = 5;
  WindowPosition windowPosition;
  
  IDrawable content;
  
  int originX, originY, winWidth, winHeight;
  
  
  void draw(int x, int y, int w, int h)
  { 
    originX = x;
    originY = y;
    winWidth = w;
    winHeight = h;
    
    pushStyle();
    clip(originX, originY, originX+winWidth, originY+winHeight);
    
    
    // draw the content
    content.draw(x, y, w, h);
    
    
    popStyle();
  }
  
 
  
  
  
 
  
}