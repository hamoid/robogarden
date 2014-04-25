Robots robots;
PlantGroup plants;

PImage noTracks;
PImage tracks;

void setup() {
  size(1344, 768, P3D);
  colorMode(HSB);
  background(255);
  noFill();
  rectMode(CENTER);

  robots = new Robots(1, 3);
  plants = new PlantGroup();

  tracks = createImage(1600, 1200, RGB);
  noTracks = createImage(1600, 1200, RGB);
  tracks.loadPixels();
  noTracks.loadPixels();
  for (int i = 0; i < tracks.pixels.length; i++) {
    tracks.pixels[i] = color(84, 150, random(180, 210));    // tweak colors to grass green
    noTracks.pixels[i] = color(84, 150, random(180, 210));
  }
  tracks.updatePixels();
}

void draw() {
  background(#E2F0C4);
  camera(width/2.0, mouseY, mouseX, width/2.0, height/2.0, 0, 0, 1, 0);

  hint(ENABLE_DEPTH_TEST);
  noStroke();
  drawGround();

  plants.update(this);
  plants.draw();

  robots.run();

  for (int i = robots.particles.size()-1; i >= 0; i--) {
    Walker bot = robots.particles.get(i);
    if (bot.mode == Walker.MOVING) {
      darkenRobotTracks(bot);
    }
  }

  fadeTracks();

  noLights();
  camera();
  hint(DISABLE_DEPTH_TEST);
  robots.drawEmos();
}

void darkenRobotTracks(Walker bot) {
  tracks.loadPixels();
  for (int i=0; i<20; i++) {
    int x = (int)((bot.location.x / width) * tracks.width);
    int y = (int)((bot.location.y / height) * tracks.height);
    PVector direction = bot.pDiff.get();
    direction.normalize();
    PVector perpendicular = new PVector(direction.y, -direction.x);
    perpendicular.mult(10);   // this is essentially the width of the bot

    if (random(1.0) > 0.5) {
      x += perpendicular.x;
      y += perpendicular.y;
    } else {
      x -= perpendicular.x;
      y -= perpendicular.y;
    }
    
    x += random(-5, 5);
    y += random(-5, 5);

    int which = x + y * tracks.width;
    if (which < 0) which = 0;
    if (which > tracks.pixels.length) which = tracks.pixels.length - 1;

    int c = tracks.pixels[which];
    c = color(32, saturation(c), brightness(c) - 20);   // change hue to something close to mud
    tracks.pixels[which] = c;  
  }
}

void fadeTracks() {
  tracks.loadPixels();
  noTracks.loadPixels();  
  for (int i = 0; i < 2000; i++) {
    int index = (int)(random(tracks.pixels.length));
    tracks.pixels[index] = noTracks.pixels[index];
  }
  tracks.updatePixels();
}

void drawGround() {
  beginShape();
  textureMode(NORMAL);
  texture(tracks);
  vertex(0, 0, 0, 0);
  vertex(width, 0, 1, 0);
  vertex(width, height, 1, 1);
  vertex(0, height, 0, 1);
  endShape();
}
