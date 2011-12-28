//
//  AppDelegate.m
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "TestFlight.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"
#import "TitleScreen.h"
#import "OpenFeint/OpenFeint.h"
#import "AppOFDelegate.h"
#import "OFConstants.h"
#define save [NSUserDefaults standardUserDefaults]
#define pupnames [NSArray arrayWithObjects:POWER_DE_BALL,POWER_DE_PLAYER,POWER_INVINCIBILITY,POWER_REVERSE_GUN,POWER_SHIELD,POWER_SHIELD_MULTI,POWER_SLOW_BALL,POWER_STUN_GUN, nil]
#define validno valid = NO;
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
    [NSUserDefaults setSecret:@"1fd94c848adee8763c2ee5464802590c7ac456dd521765926916d3bcf6a6c73135f5eceeb1498c04aa984bed0e244e661368f8641534558f4d842e2d15df0c52"];//SHA-512 Hash of my full name
	[NSUserDefaults setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
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
	[director setDisplayFPS:NO];
	
	
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
    //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"gamemusic.mp3"];
    
    //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"mainmenu.caf"];
    [TestFlight takeOff:@"07e5f872adf04a6a0c109b1cf2144e4e_NTAxNTYyMDExLTEyLTI4IDA5OjI5OjQ3Ljg0MTAyMw"];
    
}

-(void)setUpAndRetrieveData
{
    powerups = [[NSMutableArray alloc] init];
    BOOL valid = NO;
   // if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dateKey"] == nil) {
    if([save secureBoolForKey:@"First Run?" valid:&valid]){
        validno;
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dateKey", nil];
        
        [save setSecureBool:NO forKey:@"First Run?"];
        [save setSecureBool:NO forKey:POWER_DE_BALL];
        [save setSecureBool:NO forKey:POWER_DE_PLAYER];
        [save setSecureBool:NO forKey:POWER_SLOW_BALL];
        [save setSecureBool:NO forKey:POWER_SHIELD];
        [save setSecureBool:NO forKey:POWER_INVINCIBILITY];
        [save setSecureBool:NO forKey:POWER_STUN_GUN];
        [save setSecureBool:NO forKey:POWER_REVERSE_GUN];
        [save setSecureBool:NO forKey:POWER_PACMAN];
        [save setSecureBool:NO forKey:POWER_SHIELD_MULTI];
        
        [save setSecureInteger:0 forKey:@"SlowHighScore"];
        [save setSecureInteger:0 forKey:@"MediumHighScore"];
        [save setSecureInteger:0 forKey:@"FastHighScore"];
        [save setSecureInteger:0 forKey:@"CumulativeScore"];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"firstrun");
    }
    validno;
    /*if([save secureBoolForKey:POWER_DE_BALL])
        [powerups addObject:POWER_DE_BALL];
    if([save secureBoolForKey:POWER_SLOW_BALL])
        [powerups addObject:POWER_SLOW_BALL];
    if([save secureBoolForKey:POWER_DE_PLAYER])
        [powerups addObject:POWER_DE_PLAYER];
    if([save secureBoolForKey:POWER_SHIELD])
        [powerups addObject:POWER_SHIELD];
    if([save secureBoolForKey:POWER_INVINCIBILITY])
        [powerups addObject:POWER_INVINCIBILITY];
    if([save secureBoolForKey:POWER_STUN_GUN])
        [powerups addObject:POWER_STUN_GUN];
    if([save secureBoolForKey:POWER_REVERSE_GUN])
        [powerups addObject:POWER_REVERSE_GUN];
    if([save secureBoolForKey:POWER_PACMAN])
     [powerups addObject:POWER_PACMAN];
    if([save secureBoolForKey:POWER_SHIELD_MULTI])
        [powerups addObject:POWER_SHIELD_MULTI];*/
    for(int j = 0;j<[pupnames count];j++){
        // (NSString*)[POWERUP_NAMES objectAtIndex:j]
        validno;
        BOOL activated = [save secureBoolForKey:(NSString*)[pupnames objectAtIndex:j] valid:&valid];
        if(!valid){
            NSLog(@"The Powerup: %@ has been Modified",(NSString*)[pupnames objectAtIndex:j]);
        } else {
            if(activated)
                [powerups addObject:(NSString*)[pupnames objectAtIndex:j]];
        }
        
    }
    
    
    for(int i =0;i<powerups.count;i++){
        NSLog(@"POWERUP ENABLED: %@",[powerups objectAtIndex:i]);
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // if([[[CCDirector sharedDirector] runningScene] isEqual:[HelloWorldLayer class]]){
        
	[[CCDirector sharedDirector] pause];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Interruption" object:nil];
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
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	
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
    //[deviceIdentifier release];
	[super dealloc];
}

-(void)displayGoogleAd:(CGSize)adSize{
    [viewController addAdMobBanner:adSize];
}



-(void)removeGoogleAd{
    [viewController removeAdMobBanner];
}
-(void)showInfoPane{
    [viewController showInfoPane];
}

@synthesize mode,powerups,running;//,deviceIdentifier;
@end
