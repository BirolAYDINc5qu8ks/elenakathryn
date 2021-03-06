//AoGP 
//Section Example 009: Shaders
// By Patrick Hebron

//Processing OpenGL
import processing.opengl.*; 
//Raw openGL Handle
import javax.media.opengl.*; 
//GLGraphics: http://sourcesforge.net/projects/glgraphics/
import codeanticode.glgraphics.*; 
//Easing: http://jesusgollonet.com/processingpennerEasing/robert-penner-easing-processing-lib.zip
import penner.easing.*; 

//demo parameters 
int demoModels = 48; 
boolean demoInHD = false; 

//Scene Controller 
SceneController mScene; 
//Camera stat iterator 
int currCamState = 0; 

void setup() {
  //In this example, we look at shaders and some data strutures for assinting with their use. 
  // A lot of the new material for this example is within the ShaderManager tab. Please take a look at the notes and code there. 
  // The general goal of these shader management structure is as follows: 
  //Managing assets - images, videos, shaders, etc - twithin an application is a task that often spirals out of control
  //over the course of a project's development. This is particularly true of the projects that require a 
  // quick turn around or go through a series of radicial design changes over a short period. 
  // Though it's not particularly fun, it will save time and frustration later ot build a simple asset management system. 
  // Shaders come with thier own variables and runtimes, so it is an area that can be particularly benefitted by your working out
  // a management system that fits the nature of your software. In this example, we've added a bunch of "build-in" shaders
  // that can be easily attached to an object. Having a collection of built-in shaders is very useful in quickly sketching out a scene or a world. 

  //One of the interesting things about shaders is that we can apply different ones to different objects in our scene
  // to come a world filled with oejcts rendered by starkly different principles. WE could have a realistically lit object
  // positioned alongside a toon-shaded object or one that is rendered with Hatching. It's an aesthetic mashup of the highest order. 
  //Since shaders can set the position of vertices, camera model, lighting and coloring of an object, 
  // there is an opportunity for a sort of GLSL cubism. That is, we can fracture adn fragment the way we visualize an envrionment, we can apply numerous visual styels, etc. 
  // we can also use this feature more conventionally to simulate a variety of materials we might find in the real world - shiny ones, matte ones, metalic ones, etc. 

  // For reference to the GLGraphics GLSL API, see: http://glgraphics.sourceforge.net/reference/codeanticode/glgraphics/GLSLShader.html

  //We not initialize the renderer with "GLConstants.GLGRAPHICS" rather than "OPENGL":

  size(800, 600, GLConstants.GLGRAPHICS); 

  //Initialize the SceneController. The Controller will need access to the PApplet 
  //ojbect and the renderer contained within it, so we pass the PApplet here. 

  mScene = new SceneController(this); 

  int ptsPerAxis; 
  if (demoInHD) {
    ptsPerAxis = 100;
  } 
  else {
    ptsPerAxis = 25;
  }

  //create some models
  int totalVertexCount = 0; 

  float floorLen = 5000.0 * demoModels; 
  TMesh tFloor = mScene.addTerrain(200, 200, floorLen, floorLen, 0.0, 4000.0, 16, 0.7); 
  tFloor.setPosition(new PVector(floorLen/4.0, -2000.0, 0.0)); 
  tFloor.setRotation(new PVector(0.0, 0.0, PI)); 
  tFloor.setActiveShader("OldTownSquare"); 

  totalVertexCount += tFloor.getVertexCount(); 

  randomSeed(0); 

  //for this demo we'll randomly generate a bunch of geometries and attach random built-in shaders to them. 

  for (int i = 0; i < demoModels; i++) {
    TMesh curr; 

    int tRandA = (int)random(0, 6); 
    int tRandB = (int)random(0, 6); 

    if (tRandA % 6 == 0) {
      curr = mScene.addMesh(ptsPerAxis, ptsPerAxis, 300.0, 150.0); 
      curr.setRotationVelocity(new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)));
    }

    else if (tRandA % 6 == 1) {
      curr = mScene.addTerrain( ptsPerAxis, ptsPerAxis, 300.0, 150.0, 0.0, 400.0, 16, 0.45); 
      curr.setRotationVelocity(new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)));
    }
    else if (tRandA % 6 == 2) {
      curr = mScene.addCone(ptsPerAxis, ptsPerAxis, 50.0, 200.0); 
      curr.setRotationVelocity(new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)));
    }
    else if (tRandA % 6 == 3) {
      curr = mScene.addTorus(ptsPerAxis, ptsPerAxis, 50.0, 100.0); 
      curr.setRotationVelocity(new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)));
    }
    else if (tRandA % 6 == 4) {
      curr = mScene.addCylinder(ptsPerAxis, ptsPerAxis, 50.0, 200.0); 
      curr.setRotationVelocity(new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)));
    }
    else {
      curr = mScene.addSphere(ptsPerAxis, ptsPerAxis, 100.0); 
      curr.setRotationVelocity(new PVector(random(-0.01, 0.01), random(-0.01, 0.01), random(-0.01, 0.01)));
    }

    if (tRandB % 6 == 0) {
      curr.setTexture(loadImage("world32k.jpg")); 
      curr.setActiveShader("Phong");
    } 
    else if (tRandB % 6 == 1) {
      curr.setActiveShader("Toon");
    }
    else if (tRandB % 6 == 2) {
      curr.setActiveShader("Brick");
    }
    else if (tRandB % 6 == 3) {
      curr.setActiveShader("Hatch");
    }
    else if (tRandB % 6 == 4) {
      curr.setActiveShader("OldTownSquare");
    }
    else {
      curr.setActiveShader("Norm");
    }

    totalVertexCount+= curr.getVertexCount(); 

    curr.setPosition(new PVector( i* 200.0, 0, 0)); 
    curr.setScale(new PVector (0.5, 0.5, 0.5)); 

    String camStateName = "cam_" + (i); 
    PVector lookAt = curr.getPosition(); 
    PVector eye = PVector.add(lookAt, new PVector(0.0, -400.0, 300.0)); 
    PVector upAxis = new PVector (0.0, 1.0, 0.0); 
    float fov = radians(map(i, 0, demoModels, 30.0, 120.0)); 
    mScene.mCamera.addState(camStateName, eye, lookAt, upAxis); 
    mScene.mCamera.addStateParameters(camStateName, fov, 0.1, 100000.0); 

    PVector lightPos = lookAt.get(); 
    lightPos.add(new PVector(0.0, 300.0, 0.0)); 
    PVector lightDir = new PVector(0.0, -1.0, 0.0); 

    String lightStateName0 = "light_0_state_" + (i); 
    String lightStateName1 = "light_1_state_" + (i); 
    mScene.mLights[0].createSpotlightState( lightStateName0, 20, 20, 255, lightPos, lightDir, radians(80.0), 200.0 );
    mScene.mLights[1].createPointState(lightStateName1, 104, 94, 50, PVector.add(lightPos, lightDir));
  }

  mScene.goToCameraState("cam_0", 0.01); 
  mScene.goToLightState("light_0_state_0", 0.01); 
  mScene.goToLightState("light_1_state_0", 0.01); 

  mScene.mLights[2].createAmbientState("light_2_state_0", 30, 30, 30, new PVector(0, 0, 0)); 
  mScene.goToLightState("light_2_state_0", 0.01); 

  println("Total vertices: " + totalVertexCount);
}

void draw() {
  //draw scene
  mScene.draw(); 
  //println("fps: " + frameRate);
}

void keyReleased() {
  if (key == ' ' ) {
    if (currCamState >= demoModels) {
      currCamState = 0;
    }

    float duration = 1.5; 
    mScene.goToCameraState(("cam_" + (currCamState)), duration); 
    mScene.goToLightState(("light_0_state_" + (currCamState)), duration); 
    mScene.goToLightState(("light_1_state_" + (currCamState)), duration);
  }
  else if (key == 'o') {
    mScene.mCamera.setOrtho(!mScene.mCamera.getOrtho());
  }
  else if (key == 'd') {
    mScene.toggleDebugMode();
  }
}

