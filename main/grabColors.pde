class ColorAvg {

  int bins = 12;
  color[] c, cAvg;

  int[] hueCount, hueSorted;
  float[] hues, sats, brights, hueProb;
  int hueCommon;

  FloatList[] huePool;

  ColorAvg(color[] cols) {
    c = cols;
    hueCount = new int[bins];
    hues = new float[bins];
    sats = new float[bins];
    brights = new float[bins];
    huePool = new FloatList[bins];
    for (int i = 0; i < bins; i++) {
      huePool[i] = new FloatList();
    }
    
    avg();
  }

  void avg() {
    for (int i = 0; i < c.length; i++) {
      int hueRounded = constrain(round( (hue(c[i])/255) * bins ), 0, bins);
      hueCount[hueRounded]++;                //count number of occurances
      hues[hueRounded] += hue(c[i]);         //sum all hues, sats and brights
      sats[hueRounded] += saturation(c[i]);
      brights[hueRounded] += brightness(c[i]);
      huePool[hueRounded].append(hue(c[i])); //      huePool //store original hue variations
    };

    hueProb = new float[bins];              //generate percentages for each rounded color
    for (int i = 0; i < bins; i++) {
      hueProb[i] = hueCount[i] / c.length; //divide counters by total pixels to get percentage from 0 - 1
    };

    hueCommon = 0;
    float hueMaxCount = hueCount[0];
    for (int i = 1; i < hues.length; i++) {
      if (hueCount[i] > hueMaxCount) {
        hueMaxCount = hueCount[i];
        hueCommon = i;
      }
    };



    cAvg = new color[bins];
    for (int i = 0; i < cAvg.length; i++) {      
      colorMode(HSB);
      cAvg[i] = color(
        hues[i] / hueCount[i], 
        sats[i] / hueCount[i], 
        brights[i] / hueCount[i]
      );
    };
    
    println(hues[hueCommon]/hueCount[hueCommon]); //print most common
//    c
    
  }
}

