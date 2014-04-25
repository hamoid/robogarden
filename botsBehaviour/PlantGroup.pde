
class PlantGroup {

  ArrayList<Plant> vegetation;

  PlantGroup() 
  {
    vegetation = new ArrayList<Plant>();
  }

  void seed_plant(float x, float y, int type)
  {
    Plant root;
    switch(type) {
    case 1:
      root = new PlantA(x, y, x, y, int(random(80, 130)), 0);
      break;
    default:
      root = new Plant(x, y, x, y, int(random(80, 130)), 0);
    }
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

  void update(Object parent)
  {
    // yang: iterating backwards so we can kill plants
    for (int p = vegetation.size()-1; p >= 0; p--) {
      Plant plant = vegetation.get(p);
      plant.update(0);
      if (plant.isDead) {
        vegetation.remove(p);
      }
    }

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
            Plant sapling = null;
            try {
              // We want to clone a plant of unknown kind so we find its class and its constructor.
              // This is very tricky, because you have to specify the arguments for the constructor
              // and there's a bit of magic involved. Apparently Processing changes the signature
              // of your functions, and adds the sketch as first argument. You can use
              // getDeclaredConstructors() to find out about that. Then, you must call newInstance
              // with the main sketch as first argument, so I do update(this) from botsBehaviour.
              // Look at the next line. Isn't Java beautiful and straightforward? :)
              sapling = plant.getClass().getDeclaredConstructor(new Class[] { parent.getClass(), plant.getClass()}).newInstance(parent, plant);
            } catch(Exception e) {
              println(e);
            }
            sapling.x = sx;
            sapling.y = sy;
            sapling.px = plant.x;
            sapling.py = plant.y;
            sapling.hue = plant.hue;
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

