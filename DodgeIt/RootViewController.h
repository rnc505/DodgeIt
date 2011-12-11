//
//  RootViewController.h
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"


@interface RootViewController : UIViewController {
    GADBannerView *gADBbannerView;
}
-(void) addAdMobBanner:(CGSize)adSize;
-(void)removeAdMobBanner;




@end
