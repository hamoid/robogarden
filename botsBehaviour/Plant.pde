class Plant 
{ 

  float x, y; // positions
  float age; // in seconds
  float size, size_min, size_max;
  float growth_rate;
  float time_born;
  boolean fully_grown, can_spawn;
  int generation;
  int hue, saturation, value;
  boolean isDead;

  public Plant(float x, float y, int hue, int generation)
  {
    this.x = x;
    this.y = y;
    this.time_born = millis()/1000.0;
    this.age = 0.0;
    this.size_min = 1;
    this.size_max = 30;
    this.growth_rate = 20.0;
    this.size = size_min;
    this.fully_grown = false;
    this.can_spawn = true;
    this.generation = generation;
    this.saturation = 200;
    this.hue = hue;
    this.value = 255;

    isDead = false;
  }

  void draw()
  {
    pushMatrix();
    noStroke();
    lights();
      fill(this.hue, this.value, this.saturation);
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
    this.value = int( 255.0 - 55.0*this.size_max/this.size );
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
    float exponential_factor = exp( - this.generation * 0.1 );
    this.size_max = (5.0 + randomGaussian())/6.0 * 30.0 * exponential_factor;
    this.growth_rate = (5.0 + randomGaussian())/(5.0 + 1.0) * 10 * exponential_factor;
    this.saturation = int( exponential_factor * this.saturation );

    if (random(1.0) > exponential_factor) 
    {
      this.can_spawn = false;
    }
  }

  void kill() {
    isDead = true;
  }
}

