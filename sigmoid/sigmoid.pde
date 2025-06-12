// S字カーブ (Sigmoid Curve)
import controlP5.*;

ControlP5 cp5;
PImage srcImage;      // 元画像
PImage outputImage;   // 処理後の画像
String filename;
float curveSteepness = 5.0; // S字カーブの傾きを制御するパラメータ

void setup() {
  filename = "data/Sailboat.png";
  srcImage = loadImage(filename);
  if (srcImage == null) {
    throw new NullPointerException("画像ファイルが見つかりません: " + filename);
  }
  size(256 * 2, 256 + 40); // スライダー用のスペースを確保
  outputImage = createImage(srcImage.width, srcImage.height, RGB);
  
  // スライダーのセットアップ
  cp5 = new ControlP5(this);
  cp5.addSlider("curveSteepness")
     .setRange(0.1, 15.0) // 傾きの範囲
     .setValue(5.0)
     .setPosition(10, srcImage.height + 10)
     .setSize(width - 20, 20)
     .setLabel("Curve Steepness");
}

void draw() {
  // S字カーブ処理
  srcImage = loadImage(filename);
    
  srcImage.loadPixels();
  outputImage.loadPixels();
  for (int i = 0; i < srcImage.pixels.length; i++) {
    float r = red(srcImage.pixels[i]);
    float g = green(srcImage.pixels[i]);
    float b = blue(srcImage.pixels[i]);

    // 各色成分にS字カーブを適用
    float newR = sigmoid(r, curveSteepness);
    float newG = sigmoid(g, curveSteepness);
    float newB = sigmoid(b, curveSteepness);

    outputImage.pixels[i] = color(newR, newG, newB);
  }
  outputImage.updatePixels();
  
  // 画像の表示
  background(0);
  image(srcImage, 0, 0);
  image(outputImage, srcImage.width, 0);
}

// 0-255の値をS字カーブで変換する関数
float sigmoid(float value, float steepness) {
  // 1. 値を0.0-1.0の範囲に正規化
  float x = value / 255.0f;
  // 2. 中心を0.5から0にずらす
  x = x - 0.5f;
  // 3. シグモイド関数を適用
  float sig = 1.0f / (1.0f + exp(-steepness * x));
  // 4. 再び0-255の範囲に戻す
  return sig * 255.0f;
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
