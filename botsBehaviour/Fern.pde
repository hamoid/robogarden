class Fern extends Plant {
  ArrayList<FernLeaf> fern_leaves;
  int num_leaves = 5;
  float scale;

  // Copy constructor increments generation
  public Fern (Fern src) {
    super(src.x, src.y, src.px, src.py, src.hue, src.generation + 1);
    init();
  }
  public Fern (float x, float y, float px, float py, int hue, int generation) {
    super(x, y, px, py, hue, generation);
    init();
  }
  
  void init(){
    this.fern_leaves = new ArrayList();
    this.num_leaves = int(random(3, 6));
    this.scale = (4.0+randomGaussian())/5.0 * 6.0;
    for (int f=0; f<this.num_leaves; f++) {
      this.fern_leaves.add( new FernLeaf(this.x, this.y, this.scale*(6.0+randomGaussian())/7.0, TAU*float(f)/this.num_leaves, this.hue) );
    }
  }    
    

  
  void draw() {
    lights();
    pushMatrix();
    for (int f=0; f<this.num_leaves; f++) {
      this.fern_leaves.get(f).update(this.size/this.size_max);
      this.fern_leaves.get(f).draw();
    }
    popMatrix();
  }
}

class FernLeaf {

  float x, y;
  float scale;
  float inplane_angle;
  color color_outer, color_inner;
  float theTime;
  float hue;

  FernLeaf (float x, float y, float scale, float inplane_angle, float hue) {
    this.x = x;
    this.y = y;
    this.hue = hue;
    this.scale = scale;
    this.inplane_angle = inplane_angle;
    this.color_inner = color((hue+30)%255,255,200);
    this.color_outer = color(hue, 200, 150);
    this.theTime = 0.0;
  }

  void update(float progress) {
    this.theTime = progress;
  }


  void draw() {
    pushMatrix();
    translate(this.x, this.y);
   lights();
   int iterations = 6;
   
   float scale = this.scale * this.theTime;
   PVector rotation_axis = new PVector(0, 0, 1.0);
   PVector origin = new PVector(0, 0, 0);
   PVector G = rotate( new PVector( 0.5, 0, 1.0), origin, rotation_axis, this.inplane_angle); // initial growing direction
   G.normalize();
   PVector F = rotate( new PVector( 0.2, 0, 0), origin, rotation_axis, this.inplane_angle);  // front-facing vector of the leaf
   PVector R = rotate( new PVector( 0, 1.0, 0.0), origin, rotation_axis, this.inplane_angle); // side-facing vector of the leaf
   
   G.mult(scale);
   F.mult(scale);
   //R.mult(scale);
   
   
   PVector base = new PVector(0, 0, 0);
   PVector pointing = new PVector(G.x, G.y, G.z);
   PVector front = new PVector(F.x, F.y, F.z);
   
   
   ArrayList<PVector> vectors= new ArrayList();
   
   for (int i=0; i<iterations; i++) {
   PVector leaf_width_vec = R.get();
   leaf_width_vec.mult( scale*(1-cos(float(i)/float(iterations)*TAU))*0.3 );
   PVector left = new PVector(0, 0, 0);
   left.add(base);
   left.add(leaf_width_vec);
   PVector right = new PVector(0, 0, 0);
   right.add(base);
   right.sub(leaf_width_vec);
   PVector middle = new PVector(0, 0, 0);
   middle.add(base);
   middle.add(front);
   
   vectors.add(left);
   vectors.add(middle);
   vectors.add(right);
   
   base.add(pointing);
   
   float angle = this.theTime/180*PI * 20.0;
   pointing = rotate(pointing, new PVector(0, 0, 0), R, angle);
   front = rotate(front, new PVector(0, 0, 0), R, angle);
   }  
   PVector end = new PVector(0, 0, 0);
   end.add(base);
   end.add(front);
   
   vectors.add(end);
   vectors.add(end);
   vectors.add(end);
   
   beginShape(TRIANGLES);
   
   for (int i=0; i<iterations; i++) {
   PVector left = vectors.get(3*i + 0); 
   PVector middle = vectors.get(3*i + 1); 
   PVector right = vectors.get(3*i + 2);
   PVector topleft = vectors.get(3*(i+1) + 0);
   PVector topmiddle = vectors.get(3*(i+1) + 1);
   PVector topright = vectors.get(3*(i+1) + 2);
   
   fill(this.color_outer);
   vertex(left.x, left.y, left.z);
   fill(this.color_inner);
   vertex(middle.x, middle.y, middle.z);
   vertex(topmiddle.x, topmiddle.y, topmiddle.z);
   fill(this.color_outer);
   vertex(right.x, right.y, right.z);
   fill(this.color_inner);
   vertex(middle.x, middle.y, middle.z);
   vertex(topmiddle.x, topmiddle.y, topmiddle.z);
   
   fill(this.color_outer);   
   vertex(left.x, left.y, left.z);
   fill(this.color_inner);
   vertex(topmiddle.x, topmiddle.y, topmiddle.z);
   fill(this.color_outer);
   vertex(topleft.x, topleft.y, topleft.z);    
   vertex(right.x, right.y, right.z);
   fill(this.color_inner);
   vertex(topmiddle.x, topmiddle.y, topmiddle.z);
   fill(this.color_outer);
   vertex(topright.x, topright.y, topright.z);
   }
   endShape();
   popMatrix();
   }
}


PVector rotate( PVector vec, PVector origin, PVector axis, float angle) {
  float a, b, c, u, v, w, x, y, z;
  a = origin.x;
  b = origin.y;
  c = origin.z;
  u = axis.x;
  v = axis.y;
  w = axis.z;
  x = vec.x;
  y = vec.y;
  z = vec.z;
  float cosangle =cos(angle); 
  float sinangle = sin(angle);
  float vx = (a*(v*v+w*w) - u*(b*v + c*w - u*x - v*y - w*z))*(1-cosangle)+ x*cosangle + (-c*v + b*w - w*y + v*z)*sinangle;
  float vy = (b*(u*u+w*w) - v*(a*u + c*w - u*x - v*y - w*z))*(1-cosangle)+ y*cosangle + (c*u - a*w + w*x -u*z)*sinangle;
  float vz = (c*(u*u+v*v) - w*(a*u + b*w - u*x - v*y - w*z))*(1-cosangle)+ z*cosangle + (-b*u + a*v - v*x + u*y)*sinangle;
  return new PVector(vx, vy, vz);
}

