PImage spaceBackground;     // background image
ArrayList<Enemy> enemies;   // stores all enemy object

PImage[] rocketFrames;   // animation frames
int frameIndex = 0;      // current frame
int frameDelay = 60;      // controls animation speed
int frameTimer = 0;      // frame counter

Goal goal;                  // the goal that enemies move towards
Player player;              // the player that is controlled by the mouse

int level = 1;               // current game level (difficulty scaling)
int score;                   // player score
int lives = 10;             // player lives
boolean gameOver = false;   // becomes true when player dies so game over screen can be shown
 
float seconds = 0;      // tracks game time

int spawnTimer = 0;     // counts frames between enemy spawns
int spawnDelay = 180;   // the delay in frames between spawns (60 = 1 second)

void setup()
{
  size(750, 750);      // size of the window
  
  spaceBackground = loadImage("spaceBackground.jpg"); // loads from data
  spaceBackground.resize(width, height); // resizing for performance
  
  enemies = new ArrayList<Enemy>();   // create enemy list
  goal = new Goal(width/2, height/2); // create goal and place in the centre of the screen
  player = new Player();              // create player

  println("Current Lives: "+lives);   // output lives in console
}

void draw()
{
  imageMode(CORNER);  
  background(0); // clear screen every frame
  image(spaceBackground, 0, 0, width, height); // draw background image

 
    if (!gameOver)       // only runs if game is active
    {
      noCursor();       // hides cursor
      secondTimer();    // updates timer
      spawnEnemy();     // spawns enemies 
      scoreCounter();   // display UI
      checkLevelUp();   // increases difficulty when needed
      updateEnemies();  // move enemies and check for collissions
      goal.display();   // draw goal
      player.display(); // draw player
      player.update();  // update player position
    } else    // will run when player dies (game over)
    {
      endScreen();  // show game over screen
      cursor();     // displays cursor again
    } 
  
}

void mousePressed()
{
 
  {   // loop backwards to remove enemies without breaking program
    for (int i = enemies.size()-1; i >= 0; i--)  
    {
      Enemy enemy = enemies.get(i); // get current enemy

      if (!(enemy instanceof HoverEnemy))  // HoverEnemy cannot be killed by mouse
      {
        if (enemy.enemyKilled())  // check mouse and enemy collision
        {
          if (!enemy.alive)  // if enemy has died
          {
            if (enemy instanceof StrongEnemy)   
            {
              score = score + 10;  // strong enemies give more points
              println("Strong Enemy Hit! (10 Points)! Score: " + score);
            } else
            {
              score = score + 1;  // normal enemy score 
              println("Hit! Score: " + score);  // prints score to console
            }
          }
        }
      }
    }
  }
}

void endScreen()
{
  textAlign(CENTER);
  textSize(32);
  fill(0);
  text("GAME OVER", width/2, height/2);   // game over title
  textSize(20);
  text("Score: " + score, width/2, height/2 + 40);  // final score
  text("Time: " + seconds, width/2, height/2 + 70); // time survived
  text("Level: "+ level, width/2, height/2 + 100);  // level reached
}

void spawnEnemy()   
{
  spawnTimer = spawnTimer + 1;   // increment spawn timer each frame
  if (spawnTimer >= spawnDelay)  // spawn enemy when delay reached
  {
    spawnTimer = 0;  // reset timer
    for (int i=0; i< (5+(level-1)); i++)  // spawn more enemies at higher levels
    {
      PVector spawnPos = enemySpawnPos(); // PVector used for x,y spawn co ords
      if (random(1) < 0.2) 
      {   // Strong enemy have 20% chance of spawning
        enemies.add(new StrongEnemy(spawnPos.x, spawnPos.y, 50, 3));  // spawn strong enemy
      } else if (random(1) < 0.1)  // hover enemy have 10% chance of spawning
      {
        enemies.add(new HoverEnemy(60));  // spawn hover enemy
      } else
      {
        enemies.add(new Enemy(spawnPos.x, spawnPos.y, 60));  // spawn normal enemy
      }
    }
  }
}

void scoreCounter()
{
  fill(255);
  rect(0, 0, width, 40);  // background bar for UI

  fill(0);
  line(0, 0, width, 1);  // UI borders
  line(0, 0, width, 2);
  line(0, 40, width, 40);
  line(0, 39, width, 39);

  textAlign(LEFT);
  textSize(25);
  fill(0, 255, 0);
  text("Score: "+score, 5, 27);  // displayer score

  fill(0);
  textSize(35);
  textAlign(LEFT);
  text("Time: "+seconds, (width/2), 30);   // display time

  fill(255, 0, 0);
  textSize(25);
  textAlign(RIGHT);
  text("Lives: "+lives, width-5, 27);  // display lives

  textAlign(LEFT);
  textSize(35);
  fill(0, 0, 255);
  text("Level: "+level, (width/2)-130, 30);   // display level
}

void secondTimer()
{
  seconds = seconds + 1.0/60.0;  //  calculates seconds using frame rate (60 fps)
  seconds = round(seconds * 100) / 100.0;  // round to 2 decimal places
}

PVector enemySpawnPos()  // random x,y spawn positions for the enemies
{
  float x = 0;
  float y = 0;

  int edge = int(random(4)); // chooses a random screen edge

  if (edge == 0) // top edge
  {
    x = random(0, width);
    y = 90;
  } else if (edge == 1) // bottom edge
  {
    x = random(0, width);
    y = height;
  } else if (edge == 2) // left edge
  {
    x = 0;
    y = random(90, height);
  } else if (edge == 3) // right edge
  {
    x = width;
    y = random(90, height);
  }

  return new PVector(x, y);  // return spawn position
}

void updateEnemies()
{
  for (int i = enemies.size() - 1; i >= 0; i = i - 1)  // loops backwards so program doesnt break
  {
    Enemy enemy = enemies.get(i);  // get enemy
    enemy.display();               // draw enemy

    if (enemy instanceof HoverEnemy)
    {
      ((HoverEnemy)enemy).update(); // hover enemy has its own behaviour (doesnt move)
    } else
    {
      enemy.move(goal);  // moves towards goal
    }
        // if strong or normal enemy reach goal
    if (enemy.alive && !(enemy instanceof HoverEnemy) && enemy.reachGoal(goal))
    {
      if (enemy instanceof StrongEnemy)
      {
        lives = lives - 3;  // strong enemies do more damage
      } else
      {
        lives = lives - 1;  // normal enemy take 1 life
      }
      enemy.alive = false;
      println("Current Lives: " + lives);  // prints live count to console

      if (lives <= 0)
      {
        gameOver = true;  // end game if no lives are left
      }
    }

    if (!enemy.alive)
    {
      enemies.remove(i);  // remove dead enemy from array, freeing memory
    }
  }
}

void checkLevelUp()
{
  int newLevel = (score / 30) + 1;  // level increases every 30 points
  if (newLevel > level)
  {
    level = newLevel;  // update level

    spawnDelay = max(10, int(180 / sqrt(level)));  // faster spawns at higher level
  }
}
