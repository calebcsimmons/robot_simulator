PShape base, shoulder, upArm, loArm, end;
float rotX, rotY;
float posX=1, posY=50, posZ=50;
float alpha, beta, gamma;

float[] Xsphere = new float[99];
float[] Ysphere = new float[99];
float[] Zsphere = new float[99];

void setup(){
    size(1200, 800, OPENGL);
    
    base = loadShape("/Users/calebsimmons/Downloads/robot parts/data/r5.obj");
    shoulder = loadShape("/Users/calebsimmons/Downloads/robot parts/data/r1.obj");
    upArm = loadShape("/Users/calebsimmons/Downloads/robot parts/data/r2.obj");
    loArm = loadShape("/Users/calebsimmons/Downloads/robot parts/data/r3.obj");
    end = loadShape("/Users/calebsimmons/Downloads/robot parts/data/r4.obj");
    
    shoulder.disableStyle();
    upArm.disableStyle();
    loArm.disableStyle(); 
}

void draw(){ 
   writePos();
   background(32);
   smooth();
   lights(); 
   directionalLight(51, 102, 126, -1, 0, 0);
    
    for (int i=0; i< Xsphere.length - 1; i++) {
    Xsphere[i] = Xsphere[i + 1];
    Ysphere[i] = Ysphere[i + 1];
    Zsphere[i] = Zsphere[i + 1];
    }
    
    Xsphere[Xsphere.length - 1] = posX;
    Ysphere[Ysphere.length - 1] = posY;
    Zsphere[Zsphere.length - 1] = posZ;
   
   noStroke();
   
   translate(width/2,height/2);
   rotateX(rotX);
   rotateY(-rotY);
   scale(-4);
   
   for (int i=0; i < Xsphere.length; i++) {
     pushMatrix();
     translate(-Ysphere[i], -Zsphere[i]-11, -Xsphere[i]);
     fill (#D003FF, 25);
     sphere (float(i) / 20);
     popMatrix();
    }
    
   fill(#FFE308);  
   translate(0,-40,0);   
     shape(base);
     
   translate(0, 4, 0);
   rotateY(gamma);
     shape(shoulder);
      
   translate(0, 25, 0);
   rotateY(PI);
   rotateX(alpha);
     shape(upArm);
      
   translate(0, 0, 50);
   rotateY(PI);
   rotateX(beta);
     shape(loArm);
      
   translate(0, 0, -50);
   rotateY(PI);
     shape(end);
}

void mouseDragged(){
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}
