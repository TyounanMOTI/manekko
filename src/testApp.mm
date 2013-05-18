#include "testApp.h"
#include "GameKit/GameKit.h"
#include <cmath>
#include <cstring>

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
	beat_radius_ = 1;
	beat_max_radius_ = ofGetScreenWidth() * 0.4;
	beat_min_radius_ = beat_max_radius_ * 0.5;
	int shrink_speed_per_beat = beat_max_radius_ - beat_min_radius_;
	beat_shrink_speed_per_frame_ = shrink_speed_per_beat * BPMtoBeatPerFrame(beat_per_minutes_);
	
	// Timer init
	start_time_ = 0;

	// sound stream init
	ofSoundStreamSetup(1, 0);
	ofSoundStreamStart();

	// sound player init
	kick_player_.loadSound("kick.caf");
	snare_player_.loadSound("tech_snare.caf");

	// WIST init
	wist_ = [[KorgWirelessSyncStart alloc] init];
	manekkoDelegate_ = [[WISTManekkoDelegate alloc] init:this];
	wist_.delegate = manekkoDelegate_;
	// latency of ofSoundPlayer can be 10ms
	// (256samples buffer for 44100Hz, plus safety, then 10ms)
	wist_.latency = 10 * (1000 * 1000);

	// start pairing
	[wist_ searchPeer];
}

double testApp::BPMtoBeatPerFrame(int BPM) {
	return BPM / (60.0 /* min/sec */) / ofGetFrameRate();
}

//--------------------------------------------------------------
void testApp::update() {
	shrinkBeatCircle();
	ofSoundUpdate();
}

void testApp::shrinkBeatCircle() {
	beat_radius_ -= beat_shrink_speed_per_frame_;

	// avoid circle radius going to negative value
	if (beat_radius_ < 1) {
		beat_radius_ = 1;
	}
}

void testApp::audioRequested(float *output, int bufferSize, int nChannels) {
	std::memset(output, 0, bufferSize);

	// start synchronizing beat with host
	if (!is_beat_sync_started_ && mach_absolute_time() > start_time_) {
		beat_radius_ = beat_max_radius_;
		is_beat_sync_started_ = YES;
	}

	if (is_beat_sync_started_) {
		// Maximize beat circle 
		// use audioRequested callback for exact quantization
		// http://forum.openframeworks.cc/index.php?&topic=3404.0
		beatTiming(hostTimeToMillisecTime(mach_absolute_time() - start_time_));
	}
}

void testApp::beatTiming(MillisecTime now_ms) {
	MillisecTime interval_ms = 60 * 1000 / beat_per_minutes_;

	// to avoid no beating, 10ms torelance will be need.
	if (now_ms % interval_ms < 10) {
		beat_radius_ = beat_max_radius_;
		kick_player_.play();
	}
}

// HostTime -> MillisecTime
// HostTime isn't like neither nanosec, millisec nor seconds.
// so we need to convert using mach_timebase_info.
testApp::MillisecTime testApp::hostTimeToMillisecTime(HostTime hostTime) {
	mach_timebase_info_data_t timebase_info;
	mach_timebase_info(&timebase_info);
	
	return hostTime * timebase_info.numer / timebase_info.denom / (1000 * 1000);
}

//--------------------------------------------------------------
void testApp::draw(){
	// draw beat circle
	if (wist_.isConnected && wist_.isMaster) {
		// if Master, beats Red circle
		ofSetColor(255, 139, 139);
	} else {
		ofSetColor(118, 255, 167);
	}
	ofFill();
	ofCircle(ofGetScreenWidth()/2, ofGetScreenHeight()/2, beat_radius_);
}

//--------------------------------------------------------------
void testApp::exit(){
	ofSoundStreamStop();
	[manekkoDelegate_ release];
	[wist_ release];
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	// if you are master, let slave sync beat with you.
	if (wist_.isConnected && wist_.isMaster) {
		HostTime now = mach_absolute_time();
		[wist_ sendStartCommand:now withTempo:beat_per_minutes_];

		// there are latency of bluetooth network, sound and so on.
		// start time will be future.
		start_time_ = [wist_ estimatedLocalHostTime:now];
	}

	// only slave can play snare on touch
	if (wist_.isMaster == NO) {
		snare_player_.play();
	}
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	
}

//--------------------------------------------------------------
void testApp::startCommandReceived(HostTime hostTime, float tempo) {
	// you are slave. let's sync beat with your master.
	start_time_ = hostTime;
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
