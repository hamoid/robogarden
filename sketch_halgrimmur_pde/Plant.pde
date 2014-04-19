class Plant 
{ 

  float x, y; // positions
  float age; // in seconds
  float size, size_min, size_max;
  float growth_rate;
  float time_born;

  public Plant(float x, float y)
  {
    this.x = x;
    this.y = y;
    this.time_born = millis()/1000.0;
    this.age = 0.0;
    this.size_min = 10;
    this.size_max = 80;
    this.growth_rate = 20.0;
    this.size = size_min;
  }

  void draw()
  {
    ellipse(this.x, this.y, this.size, this.size);
  }

  void update(float dt)
  {
    this.age = millis()/1000.0 - this.time_born; 

    update_growth();
  }

  void update_growth() {
    this.size =  this.size_min + this.growth_rate * this.age;
    if (this.size > this.size_max) {
      this.size = this.size_max;
    }
  }
}

