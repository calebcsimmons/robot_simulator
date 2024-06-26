/* autogenerated by Processing revision 1293 on 2024-06-11 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import controlP5.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class robot_simulator extends PApplet {



PShape base, shoulder, upArm, loArm, end;
float rotX, rotY;
float posX = 1, posY = 50, posZ = 50;
float alpha, beta, gamma;

float[] Xsphere = new float[99];
float[] Ysphere = new float[99];
float[] Zsphere = new float[99];

ControlP5 cp5;
boolean isPlaying = true;

public void setup() {
    /* size commented out by preprocessor */;

    loadModels();
    initializeControlP5();
}

public void draw() {
    background(32);
    smooth();
    lights();
    directionalLight(51, 102, 126, -1, 0, 0);

    if (isPlaying) {
        updateSimulation();
    }

    drawRobot();
    drawTrajectory();
    cp5.draw();  // Draw ControlP5 elements outside the transformed space
}

public void mouseDragged() {
    rotY -= (mouseX - pmouseX) * 0.01f;
    rotX -= (mouseY - pmouseY) * 0.01f;
}

public void loadModels() {
    base = loadShape("./models/r5.obj");
    shoulder = loadShape("./models/r1.obj");
    upArm = loadShape("./models/r2.obj");
    loArm = loadShape("./models/r3.obj");
    end = loadShape("./models/r4.obj");

    shoulder.disableStyle();
    upArm.disableStyle();
    loArm.disableStyle();
}

public void initializeControlP5() {
    cp5 = new ControlP5(this);
    cp5.addButton("Play")
       .setPosition(10, 10)
       .setSize(50, 20)
       .onClick(new CallbackListener() {
           public void controlEvent(CallbackEvent theEvent) {
               isPlaying = true;
           }
       });
    cp5.addButton("Stop")
       .setPosition(70, 10)
       .setSize(50, 20)
       .onClick(new CallbackListener() {
           public void controlEvent(CallbackEvent theEvent) {
               isPlaying = false;
           }
       });
}

public void updateSimulation() {
    writePos();

    for (int i = 0; i < Xsphere.length - 1; i++) {
        Xsphere[i] = Xsphere[i + 1];
        Ysphere[i] = Ysphere[i + 1];
        Zsphere[i] = Ysphere[i + 1];
    }

    Xsphere[Xsphere.length - 1] = posX;
    Ysphere[Ysphere.length - 1] = posY;
    Zsphere[Xsphere.length - 1] = posZ;
}

public void drawRobot() {
    noStroke();

    pushMatrix();  // Save the current matrix state

    translate(width / 2, height / 2);
    rotateX(rotX);
    rotateY(-rotY);
    scale(-4);

    fill(0xFFFFE308);
    translate(0, -40, 0);
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

    popMatrix();  // Restore the matrix state to prevent GUI transformations
}

public void drawTrajectory() {
    for (int i = 0; i < Xsphere.length; i++) {
        pushMatrix();
        translate(-Ysphere[i], -Zsphere[i] - 11, -Xsphere[i]);
        fill(0xFFD003FF, 25);
        sphere(PApplet.parseFloat(i) / 20);
        popMatrix();
    }
}
float F = 50;
float T = 70;
float millisOld, gTime, gSpeed = 4;

public void IK() {
    float X = posX;
    float Y = posY;
    float Z = posZ;

    float L = sqrt(Y * Y + X * X);
    float dia = sqrt(Z * Z + L * L);

    alpha = PI / 2 - (atan2(L, Z) + acos((T * T - F * F - dia * dia) / (-2 * F * dia)));
    beta = -PI + acos((dia * dia - T * T - F * F) / (-2 * F * T));
    gamma = atan2(Y, X);
}

public void setTime() {
    gTime += ((float) millis() / 1000 - millisOld) * (gSpeed / 4);
    if (gTime >= 4) gTime = 0;
    millisOld = (float) millis() / 1000;
}

public void writePos() {
    IK();
    setTime();
    posX = sin(gTime * PI / 2) * 20;
    posZ = sin(gTime * PI) * 10;
}


  public void settings() { size(1200, 800, OPENGL); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "robot_simulator" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
