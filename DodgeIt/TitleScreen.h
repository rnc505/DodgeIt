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
@protocol ModalViewDelegate

- (void)didReceiveMessage:(NSString *)message;

@end
#import "NSUserDefaults+MPSecureUserDefaults.h"
@interface TitleScreen : CCLayer <ModalViewDelegate>
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
-(void)seedRandomTransition;
-(void)removeAllAds;
@property (nonatomic, retain) IBOutlet CCSprite *background;
@property (nonatomic, retain) IBOutlet CCSprite *DodgeText;
@property (nonatomic, retain) IBOutlet CCSprite *ItText;
@property (nonatomic, retain) IBOutlet CCSprite *FastMode;
@property (nonatomic, retain) IBOutlet CCSprite *SlowMode;
@property (nonatomic, retain) IBOutlet CCSprite *MediumMode;
@property (nonatomic, retain) IBOutlet CCSprite *Settings;
@property (nonatomic, retain) IBOutlet CCSprite *highScores;
@property (nonatomic, retain) IBOutlet CCSprite *player1;
@property (nonatomic, assign) IBOutlet float _bgRed;
@property (nonatomic, assign) IBOutlet float _bgGreen;
@property (nonatomic, assign) IBOutlet float _bgBlue;
@property (nonatomic, retain) IBOutlet CCMenu *gameModes;
@property (nonatomic, copy) IBOutlet NSArray *ballsA;
@property (nonatomic, retain) IBOutlet NSMutableArray *ballsMotionA;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
//@property (nonatomic, retain) IBOutlet UIButton *feedbackButton;
@end
