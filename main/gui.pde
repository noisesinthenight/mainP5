import controlP5.*;
ControlP5 cp5;

int hide = 0;

void keyPressed() {
  if (key == 'm' || key == 'M') {
    if (hide > 0) {
      cp5.show(); 
      hide = 0;
    } else {
      cp5.hide(); 
      hide = 1;
    }
  };

  if (key == 's' || key == 'S') {    
    saveFrame("image_" + hour() +"_"+ minute() +"_"+ second() + ".png");
    println("image exported");
  };

  if (key == 'r' || key == 'R') {
      reset = 1;
  };
  
  if (key == 'g' || key == 'G') {
    grab();
  };
  
  if (key == 'o' || key == 'O') {  
    selectInput("Select a file to process:", "load");
  }

}

void gui() {
  cp5 = new ControlP5(this);
  cp5.setColorCaptionLabel(color(255 - bgCol));
  
  
}

