//
//  OFDelegate.m
//  Drop Dead
//
//  Created by Ameesh Kapoor on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppOFDelegate.h"
#import "OpenFeint/OpenFeint+UserOptions.h"

@implementation AppOFDelegate

- (void)dashboardWillAppear
{
	[[CCDirector sharedDirector] pause];
}

- (void)dashboardDidAppear
{
}

- (void)dashboardWillDisappear
{
}

- (void)dashboardDidDisappear
{
	[[CCDirector sharedDirector] resume];
}

- (void)offlineUserLoggedIn:(NSString*)userId
{
	NSLog(@"User logged in, but OFFLINE. UserId: %@", userId);
}

- (void)userLoggedIn:(NSString*)userId
{
	NSLog(@"User logged in. UserId: %@", userId);
}

- (BOOL)showCustomOpenFeintApprovalScreen
{
	return NO;
}

@end

