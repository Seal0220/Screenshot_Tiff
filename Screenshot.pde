import http.requests.PostRequest;
import java.util.Base64;
import java.io.ByteArrayInputStream;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

final int col = 30, row = 30;
final int img_size = col*row;
final int buffer_size = 3;
final int total_size = img_size + buffer_size;
final Object lock = new Object();
ArrayList<SS> screenshots = new ArrayList<SS>();
int W, H;

int setLastNum() {
  int maxNumber = 0;
  try {
    File folder = new File(savePath("Screenshot_img/"));
    File[] files = folder.listFiles();

    for (int i = 0; i < files.length; i++) {
      if (files[i].isFile()) {
        String fileName = files[i].getName();

        String[] _fileName = fileName.split("\\.");
        if (_fileName[1].equals("jpg")) {
          int fileNumber = int(_fileName[0]);
          if (fileNumber > maxNumber) {
            maxNumber = fileNumber;
          }
        }
      }
    }

    if (maxNumber >= 0) {
      println("[SETLASTNUM] The largest jpg file number is: " + maxNumber);
      println("[SETLASTNUM] Updating info.json[\"last_num\"] ...");
      JSONObject info_json = loadJSONObject("info.json");
      info_json.put("last_num", maxNumber);
      saveJSONObject(info_json, "info.json");
      println("[SETLASTNUM] Updated info.json[\"last_num\"]: " + maxNumber);
    } else {
      println("[SETLASTNUM] No numeric file names or jpg file found");
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  return maxNumber;
}


int getLastNum() {
  JSONObject info_json = loadJSONObject("info.json");
  return info_json.getInt("last_num");
}


void setup() {
  size(1920, 1080);
  frameRate(60);

  setLastNum();

  for (int i = 0; i < total_size; i++) {
    int n = floor(random(getLastNum()));
    screenshots.add(new SS(n));
    println("[SETUP] Loading image: " + n + " (" + (i+1) + "/" + total_size + ")");
  }

  ImageDownloader.start();
  UpdatingImage.start();

  W = floor(width/col);
  H = floor(height/row);
}

//int i = 0;
void draw() {
  try {
    for (int i = 0; i < col*row; i++) {
      int x = (i % col) * W;
      int y = floor(i / col) * H;

      int n = floor(random(img_size));
      screenshots.get(n).Display(x, y, W, H);
    }
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  //save(i+".jpg");
  //i++;
  delay(10);
}
