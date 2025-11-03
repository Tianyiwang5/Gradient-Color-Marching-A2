// --- Draw Stickman Function ---
void drawStickman(float x, float y, color c, boolean move, float angle, float speed, float amplitude) {
  stroke(c);
  strokeWeight(2);
  fill(c);

  // Head
  ellipse(x, y, 20, 20);

  // Body
  line(x, y + 10, x, y + 50);

  if (move) {
    float armOffset = amplitude * sin(angle);
    float legOffset = amplitude * sin(angle + HALF_PI);

    // Arms
    line(x, y + 20, x - 20, y - 5 - armOffset);
    line(x, y + 20, x + 20, y - 5 - armOffset);

    // Legs
    line(x, y + 50, x - 10, y + 70 + legOffset); 
    line(x, y + 50, x + 10, y + 70 - legOffset);
  } else {
    // Static pose
    line(x, y + 20, x - 20, y + 40);
    line(x, y + 20, x + 20, y + 40);
    line(x, y + 50, x - 20, y + 70);
    line(x, y + 50, x + 20, y + 70);
  }
}   // refering the basic structure to make the stickman from @jannymarie78 on YouTube(jannymarie,2022) 



// --- Individual angles for moving stickmen ---
float[] angles = {0, 0, 0, 0, 0}; 
float greenAngle = 0;

// --- X positions for stickmen ---
float xYellow = 200; // yellow stickman (will move left & disappear)
float xBlue = 300;   // blue stickman (will be stable)
float xGreen = 400;  
float[] xReds = {500, 600, 700, 800, 900};

// --- Movement directions ---
float[] dirs = {1, 1, 1, 1, 1};
float greenDir = 1;

// --- Transition controls ---
float greenToRed = 0;   // 0 = fully green, 1 = fully red
float yellowAlpha = 255; // opacity of yellow stickman (will fade out)
boolean yellowGone = false;

// --- Sun movement ---
float sunX = 100;   // starting x position (left side)
float sunY = 120;   // fixed height in the sky
float sunSize = 120; // diameter of the sun

// boolean and lerp fuction as well as the use of if statement and for loop used above and beneath are refered from The Coding Train(The Coding Train,2015)
//float fuction is refered from Celine Latulipe's video on TouTube(Celine,2019)

void setup() {
  size(1000, 1000);
}  // size of the animation

void draw() {
  // --- Background ---
  noStroke();
  fill(135, 206, 235); // light blue sky
  rect(0, 0, width, 570);
  fill(139, 69, 19); // brown ground
  rect(0, 570, width, height - 570);

  // --- Red Sun (moves slowly from left to middle) ---
  fill(255, 50, 50);
  noStroke();
  ellipse(sunX, sunY, sunSize, sunSize);
  if (sunX < width / 2) { 
    sunX += 0.2; // slow horizontal movement from left side to the middle
  }

  // --- Yellow stickman (disappearing) ---
  if (!yellowGone) {
    drawStickman(xYellow, 500, color(255, 215, 0, yellowAlpha), false, 0, 0, 0);
    xYellow -= 1.0;          // move left slowly
    yellowAlpha -= 2.0;      // fade out gradually

    if (xYellow < -50 || yellowAlpha <= 0) {
      yellowGone = true; // mark as gone
    }
  }

  // --- Static stickmen ---
  drawStickman(xBlue, 500, color(0, 0, 200), false, 0, 0, 0); // blue (static)

  // --- Green stickman transforms gradually ---
  float r = lerp(0, 200, greenToRed);
  float g = lerp(200, 0, greenToRed);
  float b = lerp(0, 0, greenToRed);
  color greenToRedColor = color(r, g, b);

  boolean moveGreen = greenToRed > 0.3;
  float greenAmplitude = 10 * greenToRed;

  drawStickman(xGreen, 500, greenToRedColor, moveGreen, greenAngle, 0.05, greenAmplitude);

  // --- Red stickmen (moving) ---
  for (int i = 0; i < 5; i++) {
    float speed = 0.05 + i * 0.02;
    float amplitude = 8 + i * 2;
    drawStickman(xReds[i], 500, color(200, 0, 0), true, angles[i], speed, amplitude);
  }

  // --- Ground line ---
  stroke(0);
  line(0, 570, width, 570);

  // --- Update angles ---
  for (int i = 0; i < 5; i++) {
    angles[i] += 0.05 + i * 0.02;
  }
  greenAngle += 0.05;

  // --- Move red stickmen ---
  float leftLimit = 420;// 
  float rightLimit = width - 50;  // red stickmen right side 
  for (int i = 0; i < 5; i++) {
    xReds[i] += dirs[i] * (1.0 + i * 0.3);
    if (xReds[i] > rightLimit || xReds[i] < leftLimit) dirs[i] *= -1;
  } // red stickmen 

  // --- Move green stickman ---
  if (moveGreen) {
    xGreen += greenDir * 1.0;
    if (xGreen > leftLimit + 50 || xGreen < 350) {
      greenDir *= -1;
    }
  }

  // --- Gradually transform green to red ---
  if (greenToRed < 1) {
    greenToRed += 0.003;
  }
}
