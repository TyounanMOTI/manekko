//
//  WISTManekkoDelegate.m
//  manekko
//

#import "WISTManekkoDelegate.h"
#include "ofLog.h"
#include "testApp.h"

@implementation WISTManekkoDelegate
- (id)init:(testApp*)app {
	self = [super init];
	app_ = app;
	return self;
}

- (void)wistStartCommandReceived:(uint64_t)hostTime withTempo:(float)tempo {
}

- (void)wistStopCommandReceived:(uint64_t)hostTime {
	
}

- (void)wistConnectionEstablished {
	ofLog(OF_LOG_NOTICE, "paired");
}

@end
