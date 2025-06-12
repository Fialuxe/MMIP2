import controlP5.*;

ControlP5 cp5_r, cp5_g, cp5_b;

PImage source;
PImage destination;
float GAMMA_R = 2.0;
float GAMMA_G = 2.0;
float GAMMA_B = 2.0;
String filename;
void setup() {
  size(256, 400); // Extra space for slider
  filename = "data/Lenna.png";
  source = loadImage(filename);
  if (source == null) {
    println("Failed to load image.");
    exit();
  }
  destination = createImage(source.width, source.height, RGB);
  
  cp5_r = new ControlP5(this);
  cp5_r.addSlider("GAMMA_R")
     .setRange(0.1, 5.0)
     .setValue(2.0)
     .setPosition(20, 265)
     .setSize(220, 20)
     .setNumberOfTickMarks(50)
     .setSliderMode(Slider.FLEXIBLE);
     
  cp5_g = new ControlP5(this);
  cp5_g.addSlider("GAMMA_G")
     .setRange(0.1, 5.0)
     .setValue(2.0)
     .setPosition(20, 285)
     .setSize(220, 20)
     .setNumberOfTickMarks(50)
     .setSliderMode(Slider.FLEXIBLE);
     
  cp5_b = new ControlP5(this);
  cp5_b.addSlider("GAMMA_B")
     .setRange(0.1, 5.0)
     .setValue(2.0)
     .setPosition(20, 305)
     .setSize(220, 20)
     .setNumberOfTickMarks(50)
     .setSliderMode(Slider.FLEXIBLE);
}

float gamma_correction(float colorVal, float gammaFactor) {
  return 255 * pow(colorVal / 255.0, 1.0 / gammaFactor);
}

void draw() {
  background(255);
  source = loadImage(filename);
  source.loadPixels();
  destination.loadPixels();
  
  for (int y = 0; y < source.height; y++) {
    for (int x = 0; x < source.width; x++) {
      int p = x + y * source.width;
      float r = gamma_correction(red(source.pixels[p]), GAMMA_R);
      float g = gamma_correction(green(source.pixels[p]), GAMMA_G);
      float b = gamma_correction(blue(source.pixels[p]), GAMMA_B);
      destination.pixels[p] = color(r, g, b);
    }
  }
  
  destination.updatePixels();
  image(destination, 0, 0);
}

// Optional: press a key to save
void keyPressed() {
   //CHANGING IMAGE
   String oldFilename = filename;
   filename = "data/";
   if(key == '1'){
     filename = filename + "Sailboat.png";
   }
   else if(key == '2'){
     filename = filename + "Aerial.png";
     System.out.println(filename);
   }
   else if(key == '3'){
     filename = filename + "Airplane.png";
   }
   else if(key == '4'){
     filename = filename + "Balloon.png";
   }
   else if(key == '5'){
     filename = filename + "Earth.png";
   }
   else if(key == '6'){
     filename = filename + "Mandrill.png";
   }
   else if(key == '7'){
     filename = filename + "milkdrop.png";
   }
   else if(key == '8'){
     filename = filename + "Parrots.png";
   }
   else if(key == '9'){
     filename = filename + "Pepper.png";
   }else{
     filename = oldFilename;
     save("data/destination.png");
   }
}
