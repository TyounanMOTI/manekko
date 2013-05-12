#include "testApp.h"
#include "GameKit/GameKit.h"

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

}

//--------------------------------------------------------------
void testApp::draw(){
	drawBPMSetting();
}

void testApp::drawBPMSetting() {
	// draw cirlce: BPM setting
	float radius = _previous_touch_position.distance(_current_touch_position);
	ofSetColor(255,255,255);
	ofFill();
	ofCircle(ofGetScreenWidth()/2, ofGetScreenHeight()/2, radius);
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	_previous_touch_position.set(touch.x, touch.y);
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	_current_touch_position.set(touch.x, touch.y);
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

