class StrongEnemy extends Enemy
{
  float healthPoints;  // requires multiple hits

  StrongEnemy(float x, float y, float size, float healthPoints) 
  {
    super(x, y, size);
    this.healthPoints = healthPoints;

    this.speed = 0.5;  // slower movement 
  }

  @Override
    void display()
  {
    fill(0, 200, 200);
    ellipse(x, y, size, size); // draw enemy

    fill(0);
    textAlign(CENTER, CENTER);
    text(int(healthPoints), x, y);  // display health
  }

  @Override
    boolean enemyKilled()
  {
    float d = dist(mouseX, mouseY, x, y);
    if (d<size/2)  // check collision
    {
      healthPoints = healthPoints - 1;  // reduce health
      if (healthPoints <= 0)   // die when health is 0
      {
        alive = false;
      }
      return true;
    }
    return false;
  }
}
