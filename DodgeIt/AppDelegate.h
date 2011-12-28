//
//  AppDelegate.h
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenFeint/OpenFeintDelegate.h"
#import "AppOFDelegate.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"
@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    int mode;
    AppOFDelegate		*ofDelegate;
    NSMutableArray      *powerups;
    int running;
   
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, assign) int mode;

@property (readwrite, assign) int running;
@property (nonatomic, retain) NSMutableArray *powerups;
-(void)setUpAndRetrieveData;
-(void)displayGoogleAd:(CGSize)adSize;
-(void)removeGoogleAd;
-(void)showInfoPane;

@end
