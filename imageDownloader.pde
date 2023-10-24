Thread ImageDownloader = new Thread(new Runnable() {
  public void run() {
    while (true) {
      try {
        println("[DOWNLOADING IMAGES] Checking new images...");
        
        PostRequest post = new PostRequest("https://asia-east1-nodal-suprstate-395613.cloudfunctions.net/updateImage");
        post.addHeader("Content-Type", "application/json");
        JSONObject info_json = loadJSONObject("info.json");
        JSONObject date_json = new JSONObject().setString("date", info_json.getString("date"));
        int num = info_json.getInt("last_num")+1;
        post.addData(date_json.toString());
        post.send();

        JSONObject jsonObj = parseJSONObject(post.getContent());
        JSONArray imagesArray = jsonObj.getJSONArray("files");
        println("[DOWNLOADING IMAGES] " + imagesArray.size() + " new images found!!");

        for (int i = 0; i < imagesArray.size(); i++) {
          println("[DOWNLOADING IMAGES] Downloading new images... (" + (i+1) + "/" + imagesArray.size() + ")");
          
          JSONObject fileObj = imagesArray.getJSONObject(i);
          String base64Content = fileObj.getString("content_base64");
          String type = fileObj.getString("type").split("/")[1];
          String name = fileObj.getString("name");
          String time = fileObj.getString("time");

          byte[] imageBytes = Base64.getDecoder().decode(base64Content);
          BufferedImage bufferedImage = null;
          try {
            bufferedImage = ImageIO.read(new ByteArrayInputStream(imageBytes));
          }
          catch (Exception e) {
            e.printStackTrace();
          }

          PImage img = new PImage(bufferedImage.getWidth(), bufferedImage.getHeight(), ARGB);
          bufferedImage.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
          int n = num + i;
          String filePath = savePath("Screenshot_img/" + n + ".jpg");
          File file = new File(filePath);
          println("[DOWNLOADING IMAGES] Saving new image " + name + "...");
          img.save(filePath);
          println(i, num+i, time, name);

          while (!file.exists()) {
            delay(100);
          }

          synchronized (lock) {
            println("[DOWNLOADING IMAGES] Adding new image " + name + "...");
            screenshots.add(new SS(n));
            screenshots.remove(0);
            println("[DOWNLOADING IMAGES] Image updated!!");
          }
        }


        String currentDate = year() + "." + month() + "." + day() + "." + hour() + "." + minute() + "." + second();
        info_json.put("date", currentDate);
        info_json.put("last_num", num+imagesArray.size()-1);
        saveJSONObject(info_json, "info.json");
      }
      catch(NullPointerException e) {
        println("[DOWNLOADING IMAGES] No new images!!");
      }
      catch (Exception e) {
        e.printStackTrace();
        println("----------------------------------------");
      }
       try {
          Thread.sleep(5000);
        }
        catch (InterruptedException ie) {
          ie.printStackTrace();
        }
    }
  }
}
);
