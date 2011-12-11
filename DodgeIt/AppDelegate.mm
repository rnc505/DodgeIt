//
//  AppDelegate.m
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"
#import "TitleScreen.h"
#import "OpenFeint/OpenFeint.h"
#import "AppOFDelegate.h"
#import "OFConstants.h"
#define save [NSUserDefaults standardUserDefaults]
@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
    
    //	CC_ENABLE_DEFAULT_GL_STATES();
    //	CCDirector *director = [CCDirector sharedDirector];
    //	CGSize size = [director winSize];
    //	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
    //	sprite.position = ccp(size.width/2, size.height/2);
    //	sprite.rotation = -90;
    //	[sprite visit];
    //	[[director openGLView] swapBuffers];
    //	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	mode = 0;
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	//[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene]];
    [[CCDirector sharedDirector] runWithScene: [TitleScreen scene]];
    [glView setMultipleTouchEnabled:YES];
    
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInt:UIInterfaceOrientationPortrait], OpenFeintSettingDashboardOrientation,
							  @"DodgeIt", OpenFeintSettingShortDisplayName,
							  [NSNumber numberWithBool:YES], OpenFeintSettingEnablePushNotifications,
                              [NSNumber numberWithInt:OFDevelopmentMode_DEVELOPMENT],
                              OpenFeintSettingDevelopmentMode,
							  nil];
	
	ofDelegate = [AppOFDelegate new];
    
	OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:ofDelegate
                                       ];
    
    
    [OpenFeint initializeWithProductKey:@"GgYT5o6WQjEbruXGXsWCtA"
							  andSecret:@"T5vNs2T1chyeMRRBtG5X8DARgU7l16HLEximEhs"
						 andDisplayName:@"DodgeIt"
							andSettings:settings
						   andDelegates:delegates];
    
    [self setUpAndRetrieveData];
    
    
}

-(void)setUpAndRetrieveData
{
    powerups = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dateKey"] == nil) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dateKey", nil];
        [save setBool:NO forKey:POWER_DE_BALL];
        [save setBool:NO forKey:POWER_DE_PLAYER];
        [save setBool:NO forKey:POWER_SLOW_BALL];
        [save setBool:NO forKey:POWER_SHIELD];
        [save setBool:NO forKey:POWER_INVINCIBILITY];
        [save setBool:NO forKey:POWER_STUN_GUN];
        [save setBool:NO forKey:POWER_REVERSE_GUN];
        [save setBool:NO forKey:POWER_PACMAN];
        [save setBool:NO forKey:POWER_SHIELD_MULTI];
        
        [save setInteger:0 forKey:@"SlowHighScore"];
        [save setInteger:0 forKey:@"MediumHighScore"];
        [save setInteger:0 forKey:@"FastHighScore"];
        [save setInteger:0 forKey:@"CumulativeScore"];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"firstrun");
    }
    if([save boolForKey:POWER_DE_BALL])
        [powerups addObject:POWER_DE_BALL];
    if([save boolForKey:POWER_SLOW_BALL])
        [powerups addObject:POWER_SLOW_BALL];
    if([save boolForKey:POWER_DE_PLAYER])
        [powerups addObject:POWER_DE_PLAYER];
    if([save boolForKey:POWER_SHIELD])
        [powerups addObject:POWER_SHIELD];
    if([save boolForKey:POWER_INVINCIBILITY])
        [powerups addObject:POWER_INVINCIBILITY];
    if([save boolForKey:POWER_STUN_GUN])
        [powerups addObject:POWER_STUN_GUN];
    if([save boolForKey:POWER_REVERSE_GUN])
        [powerups addObject:POWER_REVERSE_GUN];
    /*if([save boolForKey:POWER_PACMAN])
     [powerups addObject:POWER_PACMAN];*/
    if(![save boolForKey:POWER_SHIELD_MULTI])
        [powerups addObject:POWER_SHIELD_MULTI];
    
    for(int i =0;i<powerups.count;i++){
        NSLog(@"POWERUP ENABLED: %@",[powerups objectAtIndex:i]);
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // if([[[CCDirector sharedDirector] runningScene] isEqual:[HelloWorldLayer class]]){
        
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    if(running == 100){ 
        //[(HelloWorldLayer *)[[CCDirector sharedDirector] ] pauseGame];
        // [HelloWorldLayer backgroundPause];
        // [HelloWorldLayer outPutData];
        NSLog(@"suppsoed t o have cfllased this");
       //£ [[[CCDirector sharedDirector] runningScene] pauseSchedulerAndActions];
    }
    NSLog(@"becoming active");
    
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    if(running == 100){ 
        //[(HelloWorldLayer *)[[CCDirector sharedDirector] ] pauseGame];
       // [HelloWorldLayer backgroundPause];
        // [HelloWorldLayer outPutData];
        NSLog(@"suppsoed t o have cfllased this");
    }
    NSLog(@"resigning");
    NSLog(@"%@",[[[CCDirector sharedDirector] runningScene] description]);

	[[CCDirector sharedDirector] stopAnimation];
    NSLog(@"entering bckground");
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
    NSLog(@"entering foreground");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize]; // Add for OpenFeint
    [OpenFeint shutdown];
    NSLog(@"terminating this bih");
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
    [powerups release];
	[super dealloc];
}

-(void)displayGoogleAd:(CGSize)adSize{
    [viewController addAdMobBanner:adSize];
}
-(void)removeGoogleAd{
    [viewController removeAdMobBanner];
}

@synthesize mode,powerups,running;
@end
