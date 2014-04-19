class Plant 
{ 

  float x, y; // positions
  float age; // in seconds
  float size, size_min, size_max;
  float growth_rate;
  float time_born;
  boolean fully_grown, can_spawn;
  int generation;

  public Plant(float x, float y, int generation)
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
    this.generation = generation;
  }

  void draw()
  {
    pushMatrix();
    noStroke();
    lights();
    if (this.fully_grown)
    {
      fill(128, 200, 0);
    }
    else
    {
      fill(100, 255, 30);
    }
    translate(this.x, this.y, 0);
    sphereDetail(10);
    sphere( this.size/2.0 );
    popMatrix();
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
    float exponential_factor = exp( - this.generation * 0.2 );
    this.size_max = (5.0 + randomGaussian())/6.0 * 30.0 * exponential_factor;
    this.growth_rate = (5.0 + randomGaussian())/(5.0 + 1.0) * 20.0;

    if (random(1.0) > exponential_factor) 
    {
      this.can_spawn = false;
    }
  }
}

