float t = millis()/1000.0;

ArrayList<Plant> vegetation; 

void setup() 
{
  size(800, 600, P2D); 

  vegetation = new ArrayList<Plant>();
  for (int i=0; i<30; i++)
  {
    Plant x = new Plant(random(width), random(height));
    x.randomize_growth();
    vegetation.add(x);
  }
}

void draw() 
{
  background(100, 150, 0); 
  noStroke();
  fill(255, 200, 0);

  for (int p=0; p<vegetation.size(); p++)
  {
     vegetation.get(p).update(0); 
  }
  for (int p=0; p<vegetation.size(); p++)
  {
     vegetation.get(p).draw(); 
  }
  
}

