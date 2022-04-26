String map[] = new String[27];
//boolean touches[] = new boolean[255];
//int nbBlocs = 14;
////-----------    0    1    2    3    4    5    6    7    8    9   10   11   12
//char blocs[] = {' ', 'H', 'L', 'P', 'G', 'R', 'E', 'B', 'C', 'T', 'D', 'X', 'S', 'A'};
//PImage Pblocs[] = new PImage[nbBlocs];
PImage drapeau;
char blocMain = 'R';
int large = 48, haut = 27;
//int blocCam[] = {0, 0};
//int rebour = -1;

int blocRoulette = 5;

boolean importation = false;

String open = "11.txt";
String save = "carte1.txt";


void setupMC() {
  if (importation == false) {
    for (int i = 0; i < 27; i ++) {
      String s = "";
      for (int j = 0; j < 48; j ++) {
        s += ' ';
      }
      map[i] = s;
    }
  } else {
    map = loadStrings(open);
    large = map[0].length();
    haut = map.length-1;
  }

  importImageMC();
}

void drawMC() {
  pushMatrix();
  translate(cam.x, cam.y);
  //println(cam.x,cam.y);
  background(255);
  stroke(0);
  strokeWeight(1);
  //for (int i = blocCam[0]; i < blocCam[0]+48; i ++) {
  //   for (int j = blocCam[1]; j < blocCam[1]+27; j ++) {

  for (int i = 0; i <= large; i ++) {// block : 30*30
    for (int j = 0; j <= haut; j ++) {
      line(i*40, 0, i*40, haut*40);
      line(0, j*40, large*40, j*40);
    }
  }
  pushMatrix();
  //translate(-blocCam[0]*40, -blocCam[1]*40);
  for (int i = 0; i < large; i ++) {// block : 30*30
    for (int j = 0; j < haut; j ++) {
      int nmB = numBlocMC(map[j].charAt(i));
      if(nmB == 13){
        image(drapeau, (i)*40, (j)*40, 40, 40);
      }else{
        image(Pblocs[nmB], (i)*40, (j)*40, 40, 40);
      }
    }
  }
  popMatrix();
  if (mousePressed == true) {
    if (mouseButton == LEFT) {
      placeBloc(int((rSi(mouseY)-cam.y)/40.0), int((rSi(mouseX)-cam.x)/40.0), blocRoulette);//+blocCam[1]*40,+blocCam[0]*40
    }
  }
  popMatrix();
  if (blocRoulette == 13) {
    image(drapeau, rSi(mouseX), rSi(mouseY), 40, 40);
  } else {
    image(Pblocs[blocRoulette], rSi(mouseX), rSi(mouseY), 40, 40);
  }

  touche();
}

void importImageMC() {//------------------------------------------------------------------IMPORT IMAGE-----------------------------------------------------------------------------------------------

  //for (int i = 0; i < nbBlocs; i ++) {
  //  Pblocs[i] = loadImage("blocs/b"+blocs[i]+".png");
  //}
  drapeau = loadImage("blocs/bA1.png");
}


PVector cam = new PVector(0, 0);

void mouseDragged() {//------------------------------------------------------------------MOUSE DRAGGED-----------------------------------------------------------------------------------------------
  if (mouseButton == RIGHT) {
    cam.x += mouseX-pmouseX;
    cam.y += mouseY-pmouseY;
  }
}

boolean creation = true;

void keyPressedMC() {//------------------------------------------------------------------KEY PRESSED-----------------------------------------------------------------------------------------------

  if (touches[38]) {//haut
    if (creation) {
      addLigne(-1);
    } else {
      addLigne(-2);
    }
  }
  if (touches[39]) {//droite
    if (creation) {
      addColonne(1);
    } else {
      addColonne(2);
    }
  }
  if (touches[40]) {//bas
    if (creation) {
      addLigne(1);
    } else {
      addLigne(2);
    }
  }
  if (touches[37]) {//gauche
    if (creation) {
      addColonne(-1);
    } else {
      addColonne(-2);
    }
  }
  if (touches[16]) {
    creation = !creation;
  }
}


void mouseWheel(MouseEvent event) {//------------------------------------------------------------------MOUSE WHEEL-----------------------------------------------------------------------------------------------
  float e = event.getCount();
  println(e);
  blocRoulette += int(e);
  if (blocRoulette < 0) {
    blocRoulette = blocs.length-1;
  } else if (blocRoulette >= blocs.length) {
    blocRoulette = 0;
  }
}

void placeBloc(int ligne, int colonne, int bloc) {//------------------------------------------------------------------PLACE BLOC-----------------------------------------------------------------------------------------------
  if (ligne <= haut-1 && ligne >= 0 && colonne <= large-1 && colonne >= 0) {
    String save = "";
    for (int i = 0; i < map[ligne].length(); i ++) {
      if ( i == colonne) {
        save += blocs[bloc];
      } else {
        save += map[ligne].charAt(i);
      }
    }
    //save = "   R   R   R   R   R  R  R    R     R               R";
    map[ligne] = save;
  }
}

