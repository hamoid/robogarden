class Plant 
{ 

  float x, y; // positions
  float age; // in seconds
  float size, size_min, size_max;
  float growth_rate;
  float time_born;
  boolean fully_grown, can_spawn;

  public Plant(float x, float y)
  {
    this.x = x;
    this.y = y;
    this.time_born = millis()/1000.0;
    this.age = 0.0;
    this.size_min = 10;
    this.size_max = 30;
    this.growth_rate = 20.0;
    this.size = size_min;
    this.fully_grown = false;
    this.can_spawn = true;
  }

  void draw()
  {
    if (this.fully_grown)
    {
      fill(128, 200, 0);
    }
    else
    {
      fill(100, 255, 30);
    }
    ellipse(this.x, this.y, this.size, this.size);
  }

  void update(float dt)
  {
    this.age = millis()/1000.0 - this.time_born; 

    update_growth();
  }

  void update_growth() {
    this.size =  this.size_min + this.growth_rate * this.age;
    if (this.size > this.size_max) 
    {
      this.size = this.size_max;
      this.fully_grown = true;
    }
    if (this.size < this.size_min)
    {
      this.size = this.size_min;
    }
  }


  void randomize_growth() {
    this.size_max = (5.0 + randomGaussian())/6.0 * 30.0;
    this.growth_rate = (5.0 + randomGaussian())/(5.0 + 1.0) * 20.0;
  }
}

