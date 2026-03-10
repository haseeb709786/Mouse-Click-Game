class Player
{
  float x;
  float y;
  float size = 20;

  Player()
  {
    x = 250;
    y = 250;
  }

  void update()
  {  // follows mouse
    x = mouseX;  
    y = mouseY;
  }

  void display()
  {
   fill(0, 0, 255);
   ellipse(x, y, size, size);  // draw player
  }
}