int numBlocMC(char blocF) {//------------------------------------------------------------------NUM BLOC-----------------------------------------------------------------------------------------------
  int a = 0;
  while (blocF != blocs[a]) {
    a ++;
  }
  return a;
}

void addLigne(int sens) {//------------------------------------------------------------------ADD LIGNE-----------------------------------------------------------------------------------------------
  haut ++;
  String n = "";
  for (int i = 0; i < large; i ++) {
    n += " ";
  }
  if (sens ==1) {
    map = append(map, n);
  } else if (sens == -1) {
    String mapP [] = {n};
    for (int i = 0; i < haut-1; i ++) {
      mapP = append(mapP, map[i]);
    }
    map = mapP;
  } else if (sens == 2 && haut-1 > 1) {
    haut -= 2;
    String mapP[] = new String[haut];
    for (int i = 0; i < haut; i ++) {
      mapP[i] = map[i];
    }
    map = mapP;
  } else if (sens == -2 && haut-1 > 1) {
    haut -= 2;
    String mapP[] = new String[haut];
    println(haut);
    for (int i = 1; i < haut+1; i ++) {
      mapP[i-1] = map[i];
    }
    map = mapP;
  }
}

void addColonne(int sens) {//------------------------------------------------------------------ADD COLONNE-----------------------------------------------------------------------------------------------
  large ++;
  for (int i = 0; i < haut; i ++) {
    if (sens == 1) {
      map[i] = map[i]+" ";
    } else if (sens == -1) {
      map[i] = " "+map[i];
    }
  }
  if (sens == 2) {//droite
    large -=2;
    String mapP[] = new String[haut];
    for (int i = 0; i < haut; i ++) {
      String ligne = "";
      for (int j = 0; j < map[i].length() -1; j ++) {
        ligne += map[i].charAt(j);
      }
      mapP[i] = ligne;
    }
    map = mapP;
  } else if (sens == -2) {
    large -=2;
    String mapP[] = new String[haut];
    for (int i = 0; i < haut; i ++) {
      String ligne = "";
      for (int j = 1; j < map[i].length(); j ++) {
        ligne += map[i].charAt(j);
      }
      mapP[i] = ligne;
    }
    map = mapP;
  }
}
import javax.swing.*;

void touche() {//------------------------------------------------------------------TOUCHE-----------------------------------------------------------------------------------------------
  if (touches[17]) {// ctrl
    save = ((String)JOptionPane.showInputDialog(null, "Sauvegarde", "Nom du fichier : ", JOptionPane.PLAIN_MESSAGE));
    ;
    boolean a = false;
    int variablePasTresUtile = save.length();
    if (variablePasTresUtile > 4) {
      if (save.charAt(variablePasTresUtile-1) != 't' || save.charAt(variablePasTresUtile-2) != 'x' || save.charAt(variablePasTresUtile-3) != 't' || save.charAt(variablePasTresUtile-4) != '.') {
        a = true;
      }
    }
    if (variablePasTresUtile < 4 || a) {
      save+=".txt";
    }
    save = "mapCreator/"+save;
    String r = str(large-4);
    map = append(map, r);
    saveStrings(save, map);
    println("save!");
    passEtat(0);
  }
  if (touches[72]) {
    blocMain = 'H';
    blocRoulette = 1;
  }
  if (touches[32]) {
    blocMain = ' ';
    blocRoulette = 0;
  }
  if (touches[76]) {
    blocMain = 'L';
    blocRoulette = 2;
  }
  if (touches[80]) {
    blocMain = 'P';
    blocRoulette = 3;
  }
  if (touches[71]) {
    blocMain = 'G';
    blocRoulette = 4;
  }
  if (touches[82]) {
    blocMain = 'R';
    blocRoulette = 5;
  }
  if (touches[69]) {
    blocMain = 'E';
    blocRoulette = 6;
  }
  if (touches[66]) {
    blocMain = 'B';
    blocRoulette = 7;
  }
  if (touches[67]) {
    blocMain = 'C';
    blocRoulette = 8;
  }
  if (touches[84]) {
    blocMain = 'T';
    blocRoulette = 9;
  }
  if (touches[68]) {
    blocMain = 'D';
    blocRoulette = 10;
  }
  if (touches[88]) {
    blocMain = 'X';
    blocRoulette = 11;
  }
  if (touches[83]) {
    blocMain = 'S';
    blocRoulette = 12;
  }
  if (touches[81]) {
    blocMain = 'A';
    blocRoulette = 13;
  }
}
