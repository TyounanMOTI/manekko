//
//  WISTManekkoDelegate.h
//  manekko
//

#import <Foundation/Foundation.h>
#import "KorgWirelessSyncStart.h"
#include "testApp.h"

class testApp;

@interface WISTManekkoDelegate : NSObject <KorgWirelessSyncStartDelegate>
{
@private
	testApp *app_;
}

- (id)init:(testApp*)app;
@end
