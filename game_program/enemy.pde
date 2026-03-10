class Enemy
{
  float x;  // x position
  float y;  // y position
  float size;  // enemy size
  boolean alive = true;  // alive state

  float speed = 1;   // movement speed

  Enemy(float x, float y, float size) // constructor
  {
    this.x = x;
    this.y = y;
    this.size = size;

    rocketFrames = new PImage[3];  // array that stores each frame of the animation
    rocketFrames[0] = loadImage("rocket_1.png");
    rocketFrames[1] = loadImage("rocket_2.png");
    rocketFrames[2] = loadImage("rocket_3.png");

    for (int i = 0; i < rocketFrames.length; i++) // loop through each image
    {
      rocketFrames[i].resize(int(60), int(60));  //resize for perforamnce
    }
  }


  void display()
  {
    if (alive)
    {
      imageMode(CENTER);
      image(rocketFrames[frameIndex], x, y);

      frameTimer++;
      if (frameTimer >= frameDelay)
      {
        frameTimer = 0;
        frameIndex = (frameIndex + 1) % rocketFrames.length;
      }
    }
  }


  boolean enemyKilled()  // collision with mouse
  {
    if (!alive) return false;

    float d = dist(mouseX, mouseY, x, y);  // distance from mouse
    if ( d < size/2)
    {
      alive = false;  // kill enemy
      return true;
    } else
    {
      return false;
    }
  }

  void move(Goal goal)
  {
    if (!alive) return;

    float distanceX = goal.x - x;  // horizontal distance to goal
    float distanceY = goal.y - y;  // vertical distance to goal

    float distance = dist(x, y, goal.x, goal.y);

    if (distance > 0)
    {
      x += (distanceX / distance) * speed;  // stabilises speed when moving in diagonal
      y += (distanceY / distance) * speed;
    }
  }



  boolean reachGoal(Goal goal)
  {
    float d = dist(x, y, goal.x, goal.y);
    if (d < (size/2 + 10))  // collision with goal
    {
      return true;
    } else return false;
  }
}
