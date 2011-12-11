//
//  HelloWorldLayer.h
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    CCSprite *powerup;
    NSMutableArray *balls;
    NSMutableArray *ballsMotion;
    NSMutableArray *fileNames;
    bool started;
    bool fingerDown;
    CCSprite *player;
    CCSprite *pauseBtn;
    CCSprite *background;
    CCLabelBMFont * scoreLabel;
    CCLabelBMFont *powerupLabel;
    float daScore;
    CCLayer *pauseLayer;
    CCMenu *pauseMenu;
    bool isGamePaused;
    double dxColor;
    double dyColor;
    float redPlayer;
    float greenPlayer;
    float bluePlayer;
    float bgRed;
    float bgGreen;
    float bgBlue;
    bool bgRedFull;
    bool bgGreenFull;
    bool bgBlueFull;
    
    int dotProduct;
    bool isPowerUpOnScreen;
    int randomPWR;
    int whichPowerUp;
    CCLayerColor *poweruplayer;
    bool isPowerupLayerOnScreen;
    float countdown;
    int usage;
    CCSprite *shield;
    CCSprite *shieldmult;
    bool backgroundPaused;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene:(NSInteger*)mode;
-(void)diedAlert;
-(void)reset;
-(void)pauseGame;
-(float)asbs:(CGPoint)_arrowPos ballPos:(CGPoint)_ballPos;
-(float)getXMovement;
-(float)getYMovement:(float)dx;
-(void)controlBackgroundColor;
-(void)changeColor;
-(void)checkAchievementsAndUploadScore;
-(CGPoint)randomPowerupLocation;
-(NSString*)getPowerUpImage:(NSString*)name;
-(void)checkALL_30K;
-(void)checkALL_60K;
-(void)checkALL_120K;
-(void)checkALL_500K;
-(void)activatePowerup;
-(void)removePWR;
+(void)backgroundPause;
+(void)outPutData;
@property (nonatomic, retain) CCSprite *powerup;
@end
