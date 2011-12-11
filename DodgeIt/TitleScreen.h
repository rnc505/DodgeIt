//
//  
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
//#import "GADBannerView.h"
//#import "RootViewController.h"
// HelloWorldLayer
@interface TitleScreen : CCLayer
{
  //  GADBannerView *bannerView_;
  //  RootViewController *vCont;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)colorTheBackground;
-(void)commenceColor;
-(void)colorTheBackground2;
-(void)colorTheTitle;
-(void)colorTheHISettings;
-(void)colorTheModes;
-(void)colorTheBalls;
-(float)getXMovement;
-(float)getYMovement:(float)dx;
-(void)runTests;
@end
