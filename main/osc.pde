import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress addr;

//input onsets
int oReplyID, onset;
float oPos, oAmpSig, oPitch, oFreq, oSlope;
//input analysis
int aCount;
float aPos, aAmpSig, aPitch, aFreq, aSlope;
//grain clusters
int gReplyID, gDens, gCount;
float gRate, gAmp, gDur, gDuty, gSkew;

//fx chain?
//master?

void osc() {
  oscP5 = new OscP5(this, 9001);
  addr = new NetAddress("127.0.0.1", 9001);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/onset")) {   
    oReplyID = msg.get(0).intValue();
    onset = msg.get(1).intValue();
    oPos = msg.get(2).floatValue();
    oAmpSig = msg.get(3).floatValue();
    oPitch = msg.get(4).floatValue();
    oFreq = msg.get(5).floatValue();
    oSlope = msg.get(6).floatValue();
    
    println("/onset:  "+oReplyID+", "+onset+", "+oPos+", "+oAmpSig+", "+oPitch+", "+oFreq+", "+oSlope);    
  } 
  if (msg.checkAddrPattern("/analysis")) {
    aCount = msg.get(0).intValue();
    aPos = msg.get(1).floatValue();
    aAmpSig = msg.get(2).floatValue();
    aPitch = msg.get(3).floatValue();
    aFreq = msg.get(4).floatValue();
    aSlope = msg.get(5).floatValue();
    
//    println("/analysis:  "+aCount+", "+aPos+", "+aAmpSig+", "+aPitch+", "+aFreq+", "+aSlope);
  }
    
  if (msg.checkAddrPattern("/grain")) {
      gReplyID = msg.get(0).intValue();
      gCount = msg.get(1).intValue();
      gRate = msg.get(2).floatValue();
      gAmp = msg.get(3).floatValue();
      gDur = msg.get(4).floatValue();
      gDuty = msg.get(5).floatValue();
      gSkew = msg.get(6).floatValue(); 
 
//     println("/grain:  "+gReplyID+", "+gCount+", "+gRate+", "+gAmp+", "+gDur+", "+gDuty+" "+gSkew);
     
  }
  
  if (msg.checkAddrPattern("/grainStart")) {
      gReplyID = msg.get(0).intValue();
      gDens = msg.get(1).intValue(); 
      
//      println("/grainStart:  "+gReplyID+", "+gDens);
  }
}
