import processing.serial.*;

Serial myPort;

String datastr;
int time;
PrintWriter output; 
boolean Save = false;
boolean end = false;
String s = "Not Save now";
String str_format = "time(ms), value";

int sensorNUM = 2; //センサーの数
int graphWidth = 1100;
int graphHeight = 600;
int graphPointX = 200;
int graphPointY = 70;

int graphMin = 0;
int graphMax = 1200;

int hSplit = 3;
float xSpeed = 10;

boolean judge1 = false;
boolean judge2 = false;
float[][] sensors = new float[sensorNUM][int((graphWidth+5) / xSpeed)]; //センサーの値を格納する配列
int cnt; //カウンター

// グラフの線の色を格納
color[] col = new color[3];

PFont hello;

float r;
int R = 130;
int A;




void setup() {
  size(1400, 800);
  //size(graphWidth, graphHeight);
  frameRate(60);


  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  println("myPortHasOpened");
  myPort.bufferUntil('\n');
  println("myPortHasConnected");
  delay(100);
  myPort.clear();

  String filename = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) ; //日時でcsvファイル作成
  output = createWriter( filename + ".csv");

  initGraph();
}

void draw() {

  background(157, 204, 224);
  fill(255);
  noStroke();
  rect(graphPointX, graphPointY, graphWidth, graphHeight);
  stroke(col[2]);
  fill(0, 204, 255);
  A = 2;


  //drawTitle();
  drawsalivaLabels();
  drawtimeLabels();
  Labelsline();
  LabelsWord();

  fill(0, 0, 0);
  textSize(50);
  text(s, graphPointX + 500, graphPointY-40);

  for (int i = 0; i < sensors[0].length - 6; i++ ) {
    stroke(col[2]);
    strokeWeight(5);
    line((i+5) * xSpeed + graphPointX, valuetoPointY(sensors[0][i+5]), (i+6) * xSpeed + graphPointX, valuetoPointY(sensors[0][i+6]));

    stroke(col[1]);
    strokeWeight(5);
    line((i+5) * xSpeed + graphPointX, valuetoPointY(sensors[1][i+5]), (i+6) * xSpeed + graphPointX, valuetoPointY(sensors[1][i+6]));
  }

  if ( myPort.available() > 0) {
    datastr = myPort.readString();
    println(datastr);
    String[] data = datastr.split(",");
    if (data.length  == 2) {
      if (!(data[0]== null || data[1] == null)) {
        time = millis();
        println(time);

        for (int i = 0; i < sensors[0].length - 1; i++) {
          sensors[0][i] = sensors[0][i+1];
        }
        sensors[0][sensors[0].length-1] = float(data[0]);

        for (int i = 0; i < sensors[1].length - 1; i++) {
          sensors[1][i] = sensors[1][i+1];
        }
        sensors[1][sensors[1].length-1] = float(data[1]);


        if (Save == true) { 
          output.print(time);
          output.print(",");
          output.println(datastr);

          s = "Save now";
          fill(0, 0, 0);
          textSize(50);
          text(s, graphPointX + 500, graphPointY-40);
        }
      }
    }
  }


  if ((Save == false)&&(end == true)) {
    output.flush();  // 出力バッファに残っているデータを全て書き出し
    output.close();  // ファイルを閉じる
    exit();
  }
}

void initGraph() {
  background(47);
  noStroke();
  cnt = 0;
  col[0] = color(255, 127, 31);
  //col[1] = color(31, 255, 127);
  //col[2] = color(127, 31, 255);
  col[1] = color(31, 127, 255);
  //col[4] = color(127, 255, 31);
  //col[5] = color(127);
  col[2] = color(85, 75, 70);

  fill(255);
  rect(graphPointX, graphPointY, graphWidth, graphHeight);
}


void drawTitle() {
  stroke(40, 71, 153);
  fill(255, 253, 0);
  textSize(50);
  text("Salivation volume", graphWidth-20, graphPointY-20);
}

void drawsalivaLabels() {
  stroke(40, 71, 153);
  fill(255, 253, 0);
  textSize(50);
  textLeading(15);
  textAlign(CENTER, CENTER);
  text("Humid", graphPointX/2, graphPointY + graphHeight/2);
}

void drawtimeLabels() {
  stroke(40, 71, 153);
  fill(255, 253, 0);
  textSize(50);
  textLeading(15);
  textAlign(CENTER, CENTER);
  text("Time", graphPointX + graphWidth/2, graphPointY*3/2+graphHeight);
}
void Labelsline() {
  for (int i=0; i<(hSplit); i++) {
    stroke(192, 192, 192);
    line(graphPointX, (graphPointY + (graphHeight*(i+1)/hSplit)), graphPointX+graphWidth, (graphPointY + (graphHeight*(i+1)/hSplit)));
  }
}

void LabelsWord() {
  for (int i=0; i<hSplit+1; i++) {
    fill(40, 71, 153);
    text(graphMin + ((graphMax - graphMin)/hSplit)*i, graphPointX-40, (graphPointY + graphHeight)-(graphHeight/hSplit*i) );
  }
}



void keyPressed() {
  if (key == 's') {
    if (Save == true) {
      end = true;
    }
    Save = !Save;
  }
}


float valuetoPointY(float value) {
  if (value < graphMin) {
    value = graphMin;
  }
  float Point;
  Point = graphHeight*(graphMax - value)/(graphMax-graphMin)+graphPointY;
  return Point;
}
