import java.util.Collections;
import java.util.ArrayList;

// --- Global Variables ---
PImage srcImage;
PImage noisyImage;
PImage filteredImageA; // Result from the first method
PImage filteredImageB; // Result from the second (better) method
String filename;

// --- Controls ---
float noiseAmount = 0.50;  // Amount of salt-and-pepper noise. 0.2 is 20%.
int filterSize = 3;       // The size of the filter window (e.g., 3 for a 3x3 grid). Must be an odd number.

// --- Main Setup ---
void setup() {
  filename = "data/noised.png";
  srcImage = loadImage(filename); 

  // --- Error Handling ---
  if (srcImage == null) {
    println("Error: Image not found. Please add an image named 'Sailboat.png' to the 'data' folder.");
    size(500, 250);
    background(220);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    text("IMAGE NOT FOUND\n\nPlease add 'Sailboat.png' to your sketch's 'data' folder.", width/2, height/2);
    noLoop(); 
    return;
  }
  
  // Set window size to display 3 images side-by-side
  size(256 * 3, 256);
  
  // --- Image Processing Pipeline ---
  noisyImage = srcImage.copy();
  addSaltAndPepperNoise(noisyImage, noiseAmount);
  
  // Apply both filter methods for comparison
  filteredImageA = medianFilter_RGB_Individual(noisyImage, filterSize);
  filteredImageB = medianFilter_Brightness_Standard(noisyImage, filterSize);
}

// --- Main Draw Loop ---
void draw() {
  srcImage = loadImage(filename);
  background(0);
  
  
  // --- Image Processing Pipeline ---
  noisyImage = srcImage.copy();
  addSaltAndPepperNoise(noisyImage, noiseAmount);
  
  // Apply both filter methods for comparison
  filteredImageA = medianFilter_RGB_Individual(noisyImage, filterSize);
  filteredImageB = medianFilter_Brightness_Standard(noisyImage, filterSize);
  
  
  // Display Noisy Image (Left), Method A (Center), Method B (Right)
  image(noisyImage, 0, 0);
  image(filteredImageA, srcImage.width, 0);
  image(filteredImageB, srcImage.width * 2, 0);
}

// --- Helper Functions ---

/**
 * Adds "salt and pepper" noise to an image.
 * This function directly modifies the PImage object passed to it.
 */
void addSaltAndPepperNoise(PImage img, float amount) {
  img.loadPixels();
  int totalPixels = img.width * img.height;
  int numNoisePixels = (int)(totalPixels * amount);

  for (int i = 0; i < numNoisePixels; i++) {
    int px = (int)random(totalPixels);
    // Alternate between setting pixels to black (pepper) and white (salt).
    if (i % 2 == 0) {
      img.pixels[px] = color(0); // Black
    } else {
      img.pixels[px] = color(255); // White
    }
  }
  img.updatePixels();
}

// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//  METHOD A : Sort R, G, B Channels Independently
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

PImage medianFilter_RGB_Individual(PImage inputImage, int kernelSize) {
  int edge = kernelSize / 2;
  PImage outImage = createImage(inputImage.width, inputImage.height, RGB);
  
  inputImage.loadPixels();
  outImage.loadPixels();
  
  for (int y = edge; y < inputImage.height - edge; y++) {
    for (int x = edge; x < inputImage.width - edge; x++) {
      
      // CHANGED: Using ArrayList instead of a standard array.
      ArrayList<Integer> neighborPixels = new ArrayList<Integer>();
      
      // Get all neighbor pixels
      for (int ky = -edge; ky <= edge; ky++) {
        for (int kx = -edge; kx <= edge; kx++) {
          int neighborIndex = (y + ky) * inputImage.width + (x + kx);
          // CHANGED: Using .add() to append to the list.
          neighborPixels.add(inputImage.pixels[neighborIndex]);
        }
      }
      
      // Get the median value for each channel separately
      float medR = getMedianChannelValue(neighborPixels, 'R');
      float medG = getMedianChannelValue(neighborPixels, 'G');
      float medB = getMedianChannelValue(neighborPixels, 'B');
      
      // Assemble the new color from the three independent median values
      outImage.pixels[y * outImage.width + x] = color(medR, medG, medB);
    }
  }
  outImage.updatePixels();
  return outImage;
}

// Helper for Method A, now accepting and using ArrayList.
private float getMedianChannelValue(ArrayList<Integer> pixels, char channel) {
  // CHANGED: Using ArrayList for channel values.
  ArrayList<Float> values = new ArrayList<Float>();
  
  // A "for-each" loop to iterate through the list of pixels.
  for (color p : pixels) {
    if (channel == 'R') values.add(red(p));
    if (channel == 'G') values.add(green(p));
    if (channel == 'B') values.add(blue(p));
  }
  
  // CHANGED: Using Collections.sort() for ArrayLists.
  Collections.sort(values);
  
  // CHANGED: Using .get() and .size() for ArrayLists.
  return values.get(values.size() / 2);
}

// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//  METHOD B: Sort by Brightness (Standard, Robust Method)
//  This method preserves original colors and is recommended.
//  Helped by Gemini 2.5 Pro, because of sorting
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//

// A helper class to store color and brightness together.
class PixelInfo implements Comparable<PixelInfo> {
  color pixelColor;
  float brightnessValue;

  PixelInfo(color c) {
    this.pixelColor = c;
    this.brightnessValue = brightness(c);
  }
  
  // Defines how to sort PixelInfo objects: by their brightness.
  @Override
  public int compareTo(PixelInfo other) {
    return Float.compare(this.brightnessValue, other.brightnessValue);
  }
}

PImage medianFilter_Brightness_Standard(PImage inputImage, int kernelSize) {
  PImage outputImage = createImage(inputImage.width, inputImage.height, RGB);
  int edge = kernelSize / 2;

  inputImage.loadPixels();
  outputImage.loadPixels();

  for (int y = edge; y < inputImage.height - edge; y++) {
    for (int x = edge; x < inputImage.width - edge; x++) {
      // A list to hold neighbor pixel information
      ArrayList<PixelInfo> neighbors = new ArrayList<PixelInfo>();

      // Get all neighbor pixels
      for (int ky = -edge; ky <= edge; ky++) {
        for (int kx = -edge; kx <= edge; kx++) {
          int neighborIndex = (y + ky) * inputImage.width + (x + kx);
          neighbors.add(new PixelInfo(inputImage.pixels[neighborIndex]));
        }
      }
      
      // Sort the list of neighbors by brightness
      Collections.sort(neighbors);
      
      // Get the color of the median pixel from the sorted list
      color medianColor = neighbors.get(neighbors.size() / 2).pixelColor;
      
      outputImage.pixels[y * outputImage.width + x] = medianColor;
    }
  }
  outputImage.updatePixels();
  return outputImage;
}

void keyPressed() {  
  //CHANGING IMAGE
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
     filename = filename + "Sailboat.png"; //default
   }
  }
