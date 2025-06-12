// ラプラシアンフィルタ (Laplacian Filter)

float[][] laplacianKernel = {
  {-1.0f, -1.0f, -1.0f},
  {-1.0f,  8.0f, -1.0f},
  {-1.0f, -1.0f, -1.0f}
};

PImage srcImage;      // 元画像
PImage outputImage;   // 処理後の画像
String filename;
boolean isGrayscaled;

void setup() {
  isGrayscaled = false;
  filename = "data/gaussi.png";
  srcImage = loadImage(filename);
  if (srcImage == null) {
    throw new NullPointerException("画像ファイルが見つかりません: " + filename);
  }
  size(402*2, 395*2);
  
  
  
  // 初期画像を生成
  outputImage = applyLapFilter(srcImage);
}



void draw() {
  srcImage = loadImage(filename);
  if (isGrayscaled) {
      PImage gray = grayScale(srcImage);
      outputImage = applyLapFilter(gray);
    } else {
      outputImage = applyLapFilter(srcImage);
    }
  background(0);
  image(srcImage, 0, 0); // 左側に元画像を表示
  image(outputImage, srcImage.width, 0); // 右側に処理後画像を表示
  
  // ウィンドウのタイトルで現在のモードを表示
  if (isGrayscaled) {
    surface.setTitle("Laplacian Filter - Grayscale Mode");
  } else {
    surface.setTitle("Laplacian Filter - Color Mode");
  }
}

// 'g'キーが押されたらグレースケールモードを切り替える
void keyPressed() {
  
  //GRAYSCALE OR NOT
  if (key == 'g' || key == 'G') {
    isGrayscaled = !isGrayscaled;
    // モードに応じて画像を再処理
  }else{
  
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
}

// 画像をグレースケールに変換する関数
PImage grayScale(PImage input) {
  PImage gray = createImage(input.width, input.height, RGB);
  gray.loadPixels();
  input.loadPixels();
  for (int i = 0; i < input.pixels.length; i++) {
    float r = red(input.pixels[i]);
    float g = green(input.pixels[i]);
    float b = blue(input.pixels[i]);
    // NTSC
    int brightness = (int)(0.299 * r + 0.587 * g + 0.114 * b);
    gray.pixels[i] = color(brightness);
  }
  gray.updatePixels();
  return gray;
}

// ラプラシアンフィルタを適用する関数 (カラー/グレースケール両対応)
PImage applyLapFilter(PImage img) {
  PImage result = createImage(img.width, img.height, RGB);
  int edge = laplacianKernel.length / 2;

  result.loadPixels();
  img.loadPixels();

  for (int y = edge; y < img.height - edge; y++) {
    for (int x = edge; x < img.width - edge; x++) {
      float sumR = 0;
      float sumG = 0;
      float sumB = 0;

      for (int ky = -edge; ky <= edge; ky++) {
        for (int kx = -edge; kx <= edge; kx++) {
          int posX = x + kx;
          int posY = y + ky;
          color c = img.pixels[posY * img.width + posX];
          
          float kernelVal = laplacianKernel[ky + edge][kx + edge];
          sumR += red(c) * kernelVal;
          sumG += green(c) * kernelVal;
          sumB += blue(c) * kernelVal;
        }
      }
      
      // 値が0-255の範囲に収まるようにする
      sumR = constrain(sumR, 0, 255);
      sumG = constrain(sumG, 0, 255);
      sumB = constrain(sumB, 0, 255);

      result.pixels[y * img.width + x] = color(sumR, sumG, sumB);
    }
  }
  result.updatePixels();
  return result;
}
