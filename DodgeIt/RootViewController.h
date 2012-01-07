//
//  RootViewController.h
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <iAd/iAd.h>



@interface RootViewController : UIViewController <ADBannerViewDelegate> {
    GADBannerView *gADBbannerView;
    ADBannerView *bannerView;
    BOOL isiAdOnScreen;
    BOOL isadMobOnScreen;
}
-(void) addAdMobBanner:(CGSize)adSize;
-(void)removeAdMobBanner;
-(void)showInfoPane;
-(void)showiAd;
-(void)removeiAd;

@property (nonatomic, retain) ADBannerView *bannerView;

@end
