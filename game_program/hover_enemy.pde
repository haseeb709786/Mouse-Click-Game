class HoverEnemy extends Enemy
{
  float timer = 10.0;  // lifespan
  float damageCooldown = 0; // prevents rapid damage (for balancing)

  HoverEnemy(float size)
  {
    super(random(size*2, width-size*2), random(size*2, height-size*2), size);
    alive = true;
  }

  @Override
    void display()
  {
    fill(255, 255, 0);
    rectMode(CENTER);
    rect(x, y, size, size);  // draw square enemy
    rectMode(CORNER);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(int(timer), x, y);  // show remaining lifespan time
  }

  void update()
  {
    if (alive)
    {

      damageCooldown = damageCooldown - 1.0/60.0;  // only damamges once per second


      if (dist(mouseX, mouseY, x, y) < size/2)  // detects collison
      {
        if (damageCooldown <= 0)
        {
          lives = lives - 1;  // damages player
          println("You're on Hover Enemy! Current Lives: " + lives);
          if (lives <= 0)
          {
            gameOver = true;
          }
          damageCooldown = 1.0;
        }
      }

      timer = timer - 1.0/60.0;  // reduce lifespan
      timer = round(timer * 100) / 100.0;

      if (timer <= 0)
      {
        alive = false; // dies when time expires
      }
    }
  }
}
