float t = millis()/1000.0;

PlantGroup plantgroup;

void setup() 
{
  size(800, 600, P3D); 

  plantgroup = new PlantGroup(width/2.0, height/2.0);
}

void draw() 
{
  background(100, 150, 0);
  camera(mouseX, mouseY, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  float fov = 2.0*PI/3.0 ;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  //perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);  
  //camera(0.0, 0.0, 200.0, 0.0,0.0,0.0,  0.0,-1.0,0.0 );
  plantgroup.update();

  plantgroup.draw();
}

