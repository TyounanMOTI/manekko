#include "testApp.h"
#include "GameKit/GameKit.h"
#include <cmath>

//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(127,127,127);

	// GameKit initialization
	authenticateLocalPlayer();

	// BPM init
	beat_per_minutes_ = 120;
	last_beat_time_ms_ = ofGetElapsedTimeMillis();

	// sound stream init
	ofSoundStreamSetup(1, 0);
	ofSoundStreamStart();
}

void testApp::authenticateLocalPlayer() {
	// Authenticate LocalPlayer
	GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
	localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
		if (viewController) {
			UIViewController *current_view_controller = ofxiPhoneGetViewController();
			[current_view_controller presentViewController:viewController animated:YES completion:nil];
		}
		if (localPlayer.authenticated == YES) {
			ofLog(OF_LOG_NOTICE, "succeed");
		} else if (error != nil){
			ofLog(OF_LOG_ERROR, [[[error localizedDescription] copy] UTF8String]);
		} else {
			ofLog(OF_LOG_ERROR, "fail, no error info");
		}
	};
}

//--------------------------------------------------------------
void testApp::update(){
	// update Beat radius
	beat_radius_--;
	if (beat_radius_ < 1) {
		beat_radius_ = 1;
	}
}

void testApp::audioRequested(float *output, int bufferSize, int nChannels) {
	// beat timing
	TimeMillis elapsed_time_ms = ofGetElapsedTimeMillis() - last_beat_time_ms_;
	TimeMillis interval_ms = 60.0 * 1000 / beat_per_minutes_;	// [拍ズレ] 切り捨てたので、拍がずれるかも

	// [拍ズレ] updateは60fpsなので、拍がずれるかも
	// ↓ofSoundStreamを使うとよい？
	// http://forum.openframeworks.cc/index.php?&topic=3404.0
	if (elapsed_time_ms > interval_ms) {
		beat_radius_ = 300;
		last_beat_time_ms_ = ofGetElapsedTimeMillis();
	}
}

//--------------------------------------------------------------
void testApp::draw(){
	drawBPMSetting();

	// draw Beat
	ofPushStyle();
	ofSetColor(118, 255, 167);
	ofFill();
	ofCircle(ofGetScreenWidth()/2, ofGetScreenHeight()/2, beat_radius_);
	ofPopStyle();
}

void testApp::drawBPMSetting() {
	// draw cirlce: BPM setting
	float radius = previous_touch_position_.distance(current_touch_position_);
	ofSetColor(255,255,255);
	ofFill();
	ofCircle(ofGetScreenWidth()/2, ofGetScreenHeight()/2, radius);
}

//--------------------------------------------------------------
void testApp::exit(){
	ofSoundStreamStop();
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	previous_touch_position_.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	current_touch_position_.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

