Robots robots;
PlantGroup plants;

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
  tracks.loadPixels();
  for (int i = 0; i < tracks.pixels.length; i++) {
    tracks.pixels[i] = color(32, 50, random(210, 230));
  }
  tracks.updatePixels();
}

void draw() {
  background(#E2F0C4);
  camera(width/2.0, mouseY, mouseX, width/2.0, height/2.0, 0, 0, 1, 0);

  hint(ENABLE_DEPTH_TEST);
  noStroke();
  drawGround();

  plants.update();
  plants.draw();

  robots.run();

  for (int i = robots.particles.size()-1; i >= 0; i--) {
    Walker bot = robots.particles.get(i);
    if (bot.mode == Walker.MOVING) {
      darkenRobotTracks(bot);
    }
  }

  noLights();
  camera();
  hint(DISABLE_DEPTH_TEST);
  robots.drawEmos();
}

void darkenRobotTracks(Walker bot) {
  tracks.loadPixels();
  for (int i=0; i<30; i++) {
    int x = (int)((bot.location.x / width) * tracks.width + random(-5, 5));
    int y = (int)((bot.location.y / height) * tracks.height + random(-5, 5));

    int which = x + y * tracks.width;
    if (which < 0) which = 0;
    if (which > tracks.pixels.length) which = tracks.pixels.length - 1;

    int c = tracks.pixels[which];
    c = color(hue(c), saturation(c), brightness(c) - 20);
    tracks.pixels[which] = c;  
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
