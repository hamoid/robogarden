float t = millis()/1000.0;

PlantGroup plantgroup;

void setup() 
{
  size(800, 600, P2D); 

  plantgroup = new PlantGroup(width/2.0, height/2.0);
}

void draw() 
{
  background(100, 150, 0); 
  noStroke();
  fill(255, 200, 0);

  plantgroup.update();

  plantgroup.draw();
}

