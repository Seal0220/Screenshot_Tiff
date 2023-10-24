class SS extends Thread {
  public PImage img;
  private String path;

  SS(int i) {
    this.path = "Screenshot_img/" + i + ".jpg";
    this.img = loadImage(this.path);
    this.img.resize(floor(this.img.width/5), floor(this.img.height/5));
  }

  public void Display(int x, int y, int W, int H) {
    if (this.img != null) {
      try{
      float scale = random(0.1, 1);
      
      int _W = floor(W*scale);
      int _H = floor(H*scale);
      int randomX = floor(random(this.img.width - _W));
      int randomY = floor(random(this.img.height - _H));
      

      int[] pixels = this.img.pixels;
      PImage croppedImage = createImage(_W, _H, ARGB);

      for (int i = 0; i < _W; i++) {
        for (int j = 0; j < _H; j++) {
          int sourceX = randomX + i;
          int sourceY = randomY + j;
          int sourceIndex = sourceY * this.img.width + sourceX;

          int targetIndex = i + j * _W;
          croppedImage.pixels[targetIndex] = pixels[sourceIndex];
        }
      }

      croppedImage.updatePixels();
      image(croppedImage, x, y, W, H);
      }
      catch(Exception E) {println(E);}
    }
  }
}
