#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "KorgWirelessSyncStart.h"
#import "WISTManekkoDelegate.h"

class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	void touchCancelled(ofTouchEventArgs &touch);

	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);

	void audioRequested( float * output, int bufferSize, int nChannels );
	
private:
	typedef unsigned long long TimeMillis;

	ofVec2f previous_touch_position_;
	ofVec2f current_touch_position_;

	int beat_radius_;
	int beat_per_minutes_;
	int last_beat_time_ms_;

	KorgWirelessSyncStart *wist_;
	WISTManekkoDelegate *manekkoDelegate_;

	void drawBPMSetting();
};


