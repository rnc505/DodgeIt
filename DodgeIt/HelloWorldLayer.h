//
//  HelloWorldLayer.h
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "OpenFeint/OFLeaderboardService.h"
#import "OpenFeint/OFLeaderboard.h"
#import "OpenFeint/OFHighScoreService.h"
#import "OpenFeint/OFHighScore.h"
#import "OpenFeint/OFAchievementService.h"
#import "OpenFeint/OFAchievement.h"

#import "NSUserDefaults+MPSecureUserDefaults.h"
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
    CCSprite *ball;
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
    BOOL valid;
    bool congrats;
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
    OFLeaderboard *board;
    OFHighScore *score;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
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
-(void)playAgain;

@property (nonatomic, retain) CCSprite *powerup;
@property (nonatomic, retain) IBOutlet NSMutableArray *balls;
@property (nonatomic, retain) IBOutlet NSMutableArray *ballsMotion;
@property (nonatomic, retain) IBOutlet NSMutableArray *fileNames;
@property (nonatomic, retain) IBOutlet CCSprite *player;
@property (nonatomic, retain) IBOutlet CCSprite *pauseBtn;
@property (nonatomic, retain) IBOutlet CCSprite *background;
@property (nonatomic, retain) IBOutlet CCLabelBMFont *scoreLabel;
@property (nonatomic, retain) IBOutlet CCLabelBMFont *powerupLabel;
@property (nonatomic, assign) IBOutlet float daScore;
@property (nonatomic, retain) IBOutlet CCLayer *pauseLayer;
@property (nonatomic, retain) IBOutlet CCMenu *pauseMenu;
@property (nonatomic, assign) IBOutlet double dxColor;
@property (nonatomic, assign) IBOutlet double dyColor;
@property (nonatomic, assign) IBOutlet float redPlayer;
@property (nonatomic, assign) IBOutlet float greenPlayer;
@property (nonatomic, assign) IBOutlet float bluePlayer;
@property (nonatomic, assign) IBOutlet float bgRed;
@property (nonatomic, assign) IBOutlet float bgGreen;
@property (nonatomic, assign) IBOutlet float bgBlue;
@property (nonatomic, assign) IBOutlet int randomPWR;
@property (nonatomic, assign) IBOutlet int whichPowerUp;
@property (nonatomic, retain) IBOutlet CCLayerColor *poweruplayer;
@property (nonatomic, assign) IBOutlet float countdown;
@property (nonatomic, assign) IBOutlet int usage;
@property (nonatomic, retain) IBOutlet CCSprite *shield;
@property (nonatomic, retain) IBOutlet CCSprite *shieldmult;
@property (nonatomic, retain) IBOutlet CCSprite *ball;
@property (nonatomic, retain) IBOutlet OFLeaderboard *board;
@property (nonatomic, retain) IBOutlet OFHighScore *score;
@end
