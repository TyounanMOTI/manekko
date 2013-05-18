#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "KorgWirelessSyncStart.h"
#import "WISTManekkoDelegate.h"
#import <mach/mach_time.h>

@class WISTManekkoDelegate;

class testApp : public ofxiPhoneApp {

	typedef int64_t MillisecTime;
	typedef uint64_t HostTime;

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

	void startCommandReceived(HostTime hostTime, float tempo);

private:
	ofVec2f previous_touch_position_;
	ofVec2f current_touch_position_;

	int beat_radius_;
	int beat_max_radius_;
	int beat_min_radius_;
	int beat_shrink_speed_per_frame_;
	int beat_per_minutes_;
	
	HostTime start_time_ = 0;
	BOOL is_beat_started = NO;

	KorgWirelessSyncStart *wist_;
	WISTManekkoDelegate *manekkoDelegate_;

	ofSoundPlayer kick_player_;
	ofSoundPlayer snare_player_;

	double beatPerFrame(int BPM);
	void drawBPMSetting();
	void drawBeat();
	MillisecTime hostTimeToMillisec(HostTime hostTime);
	void shrinkBeatCircle();
	void beatTiming(MillisecTime now_ms);
};
