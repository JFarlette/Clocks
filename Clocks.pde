/****************************************************************** //<>//
 Draws some different clocks - either 4 at once or select each individually  
 using the buttons
 
 */
int HOUR_MODE_24 = 24;
int HOUR_MODE_12 = 12;
float NinetyDegInRad = HALF_PI;
int CLOCK_MODE_REGULAR = 1;
int CLOCK_MODE_TEST = 2;

int COLOR_MODE_WHITEONBLACK = 1;
int COLOR_MODE_BLACKONWHITE = 2;

int White = 255;
int Black = 0;

int FRAME_RATE = 30;

int RUN_MODE_REGULAR = 0;
int RUN_MODE_TEST = 1;
int RUN_MODE_FAST_TEST = 2;
int RUN_MODE = RUN_MODE_TEST;

// Assume some config for the sunrise and sunset calculations
double LATITUDE = 49.95121990866204;
double LONGITUDE = -122.16796875;
int UTC_OFFSET = -8;
boolean IS_DST_IN_EFFECT = false;
SunCalculator sc = new SunCalculator(LONGITUDE, LATITUDE, UTC_OFFSET * 15, IS_DST_IN_EFFECT);

boolean RECORD_FRAMES_ENABLED = true;
boolean RECORD_FRAMES = false;

int buttonPercentage = 5;
WindowController wc = null;

void setup() 
{
  surface.setResizable(true);
  frameRate(FRAME_RATE);
  
  ITimeSource its1 = null;
  ITimeSource its2 = null;
  ITimeSource its3 = null;
  ITimeSource its4 = null;
  
  if (RUN_MODE == RUN_MODE_TEST)
  {
    its1 = new RegularTestTimeSource(2016, 7, 28, 23, 59, 0);
    its2 = new RegularTestTimeSource(2015, 12, 31, 23, 59, 0);
    its3 = new RegularTestTimeSource(2015, 12, 31, 23, 59, 0);
    its4 = new RegularTestTimeSource(2015, 12, 31, 23, 59, 45);
  }
  else if (RUN_MODE == RUN_MODE_FAST_TEST)
  {
    its1 = new TestTimeSource(2016, 7, 28, 23, 59, 0, 1000);
    its2 = new TestTimeSource(2015, 12, 31, 23, 59, 0, 1000);
    its3 = new TestTimeSource(2015, 12, 31, 23, 59, 0, 1000);
    its4 = new TestTimeSource(2015, 12, 31, 23, 59, 0, 1000);
  }
  else
  {
    its1 = new SystemTimeSource();    
    its2 = new SystemTimeSource();
    its3 = new SystemTimeSource();
    its4 = new SystemTimeSource();
  }
  
  // Create four clocks each with a different configuration
  ClockA c1 = new ClockA(HOUR_MODE_24, CLOCK_MODE_REGULAR, COLOR_MODE_WHITEONBLACK, its1, sc);
  ClockA c2 = new ClockA(HOUR_MODE_24, CLOCK_MODE_REGULAR, COLOR_MODE_BLACKONWHITE, its2, sc);
  Clock3 c3 = new Clock3(HOUR_MODE_24, CLOCK_MODE_REGULAR, COLOR_MODE_WHITEONBLACK, its3);
  Clock3B c4 = new Clock3B(HOUR_MODE_12, CLOCK_MODE_REGULAR, COLOR_MODE_BLACKONWHITE, its4);
  

  Window ul = new Window(WindowPosition.UL, buttonPercentage, c1);
  Window ur = new Window(WindowPosition.UR, buttonPercentage, c2);
  Window ll = new Window(WindowPosition.LL, buttonPercentage, c3);
  Window lr = new Window(WindowPosition.LR, buttonPercentage, c4);
  
  wc = new WindowController(ul, ur, ll, lr);  
}

void draw() 
{ 
  wc.draw(0, 0, width, height);
  
  if (RECORD_FRAMES)
  {
    saveFrame("frame-######.png");
  }
} 

void keyPressed()
{
  if (key == 'r' && RECORD_FRAMES_ENABLED)
  {
    RECORD_FRAMES = !RECORD_FRAMES;
  }
}

void mouseClicked() 
{
  wc.mouseClicked();
}