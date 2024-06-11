import controlP5.*;

PShape base, shoulder, upArm, loArm, end;
float rotX, rotY;
float posX = 1, posY = 50, posZ = 50;
float alpha, beta, gamma;

float[] Xsphere = new float[99];
float[] Ysphere = new float[99];
float[] Zsphere = new float[99];

ControlP5 cp5;
boolean isPlaying = true;

void setup() {
    size(1200, 800, OPENGL);

    loadModels();
    initializeControlP5();
}

void draw() {
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

void mouseDragged() {
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}

void loadModels() {
    base = loadShape("./models/r5.obj");
    shoulder = loadShape("./models/r1.obj");
    upArm = loadShape("./models/r2.obj");
    loArm = loadShape("./models/r3.obj");
    end = loadShape("./models/r4.obj");

    shoulder.disableStyle();
    upArm.disableStyle();
    loArm.disableStyle();
}

void initializeControlP5() {
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

void updateSimulation() {
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

void drawRobot() {
    noStroke();

    pushMatrix();  // Save the current matrix state

    translate(width / 2, height / 2);
    rotateX(rotX);
    rotateY(-rotY);
    scale(-4);

    fill(#FFE308);
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

void drawTrajectory() {
    for (int i = 0; i < Xsphere.length; i++) {
        pushMatrix();
        translate(-Ysphere[i], -Zsphere[i] - 11, -Xsphere[i]);
        fill(#D003FF, 25);
        sphere(float(i) / 20);
        popMatrix();
    }
}
