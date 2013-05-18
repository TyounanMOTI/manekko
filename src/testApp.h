#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "KorgWirelessSyncStart.h"
#import "WISTManekkoDelegate.h"
#import <mach/mach_time.h>

@class WISTManekkoDelegate;

class testApp : public ofxiPhoneApp {

	typedef uint64_t Time;

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

	void setTimeOffset(Time hostTime); // nano seconds

private:
	ofVec2f previous_touch_position_;
	ofVec2f current_touch_position_;

	int beat_radius_;
	int beat_max_radius_;
	int beat_min_radius_;
	int beat_shrink_speed_per_frame_;
	int beat_per_minutes_;
	Time time_offset_ns_;
	mach_timebase_info_data_t timebase_info_;

	KorgWirelessSyncStart *wist_;
	WISTManekkoDelegate *manekkoDelegate_;

	double beatPerFrame(int BPM);
	void drawBPMSetting();
	void drawBeat();
	Time now_ms();
	void shrinkBeatCircle();
};
