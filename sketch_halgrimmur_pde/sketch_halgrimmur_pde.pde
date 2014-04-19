float t = millis()/1000.0;

ArrayList<Plant> vegetation; 

void setup() 
{
  size(800, 600, P2D); 

  vegetation = new ArrayList<Plant>();
  Plant x = new Plant(random(width), random(height));
  //x.randomize_growth();
  vegetation.add(x);
}

void draw() 
{
  background(100, 150, 0); 
  noStroke();
  fill(255, 200, 0);

  update_vegetation();

  for (int p=0; p<vegetation.size(); p++)
  {
    vegetation.get(p).update(0);
  }
  for (int p=0; p<vegetation.size(); p++)
  {
    vegetation.get(p).draw();
  }
}

void update_vegetation() {
  for (int p=0; p<vegetation.size(); p++)
  {
    Plant plant = vegetation.get(p);
    if (plant.fully_grown == true && plant.can_spawn) 
    {
      for (int s=0; s<random(3,6); s++) {
        float radius = plant.size_max + 4.0;
        float angle = random(0.0, TAU);

        float sx, sy;
        sx = radius * cos(angle) + plant.x;
        sy = radius * sin(angle) + plant.y;

        boolean does_not_overlap = true;

        for (int p2=0; p2<vegetation.size(); p2++) 
        {
          Plant plant2=vegetation.get(p2);
          if (dist(sx, sy, plant2.x, plant2.y) < plant2.size)
          {
            does_not_overlap = false;
            break;
          }
        }

        if ( does_not_overlap) 
        {
          Plant sapling = new Plant(sx, sy);
          sapling.randomize_growth();
          vegetation.add(sapling);
        }
      }
      plant.can_spawn = false;
    }
  }
}

