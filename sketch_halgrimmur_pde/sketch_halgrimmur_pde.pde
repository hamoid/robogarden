float t = millis()/1000.0;


Plant testPlant; 

void setup() 
{
  size(800, 600, P2D); 

  testPlant = new Plant(200, 200);
}

void draw() 
{
  background(100, 150, 0); 
  noStroke();
  fill(255, 200, 0);

  testPlant.update(0);

  testPlant.draw();
}

