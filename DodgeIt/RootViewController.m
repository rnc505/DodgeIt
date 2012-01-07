//
//  RootViewController.m
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "GameConfig.h"
#import "InfopaneViewController.h"
#import "TitleScreen.h"
#define UIAppDelegate \
((AppDelegate *)[UIApplication sharedApplication].delegate)
@implementation RootViewController
@synthesize bannerView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
 }
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsPortrait( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.bannerView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    gADBbannerView.delegate = nil;
    [gADBbannerView release];
    self.bannerView = nil;
    bannerView.delegate = nil;
    [bannerView release];
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//self.bannerView = nil;
    [super dealloc];
}

-(void)showInfoPane
{
    InfopaneViewController *vc = [[[InfopaneViewController alloc] initWithNibName:@"InfopaneViewController" bundle:nil]autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:vc]autorelease];  
    //vc.delegate = self;
   // vc.delegate = [TitleScreen node];//(TitleScreen*)[[CCDirector sharedDirector]notificationNode];//[TitleScreen ];
    [self presentModalViewController:navigationController animated:YES];
   // [self.view addSubview:navigationController.view];
}
static NSString * const kADBannerViewClass = @"ADBannerView";

-(void)showiAd
{
    CGSize adSize = CGSizeMake(320, 50);
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    if(NSClassFromString(kADBannerViewClass) != nil)
       {
           self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(winSize.width-adSize.width, winSize.height-adSize.height,
                                                                                           
                                                                                           adSize.width,
                                                                                           adSize.height)];
           [self.bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                               ADBannerContentSizeIdentifier320x50,
                                                               ADBannerContentSizeIdentifier480x32, nil]];
           self.bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
           [self.bannerView setDelegate:self];
           [self.view addSubview:self.bannerView];
           NSLog(@"iAd Has been Added to VIEWS");
       }
}


-(void)removeiAd
{
    NSLog(@"iAd has been Removed from Views");
    [bannerView removeFromSuperview];
    [bannerView release];
}

-(void)removeAdMobBanner{
    NSLog(@"Removeding adMob");
    //NSLog(@"remove google ad");
    [gADBbannerView removeFromSuperview];
    [gADBbannerView release];
    //gADBbannerView=nil;
}




-(void) addAdMobBanner:(CGSize)adSize{
    NSLog(@"adding Admob");
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    // Create a view of the standard size at the bottom of the screen.
    gADBbannerView = [[GADBannerView alloc]
                      initWithFrame:CGRectMake(winSize.width-adSize.width, winSize.height-adSize.height,
                                               
                                               adSize.width,
                                               adSize.height)];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    gADBbannerView.adUnitID = @"a14ee431a717a8f";
    
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    gADBbannerView.rootViewController = self;
    gADBbannerView.tag = 99599;
    [self.view addSubview:gADBbannerView];
    
    [gADBbannerView loadRequest:[GADRequest request]];
    
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

- (void)adViewDidReceiveAd:(GADBannerView *)abannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    abannerView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  abannerView.frame.size.height,
                                  abannerView.frame.size.width,
                                  abannerView.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark ADBannerViewDelegate

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    if([[CCDirector sharedDirector] isPaused]){
        [[CCDirector sharedDirector] resume];
    }
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"fail");
    [UIAppDelegate displayGoogleAd:CGSizeMake(320, 50)];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    if(!willLeave){
        [[CCDirector sharedDirector] pause];
    }
    return YES;
}

@end
