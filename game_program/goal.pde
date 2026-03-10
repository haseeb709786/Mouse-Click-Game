class Goal
{
  float x;
  float y;

  Goal(float tempX, float tempY)
  {
    x = tempX;
    y = tempY;
  }

  void display()
  {
    fill(0, 200, 0);
    ellipse(x, y, 80, 80);  // draw goal
    fill(0);
    textAlign(CENTER);
    textSize(20);
    text(lives, goal.x-10, goal.y+5);  // display remaining lives
  }
}
