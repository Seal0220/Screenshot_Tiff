Thread UpdatingImage = new Thread(new Runnable() {
  public void run() {
    while (true) {
      try {
        int n = floor(random(getLastNum()));
        SS newImage = new SS(n);
        synchronized (lock) {
          screenshots.add(newImage);
          screenshots.remove(0);
          println("[UPDATING IMAGE] Loading image: " + n);
        }

        Thread.sleep(10);
      }
      catch (InterruptedException e) {
        e.printStackTrace();
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
}
);
