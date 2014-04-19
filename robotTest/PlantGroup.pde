class PlantGroup {

  ArrayList<Plant> vegetation;

  PlantGroup() 
  {
    vegetation = new ArrayList<Plant>();
  }

  void seed_plant(float x, float y)
  {
    Plant root = new Plant(x, y, int(random(80, 130)), 0);
    root.randomize_growth();
    vegetation.add(root);
  }

  void draw()
  {
    for (int p=0; p<vegetation.size(); p++)
    {
      Plant plant = vegetation.get(p);
      plant.draw();
    }
  }

  void update()
  {

    for (int p=0; p<vegetation.size(); p++)
    {
      Plant plant = vegetation.get(p);
      plant.update(0);
    }
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
            if (dist(sx, sy, plant2.x, plant2.y) < plant2.size_max || outside_screen(sx, sy))
            {
              does_not_overlap = false;
              break;
            }
          }

          if ( does_not_overlap) 
          {
            Plant sapling = new Plant(sx, sy, plant.hue, plant.generation+1);
            sapling.randomize_growth();
            vegetation.add(sapling);
          }
        }
        plant.can_spawn = false;
      }
    }
  }

  boolean outside_screen(float x, float y) 
  {
    if (x<0 || x>width || y<0 || y>height)
    {
      return true;
    }
    return false;
  }
}

