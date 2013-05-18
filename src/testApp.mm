#include "testApp.h"
#include "GameKit/GameKit.h"
#include <cmath>
#import "WISTManekkoDelegate.h"

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

	// BPM init
	beat_per_minutes_ = 120;

	// beat circle shrink init
	beat_max_radius_ = ofGetScreenWidth() * 0.4;
	beat_min_radius_ = beat_max_radius_ * 0.5;
	int shrink_speed_per_beat = beat_max_radius_ - beat_min_radius_;
	beat_shrink_speed_per_frame_ = shrink_speed_per_beat * beatPerFrame(beat_per_minutes_);
	
	// Timer init
	time_offset_ns_ = 0;
	mach_timebase_info(&timebase_info_);

	// sound stream init
	ofSoundStreamSetup(1, 0);
	ofSoundStreamStart();

	// WIST init
	wist_ = [[KorgWirelessSyncStart alloc] init];
	manekkoDelegate_ = [[WISTManekkoDelegate alloc] init:this];
	wist_.delegate = manekkoDelegate_;
}

double testApp::beatPerFrame(int BPM) {
	return BPM / (60.0 /* min/sec */) / ofGetFrameRate();
}

//--------------------------------------------------------------
void testApp::update() {
	shrinkBeatCircle();
}

void testApp::shrinkBeatCircle() {
	beat_radius_ -= beat_shrink_speed_per_frame_;
	if (beat_radius_ < 1) {
		beat_radius_ = 1;
	}
}

void testApp::audioRequested(float *output, int bufferSize, int nChannels) {
	// beat timing
	// ↓拍ズレ防止のため、ofSoundStreamで。
	// http://forum.openframeworks.cc/index.php?&topic=3404.0

	// 拍のアタマで円を大きくする
	// [拍ズレ] interval_ms：切り捨てたので、拍がずれるかも
	Time interval_ms = 60 * 1000 / beat_per_minutes_;

	// [拍ズレ] mod演算でタイミングをはかる
	//   - vs 拍動しない
	//     - 10msなら許容範囲かな？
	if (now_ms() % interval_ms < 10) {
		beat_radius_ = beat_max_radius_;
	}
}

testApp::Time testApp::now_ns() {
	return mach_absolute_time() * timebase_info_.numer / timebase_info_.denom;
}

testApp::Time testApp::now_ms() {
	return now_ns() / (1000 * 1000);
}

//--------------------------------------------------------------
void testApp::draw(){
	drawBeat();
}

void testApp::drawBeat() {
	ofPushStyle();
	if (wist_.isConnected && wist_.isMaster) {
		// if Master, beats Red circle
		ofSetColor(255, 139, 139);
	} else {
		ofSetColor(118, 255, 167);
	}
	ofFill();
	ofCircle(ofGetScreenWidth()/2, ofGetScreenHeight()/2, beat_radius_);
	ofPopStyle();
}

//--------------------------------------------------------------
void testApp::exit(){
	ofSoundStreamStop();
	[manekkoDelegate_ release];
	[wist_ release];
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	if (wist_.isConnected == NO) {
		[wist_ searchPeer];
	} else {
		[wist_ sendStartCommand:now_ns() withTempo:beat_per_minutes_];
	}
}

//--------------------------------------------------------------
void testApp::startCommandReceived(Time hostTime, float tempo) {
	ofLog(OF_LOG_NOTICE) << "host: " << hostTime << ", local: " << now_ns();
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
