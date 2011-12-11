//
//  OFDelegate.h
//  Drop Dead
//
//  Created by Ameesh Kapoor on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenFeint/OpenFeintDelegate.h"
#import "cocos2d.h"

@interface AppOFDelegate : NSObject< OpenFeintDelegate >

- (void)dashboardWillAppear;
- (void)dashboardDidAppear;
- (void)dashboardWillDisappear;
- (void)dashboardDidDisappear;
- (void)userLoggedIn:(NSString*)userId;
- (BOOL)showCustomOpenFeintApprovalScreen;

@end
