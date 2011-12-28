//
//  HelloWorldLayer.m
//  DodgeIt
//
//  Created by Android on 11/3/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "CCTouchDispatcher.h"// HelloWorldLayer implementation
#import "AppDelegate.h"
#import "OpenFeint/OpenFeintDelegate.h"
#import "TitleScreen.h"
#import "OpenFeint/OpenFeint.h"
#import "OFConstants.h"
#import <AudioToolbox/AudioToolbox.h>
#define UIAppDelegate \
((AppDelegate *)[UIApplication sharedApplication].delegate)
#define save [NSUserDefaults standardUserDefaults]
#define validno valid = NO;
#define pupnames [NSArray arrayWithObjects:POWER_DE_BALL,POWER_DE_PLAYER,POWER_INVINCIBILITY,POWER_REVERSE_GUN,POWER_SHIELD,POWER_SHIELD_MULTI,POWER_SLOW_BALL,POWER_STUN_GUN, nil]

@implementation HelloWorldLayer
@synthesize board;
@synthesize score;
@synthesize balls;
@synthesize ballsMotion;
@synthesize fileNames;
@synthesize player;
@synthesize pauseBtn;
@synthesize background;
@synthesize scoreLabel;
@synthesize powerupLabel;
@synthesize daScore;
@synthesize pauseLayer;
@synthesize pauseMenu;
@synthesize dxColor;
@synthesize dyColor;
@synthesize redPlayer;
@synthesize greenPlayer;
@synthesize bluePlayer;
@synthesize bgRed;
@synthesize bgGreen;
@synthesize bgBlue;
@synthesize randomPWR;
@synthesize whichPowerUp;
@synthesize poweruplayer;
@synthesize countdown;
@synthesize usage;
@synthesize ball;
@synthesize shield;
@synthesize shieldmult;

int colorInc = 5;
  int dotProduct;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
    layer.tag = 123456;
	
	// add layer as a child to scene
	[scene addChild: layer];
	//srand(time(NULL));
	// return the scene
  //  CCLOG(@"mode: %i",(int)mode);
    /*switch ((int)mode) {
        case 1:
            dotProduct = 150;
            break;
        case 2:
            dotProduct = 100;
            break;
        case 3:
            dotProduct = 75;
            break;
    }*/
	return scene;
}

/*-(void) registerWithTouchDispatcher
 {
 [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
 }*/


/*- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
 NSLog(@"TOUCH");
 NSString *whichBall = [fileNames objectAtIndex:(rand()%4)];
 NSLog(@"%@",whichBall);
 CCSprite *ball = [CCSprite spriteWithFile:whichBall];
 int randXValue = (rand() % 320) + 1;
 int randYValue = (rand() % 480) + 1;
 ball.position = ccp(randXValue, randYValue);
 NSValue *move = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
 [balls addObject:ball];
 [ballsMotion addObject:move];
 [self addChild:ball];
 move = nil;
 ball = nil;
 return YES;
 }*/


-(void)pauseGame
{
    //if(!started)
      //  return;
    NSLog(@"GAME IS PAUSING RIGHT NOW!");
    // [[CCDirector sharedDirector] pause];
    [self pauseSchedulerAndActions];
    self.isTouchEnabled = NO;
    CGSize s = [[CCDirector sharedDirector] winSize];
    pauseLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0) width: 100 height: 100];
    pauseLayer.position = ccp(s.width/2, s.height/2);
    pauseLayer.isRelativeAnchorPoint = YES;
 
    //pauseLayer.isTouchEnabled = NO;
    [self addChild:pauseLayer];
    // CCMenuItem *resume = [CCMenuItemImage itemFromNormalImage:@"resume-game.png" selectedImage:@"resume-game-pressed.png" target:self selector:@selector(resumeGame:)];
    //  CCMenuItem *mainMenu = [CCMenuItemImage itemFromNormalImage:@"main-menu2.png" selectedImage:@"main-menu2-pressed.png" target:self selector:@selector(mainMenu:)];
    [pauseLayer runAction:[CCScaleTo actionWithDuration:.5 scaleX:3.2 scaleY:4.8]];
    [pauseLayer runAction:[CCFadeTo actionWithDuration:.5 opacity:130]];
    pauseMenu = [CCMenu menuWithItems:[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Resume Game"  fontName:@"Arial" fontSize:24] target:self selector:@selector(resumeGame:)], [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Return to Menu" fontName:@"Arial" fontSize:24] target:self selector:@selector(goHome:)], nil];
    [pauseMenu alignItemsVerticallyWithPadding:25];
    [pauseMenu setPosition:ccp(pauseLayer.position.x, pauseLayer.position.y-30)];
    [self addChild:pauseMenu z:10];
    // ccColor4B c ={0,0,0,10};
	//[PauseLayer layerWithColor:c delegate:self];
    NSLog(@"hello pause");
    
    
}

-(void)goHome:(id)sender
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeTR transitionWithDuration:0.5f scene:[TitleScreen scene]]];
    
}

-(void)resumeGame: (id)sender {
    backgroundPaused = NO;
    [self removeChild:pauseMenu cleanup:YES];
    [pauseLayer runAction:[CCFadeTo actionWithDuration:.5 opacity:0]];
    [pauseLayer runAction:[CCSequence actions:[CCScaleTo actionWithDuration:.5 scaleX:(1/1.6) scaleY:(1/2.4)],[CCCallBlock actionWithBlock:(^{
        
        [self removeChild:pauseLayer cleanup:YES];
        [self resumeSchedulerAndActions];
        isGamePaused=NO;
        
    })],nil]];
    
    
    //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundmusic.mp3"];
    // [[CCDirector sharedDirector] resume];
    
    // pauseButtonStatus = 0;
    
    self.isTouchEnabled = YES;
}
-(void)ccTouchesBegan:(NSSet *)touch withEvent:(UIEvent *)event {
    NSLog(@"is started? %@",started ? @"YES" :@"NO");
    CGPoint location = [self convertTouchToNodeSpace: [[touch allObjects] objectAtIndex:0]];
    CGPoint location2;
    if(!isGamePaused){
        switch ([[touch allObjects] count]) {
            case 1:
                if(!started){ 
                    [self schedule:@selector(nextFrame:)];
                    started = YES;
                    daScore = 0;
                    //[self schedule:@selector(placepowerupUp) interval:5.0];
                    NSLog(@"scheduling placepowerup");
                    [self schedule:@selector(placePowerUp) interval:15.0f];
                    NSLog(@"placepowerup scheduled");
                }
                if(started){
                    bool xYES = location.x < player.position.x + ([player boundingBox].size.width/2) && location.x > player.position.x - ([player boundingBox].size.width/2);
                    bool yYES = location.y < player.position.y + ([player boundingBox].size.height/2) && location.y > player.position.y - ([player boundingBox].size.height/2);
                    if(xYES && yYES){
                        fingerDown = YES;
                        NSLog(@"you are touching!");   
                    }
                    
                }
                
                /* CGRect pauseBtnrect = CGRectMake(pauseBtn.position.x - [pauseBtn contentSize].width/2, pauseBtn.position.y - [pauseBtn contentSize].height/2, [pauseBtn contentSize].width, [pauseBtn contentSize].height);
                 
                 if(CGRectContainsPoint(pauseBtnrect, location))
                 {
                 if(!isPaused){
                 [self pauseGame];
                 isPaused = YES;
                 }
                 }*/
                
                if(whichPowerUp == 600 || whichPowerUp == 700){
                    //NSMutableArray *boxes = [[NSMutableArray alloc] init];
                    for(int i=0; i<balls.count;i++){
                        CCSprite *tempBall = (CCSprite*)[balls objectAtIndex:i];
                        bool xYES = location.x < tempBall.position.x + ([tempBall boundingBox].size.width/2) && location.x > tempBall.position.x - ([tempBall boundingBox].size.width/2);
                        bool yYES = location.y < tempBall.position.y + ([tempBall boundingBox].size.height/2) && location.y > tempBall.position.y - ([tempBall boundingBox].size.height/2);
                        
                        if(xYES && yYES){
                            CGPoint value123;
                            switch (whichPowerUp) {
                                case 600:
                                    value123 = CGPointMake(0, 0);
                                    [ballsMotion replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:value123]];
                                    usage = usage - 1;
                                    [self performSelector:@selector(putBackMovement:) withObject:[NSNumber numberWithInt:i] afterDelay:4.0f];
                                    NSLog(@"int : %i",i);
                                    break;
                                    
                                case 700:
                                    value123  = [((NSValue*)[ballsMotion objectAtIndex:i]) CGPointValue];
                                    value123 = CGPointMake(-1*value123.x, -1*value123.y);
                                    [ballsMotion replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:value123]];
                                    usage = usage - 1;
                                    break;
                                default:
                                    break;
                            }
                        }
                        
                        
                        
                    }
                    
                    
                }
                break;
                
            default:
                location2 = [self convertTouchToNodeSpace: [[touch allObjects] objectAtIndex:1]];
                if(whichPowerUp == 600 || whichPowerUp == 700){
                    
                    for(int i=0; i<balls.count;i++){
                        CCSprite *tempBall = (CCSprite*)[balls objectAtIndex:i];
                        bool xYES = location.x < tempBall.position.x + ([tempBall boundingBox].size.width/2) && location.x > tempBall.position.x - ([tempBall boundingBox].size.width/2);
                        bool yYES = location.y < tempBall.position.y + ([tempBall boundingBox].size.height/2) && location.y > tempBall.position.y - ([tempBall boundingBox].size.height/2);
                        
                        bool xYES2 = location2.x < tempBall.position.x + ([tempBall boundingBox].size.width/2) && location2.x > tempBall.position.x - ([tempBall boundingBox].size.width/2);
                        bool yYES2 = location2.y < tempBall.position.y + ([tempBall boundingBox].size.height/2) && location2.y > tempBall.position.y - ([tempBall boundingBox].size.height/2);
                        
                        
                        if((xYES && yYES)||(xYES2 && yYES2)){
                            CGPoint value123;
                            switch (whichPowerUp) {
                                case 600:
                                    value123 = CGPointMake(0, 0);
                                    [ballsMotion replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:value123]];
                                    usage = usage - 1;
                                    [self performSelector:@selector(putBackMovement:) withObject:[NSNumber numberWithInt:i] afterDelay:4.0f];
                                    NSLog(@"int : %i",i);
                                    break;
                                    
                                case 700:
                                    value123  = [((NSValue*)[ballsMotion objectAtIndex:i]) CGPointValue];
                                    value123 = CGPointMake(-1*value123.x, -1*value123.y);
                                    [ballsMotion replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:value123]];
                                    usage = usage - 1;
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    break;   
                }
                
                if(!isGamePaused){
                    [self pauseGame];
                    isGamePaused = YES;
                }
                break;
        }
    }
    //return YES;
   //[touchArray release];
}

-(void)putBackMovement:(NSNumber *)index
{
    NSLog(@"int : %i",[index intValue]);
    float xMovementi = [self getXMovement];//arc4random()%100;
    float yMovementi = [self getYMovement:xMovementi];//sqrtf(20000 - (xMovement*xMovement));
    NSLog(@"setting value: (%f,%f)",xMovementi,yMovementi);
    //NSValue* move12 = ;
    NSLog(@"about to replace");
    [ballsMotion replaceObjectAtIndex:[index intValue] withObject:[NSValue valueWithCGPoint:CGPointMake(xMovementi, yMovementi)]];
    NSLog(@"replace");
    //[move1 release];
    NSLog(@"released");
}

- (void)ccTouchesMoved:(NSSet *)touch withEvent:(UIEvent *)event{
    switch ([touch count]) {
        case 1:
            if(fingerDown){
                //NSArray *touchArray = [touch allObjects];
                CGPoint location = [self convertTouchToNodeSpace: [[touch allObjects] objectAtIndex:0 ]];
                player.position = location;
                //[touchArray release];
            }
            break;
            
        default:
            if(!isGamePaused){
                [self pauseGame];
                isGamePaused = YES;
            }
            break;
    }
    
    
}

-(void)ccTouchesEnded:(NSSet *)touch withEvent:(UIEvent *)event {
    if(started){
        fingerDown = NO;
    }
}
// on "init" you need to initialize your instance
-(id) init
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gamemusic.mp3" loop:YES];
    congrats =NO;
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    UIAppDelegate.running = 100;
	if( (self=[super init])) {
        backgroundPaused = NO;
        switch (UIAppDelegate.mode) {
            case 1:
                dotProduct = 150;
                break;
            case 2:
                dotProduct = 100;
                break;
            case 3:
                dotProduct = 75;
                break;
        }
        
        //[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
        background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(160,240);
        background.color = ccc3(5, 5, 5);
        [self addChild:background];
        self.isTouchEnabled = YES;
        fileNames = [[NSMutableArray alloc] initWithObjects:@"ball10.png",@"ball10.png",@"ball10.png",@"ball10.png", nil];
        balls = [[NSMutableArray alloc] init];
        ballsMotion = [[NSMutableArray alloc] init];
        /*for(int i = 0; i<=0;i++){
         NSLog(@"Creations of object: %i",i);
         NSString *whichBall = [fileNames objectAtIndex:(rand()%4)];
         NSLog(@"%@",whichBall);
         CCSprite *ball = [CCSprite spriteWithFile:whichBall];
         int randXValue = (rand() % 320) + 1;
         int randYValue = (rand() % 480) + 1;
         ball.position = ccp(randXValue, randYValue);
         ball.tag = i;
         NSValue *move = [NSValue valueWithCGPoint:CGPointMake(80, 80)];
         [balls addObject:ball];
         [ballsMotion addObject:move];
         [self addChild:ball];
         NSLog(@"End Creation of object: %i",i);
         [whichBall release];
         }*/
        
        player = [CCSprite spriteWithFile:@"playerdude3.png"];
        player.position = ccp(160,240);
        [self addChild:player];
        
        int value = arc4random()%4;//rand()%4;
        ball = [CCSprite spriteWithFile:[fileNames objectAtIndex:value]];
        [fileNames removeObjectAtIndex:value];
        ball.tag = 0;
        ball.position = ccp([ball contentSize].width, 480-[ball contentSize].height);
        float xMovement = [self getXMovement];//arc4random()%100;
        float yMovement = [self getYMovement:xMovement];//sqrtf(20000 - (xMovement*xMovement));
        NSLog(@"x: %f & y: %f",xMovement,yMovement);
        //NSValue *move = ;
        [ballsMotion addObject:[NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)]];
        [balls addObject:ball];
        [self addChild:ball];
        
        value = arc4random()%3;
        ball = [CCSprite spriteWithFile:[fileNames objectAtIndex:value]];
        [fileNames removeObjectAtIndex:value];
        ball.tag = 1;
        ball.position = ccp(320-[ball contentSize].width, 480-[ball contentSize].height);
        xMovement = [self getXMovement];//arc4random()%100;
        yMovement = [self getYMovement:xMovement];//sqrtf(20000 - (xMovement*xMovement));
        NSLog(@"x: %f & y: %f",xMovement,yMovement);
        //move = [NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)];
        [ballsMotion addObject:[NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)]];
        [balls addObject:ball];
        [self addChild:ball];
        
        value = arc4random()%2;
        ball = [CCSprite spriteWithFile:[fileNames objectAtIndex:value]];
        [fileNames removeObjectAtIndex:value];
        ball.tag = 2;
        ball.position = ccp([ball contentSize].width, [ball contentSize].height);
        xMovement = [self getXMovement];//arc4random()%100;
        yMovement = [self getYMovement:xMovement];//sqrtf(20000 - (xMovement*xMovement));  
        NSLog(@"x: %f & y: %f",xMovement,yMovement);
      //  move = [NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)];
        [ballsMotion addObject:[NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)]];
        [balls addObject:ball];
        [self addChild:ball];
        
        ball = [CCSprite spriteWithFile:[fileNames objectAtIndex:0]];
        ball.tag = 3;
        [fileNames removeObjectAtIndex:0];
        ball.position = ccp(320-[ball contentSize].width, [ball contentSize].height);
        xMovement = [self getXMovement];//arc4random()%100;
        yMovement = [self getYMovement:xMovement];//sqrtf(20000 - (xMovement*xMovement));
        NSLog(@"x: %f & y: %f",xMovement,yMovement);
       // move = [NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)];
        [ballsMotion addObject:[NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)]];
        [balls addObject:ball];
        [self addChild:ball];
        NSLog(@"bgColor schedule --- Start");
        [self schedule:@selector(controlBackgroundColor) interval:.2];
        NSLog(@"bgColor schedule --- End");
        scoreLabel = [CCLabelBMFont labelWithString:@"SCORE:   0" fntFile:@"newscore36.fnt"];
        daScore = 0;
        
        [scoreLabel setContentSize:CGSizeMake(320, 50)];
        scoreLabel.position = CGPointMake(160+[scoreLabel contentSize].height/4, 480-[scoreLabel contentSize].height/2);
        // scoreLabel.color = ccWHITE;
        // scoreLabel.anchorPoint = ccp(-1,0);
        [self addChild:scoreLabel];
        isGamePaused = NO;
        started = NO;
        fingerDown = NO;
        
        
        /*NSLog(@"First x Movement: %f",[self getXMovement]);
         NSLog(@"Second x Movement: %f",[self getXMovement]);
         NSLog(@"Third x Movement: %f",[self getXMovement]);*/
        /*pauseBtn = [CCSprite spriteWithFile:@"Button Pause.png"];
         pauseBtn.position = ccp(320-[pauseBtn contentSize].width/2,480-[pauseBtn contentSize].height/2);
         [self addChild:pauseBtn z:0];*/
        
        dxColor = pow(320, -1);
        dyColor = pow(480, -1);
        bgRed = bgGreen = bgBlue = 5;
        bgRedFull = bgGreenFull = bgBlueFull = NO;
        
        
        /*float a = 75.0f;
         float b = 230.5f;
         float c = 330;
         float d = 400;
         
         
         NSLog(@"a: %i", (int) a/80);
         NSLog(@"b: %i", (int) b/80);
         NSLog(@"c: %i", (int) c/80);
         NSLog(@"d: %i", (int) d/80);*/
        //  self.isTouchEnabled = YES;
        NSLog(@"changeColor schedule --- Start");
        [self schedule:@selector(changeColor)];
        NSLog(@"changeColor schedule --- End");
        //powerup = [CCSprite spriteWithFile:@"player_small_test.png"];
        isPowerUpOnScreen = NO;
        isPowerupLayerOnScreen = NO;
        randomPWR=100;
        countdown = 5.0f;
        usage = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseGame) name:@"Interruption" object:nil];
        
    }
	return self;
}

-(void)activatePowerup
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"powerup.caf"];
    NSLog(@"starting");
    NSMutableString *name = [[NSMutableString alloc] init];; //= [[NSString alloc] initWithString:[UIAppDelegate.powerups objectAtIndex:randomPWR]];
    NSLog(@"checking");
    NSString*check = [[NSString alloc] initWithString:[UIAppDelegate.powerups objectAtIndex:randomPWR]];
    NSLog(@"%@",check);
    if([check isEqualToString:POWER_DE_BALL])
    {
        // NSLog(@"%@",name);
        whichPowerUp = 100;
        [name setString:@"Small Balls"];
        for(int i = 0;i<balls.count;i++){
            [[balls objectAtIndex:i] setDisplayFrame:[CCSpriteFrame frameWithTexture:[[CCSprite spriteWithFile:@"ball-small.png"] texture] rect:CGRectMake(0,0, 53, 53)]];
        }
        
    }
    if([check isEqualToString:POWER_DE_PLAYER]){
        // NSLog(@"%@",name);
        whichPowerUp = 300;
        [name setString:@"Small Player"];
        [name setString:@"Small Player"]; 
        [player setDisplayFrame:[CCSpriteFrame frameWithTexture:[[CCSprite spriteWithFile:@"player-small.png"] texture] rect:CGRectMake(0,0, 49, 49)]];
    }
    if([check isEqualToString:POWER_SLOW_BALL]){
        //NSLog(@"%@",name);
        whichPowerUp = 200;
        [name setString:@"Slow Balls"];
    }
    if([check isEqualToString:POWER_INVINCIBILITY]){
        //NSLog(@"%@",name);
        whichPowerUp = 500;
        [name setString:@"Invincibility"];
        
    }
    if([check isEqualToString:POWER_REVERSE_GUN]){
        //NSLog(@"%@",name);
        whichPowerUp = 700;
        usage = 4;
        [name setString:@"Reverse Gun"];
    }
    if([check isEqualToString:POWER_SHIELD]){
        //NSLog(@"%@",name);
        whichPowerUp = 400;
        usage = 1;
        [name setString:@"Shield"];
        shield = [CCSprite spriteWithFile:@"shieldgraphic.png"];
        shield.position=player.position;
        [self addChild:shield];
        NSLog(@"shield activated: %i",whichPowerUp);
        
    }
    if([check isEqualToString:POWER_SHIELD_MULTI]){
        //NSLog(@"%@",name);
        whichPowerUp = 800;
        [name setString:@"Multiplier Shield"];
        usage = 1;
        shieldmult = [CCSprite spriteWithFile:@"shieldmultipliergraphic.png"];
        shieldmult.position = player.position;
        [self addChild:shieldmult];
        NSLog(@"shieldmult activated: %i",whichPowerUp);
    }
    if([check isEqualToString:POWER_STUN_GUN]){
        // NSLog(@"%@",name);
        whichPowerUp = 600;
        usage = 4;
        [name setString:@"Stun Gun"];
    }
   // NSLog(@"checked: %@ -- %@",name,check);
    [self removePWR];
    
    poweruplayer = [CCLayerColor layerWithColor:ccc4(150, 150, 150, 80) width:320 height:60];
    
    poweruplayer.position = ccp(0, -60);
    [self addChild:poweruplayer];
    [poweruplayer runAction:[CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:.5f position:ccp(0,0)]]];
    NSLog(@"added layer");
    powerupLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"poweruptext.fnt"];
    powerupLabel.position = ccp(160,20);
    [poweruplayer addChild:powerupLabel];
    CCLabelBMFont *powerupTitle = [CCLabelBMFont labelWithString:name fntFile:@"poweruptext.fnt"];
    // powerupTitle.anchorPoint = ccp(-1,1);
    [powerupTitle setContentSize:CGSizeMake(140, 50)];
    powerupTitle.position = ccp(70,55);
    NSLog(@"adding title");
    [poweruplayer addChild:powerupTitle];
    NSLog(@"title added - POWERUP:%i",whichPowerUp);
    [self schedule:@selector(updatePowerupLabel:) interval:0.01f];  /// NOT WORKING
    NSLog(@"shouldve scheduled");
    //[self performSelector:@selector(cleanupPowerupLayer) withObject:nil afterDelay:5.0f];
    [name release];
    [check release];
    isPowerupLayerOnScreen = YES;
}

-(void)updatePowerupLabel:(ccTime)dt
{
    NSMutableString *pup = [[NSMutableString alloc] init];
    
    switch (whichPowerUp) {
        case 100:
            
            
        case 200:
            
            
        case 300:
            
            
        case 500:
          //  NSLog(@"A timer powerup has been called - %i",whichPowerUp);
            countdown = countdown - dt;
            if(countdown <= 0){
                [self performSelector:@selector(cleanupPowerupLayer)];
                return;
            }
           // pup = [[NSString alloc] initWithFormat:@"Time: %.3f",countdown];
            [pup appendFormat:@"Time: %.3f",countdown];
            break;
            
        case 400:
            
            
        case 800:
           // NSLog(@"A shield powerup has been called - %i",whichPowerUp);
            if(usage <= 0)
            {
                [self performSelector:@selector(cleanupPowerupLayer)];
                return;
            }
           // pup = [[NSString alloc] initWithString:@"Shield UP"];
            [pup setString:@"Shield UP"];
            break;
            
            
        case 600:
            
            
        case 700:
           // NSLog(@"A usage powerup has been called - %i",whichPowerUp);
            if(usage <= 0)
            {
                [self performSelector:@selector(cleanupPowerupLayer)];
                return;
            }
           // pup = [[NSString alloc] initWithFormat:@"Shots Left: %i",usage];
            [pup appendFormat:@"Shots Left: %i",usage];
            break;
            
            
        default:
            break;
    }
    
    //[pup appendFormat:@"   Time: %...f",(countdown)];
    
    //NSLog(@"%@ + %i",pup,whichPowerUp);
    [powerupLabel setString:pup];
    [powerupLabel setColor:ccc3(bgGreen,bgRed,bgBlue)];
    [pup release];
    
    
}

-(void)cleanupPowerupLayer
{
    [self unschedule:@selector(updatePowerupLabel:)];
    [poweruplayer runAction:[CCSequence actions:[CCMoveTo actionWithDuration:.5f position:ccp(0,-60)],[CCCallBlock actionWithBlock:(^{
        [self removeChild:poweruplayer cleanup:YES];
    })],nil]];
    isPowerupLayerOnScreen = NO;
    countdown = 5.0f;
    
    switch (whichPowerUp) {
        case 100:
            for(int i = 0;i<balls.count;i++){
                [[balls objectAtIndex:i] setDisplayFrame:[CCSpriteFrame frameWithTexture:[[CCSprite spriteWithFile:@"ball10.png"] texture] rect:CGRectMake(0,0, 70, 70)]];
            }
            break;
        case 200:
            
            break;
        case 300:
            [player setDisplayFrame:[CCSpriteFrame frameWithTexture:[[CCSprite spriteWithFile:@"playerdude3.png"] texture] rect:CGRectMake(0,0, 65, 65)]];
            break;
            
            
        case 500:
            
            break;
            
        case 400:
            [self schedule:@selector(finalizeShield:)];//[self removeChild:shield cleanup:YES];
            break;
            
        case 800:
            [self schedule:@selector(finalizeShield:)];//[self removeChild:shieldmult cleanup:YES];
            break;
            
            
        case 600:
            
            break;
        case 700:
            
            
            break;
            
            
        default:
            break;
    }
    
    if(whichPowerUp == 400 || whichPowerUp == 800){
        
    } else {
        whichPowerUp = 0;
    }
    NSLog(@"which powerup: %i",whichPowerUp);
}

-(void)finalizeShield:(ccTime)dT
{
    GLubyte step = 7;
    switch (whichPowerUp) {
        case 400:
            if(shield.opacity > 30){
                shield.opacity = shield.opacity - step;
                //NSLog(@"current opacity: %@",shield.opacity);
            } else {
                [self unschedule:@selector(finalizeShield:)];
                [self removeChild:shield cleanup:YES];
                whichPowerUp = 0;
                NSLog(@"shield gone");
            }
            break;
        
            
        case 800:
            if(shieldmult.opacity > 30){
                shieldmult.opacity = shieldmult.opacity - step;
               // NSLog(@"current opacity: %@",shield.opacity);
            } else {
                [self unschedule:@selector(finalizeShield:)];
                [self removeChild:shieldmult cleanup:YES];
                whichPowerUp = 0;
                NSLog(@"shield gone");
            }
            break;
            
        default:
            NSLog(@"ERROR");
            break;
    }
}

-(CGPoint)randomPowerupLocation
{
    int padding = 30;
    int x = arc4random()%320;
    int y = arc4random()%480;
    while((sqrtf((x-player.position.x)*(x-player.position.x) + (y-player.position.y)*(y-player.position.y)) < 100) 
          || (x < 0+padding || x > 320-padding) || (y < 0 + padding || y > 480-padding))
    {
        x = arc4random()%320;
        y = arc4random()%480;
    }
    
    return ccp(x,y);
}

-(NSString*)getPowerUpImage:(NSString*)name
{
    if([name isEqualToString:POWER_DE_BALL])
        return @"ball_small.png";
    if([name isEqualToString:POWER_DE_PLAYER])
        return @"player_small.png";
    if([name isEqualToString:POWER_SLOW_BALL])
        return @"ball_speed.png";
    if([name isEqualToString:POWER_INVINCIBILITY])
        return @"invincibility.png";
    if([name isEqualToString:POWER_REVERSE_GUN])
        return @"reverse_gun.png";
    if([name isEqualToString:POWER_SHIELD])
        return @"shield.png";
    if([name isEqualToString:POWER_SHIELD_MULTI])
        return @"shield_multiplier.png";
    if([name isEqualToString:POWER_STUN_GUN])
        return @"stun_gun.png";
    
    return nil;
}
-(void)placePowerUp
{
    /*powerup = [CCSprite spriteWithFile:@"player_small_test.png"];
     powerup.position = [self randomPowerupLocation];
     CCLOG(@"about to add powerup");
     [self addChild:powerup];
     CCLOG(@"powerupadded");
     isPowerUpOnScreen = YES;
     NSLog(@"score: %.f",daScore*1000);*/
    
    if(isPowerupLayerOnScreen)
        return;
    
    NSLog(@"placePowerupCalled");
    if(isPowerUpOnScreen){
        isPowerUpOnScreen = NO;
        [self removeChild:powerup cleanup:YES];
    }
    
    switch (UIAppDelegate.powerups.count) {
        case 0:
            break;
            
            
            /* case 1:
             powerup = [CCSprite spriteWithFile:[self getPowerUpImage:[UIAppDelegate.powerups objectAtIndex:0]]];
             powerup.position = [self randomPowerupLocation];
             [self addChild:powerup];
             isPowerUpOnScreen = YES;
             [self performSelector:@selector(removePWR) withObject:nil afterDelay:5.0f];
             break;*/
            
        default:
            randomPWR = arc4random()%UIAppDelegate.powerups.count;
           // randomPWR = arc4random_uniform(UIAppDelegate.powerups.count);
            // [UIAppDelegate.powerups objectAtIndex:randomPWR];
            powerup = [CCSprite spriteWithFile:[self getPowerUpImage:[UIAppDelegate.powerups objectAtIndex:randomPWR]]];
            powerup.position = [self randomPowerupLocation];
            isPowerUpOnScreen = YES;
            
            [self addChild:powerup];
            [self performSelector:@selector(removePWR) withObject:nil afterDelay:5.0f];
            break;
            
    }
    NSLog(@"placed");
    return;
    
}

-(void)removePWR
{
    if(isPowerUpOnScreen){
        isPowerUpOnScreen = NO;
        [self removeChild:powerup cleanup:YES];
        
    }
}

-(void)updateScore:(ccTime)dt
{
    if(whichPowerUp == 800)
    {
        daScore = daScore +2*dt;
    } else {
        daScore = daScore + dt;
    }
   // NSString *score = ;
    [scoreLabel setString:[[NSString alloc] initWithFormat:@"SCORE: %.f",(daScore*1000)]];
    /* if(scoreLabel.scale < 1.06){
     scoreLabel.scale = log10f((daScore+10))/1.5;
     }*/
    // NSLog(@"scale: %f",scoreLabel.scale);
    //scoreLabel.scale = 1.5;
    [scoreLabel setContentSize:CGSizeMake(320, 50)];
   //[score release];
    
}

-(float) getXMovement
{
    int pORn = arc4random()%2 + 1;
    // NSLog(@"pORn:%i",pORn);
    float random1 = arc4random()%(int)(dotProduct-(dotProduct/5.2)) + (dotProduct/2); //arc4random()%80 + 20;
    float random2 = arc4random()%(int)(dotProduct-(dotProduct/5.2)) + (dotProduct/2); //arc4random()%80 + 20;
    float movement = sqrtf(random1*random2);
    if(pORn == 1){
        //   NSLog(@"movement: %f",movement);
        return movement;
    } else if (pORn == 2){
        //  NSLog(@"movement: %f",(-1)*movement);
        return (-1)*movement;
    } else {
        //NSLog(@"failure...");
        return 50;
    }
    
}

-(float)getYMovement:(float)dx
{
    int pORn = arc4random()%2 + 1;
    float movement = //arc4random()%
    (int)sqrtf((2*dotProduct*dotProduct)-(dx*dx));//sqrtf(20000 - (dx*dx));
    if(pORn == 1){
        //   NSLog(@"movement: %f",movement);
        return movement;
    } else if (pORn == 2){
        //  NSLog(@"movement: %f",(-1)*movement);
        return (-1)*movement;
    } else {
        //NSLog(@"failure...");
        return 50;
    }
}

-(void)changeColor
{
    //  int randRed = arc4random()%205 + 50;
    //int randGreen = arc4random()%205 + 50;
    //int randBlue = arc4random()%205 + 50;*/
    
    double redComp, greenComp, blueComp;
    int category = (int)player.position.y / 53.33333;
    
    switch (category) {
        case 0:
            redComp = 255;
            greenComp = blueComp = 0;
            break;
            
        case 1:
            redComp = 255;
            greenComp = 190;
            blueComp = 0;
            break;
            
        case 2:
            redComp = 255;
            greenComp = 255;
            blueComp = 0;
            break;
        case 3:
            redComp = 190;
            greenComp = 255;
            blueComp = 0;
            break;
            
        case 4:
            redComp = 0;
            greenComp = 255;
            blueComp = 0;
            break;
            
        case 5:
            redComp = 0;
            greenComp = 255;
            blueComp = 190;
            break;
            
        case 6:
            redComp = 0;
            greenComp = 255;
            blueComp = 255;
            break;
            
        case 7:
            redComp = 0;
            greenComp = 190;
            blueComp = 255;
            break;
            
        case 8:
            redComp = greenComp = 0;
            blueComp = 255;
            break;
            
            
            
            
            
        default:
            break;
    }
    
    double multiplier = (player.position.x/320*175 + 80)/255;
    //NSLog(@"multiplier:%f",multiplier);
    // NSLog(@"current category %i",category);
    player.color = ccc3(redComp*multiplier, greenComp*multiplier, blueComp*multiplier);
    
    // float Ratio = (((arc4random()%5) + 5)/10)*;
    //  float randomRatio = 1-pow((arc4random()%6+4),-1);
    // NSLog(@"%f",randomRatio);
    // double redComp = ((player.position.x*155*dxColor)+100)*randomRatio;
    //double greenComp = ((((player.position.x*dxColor/2) + (player.position.y*dyColor/2))*155)+100)*randomRatio;
    //double blueComp = ((player.position.y*155*dyColor)+100)*randomRatio;
    // NSLog(@"red: %i | green: %i | blue:%i ### red: %f | green: %f | blue:%f",(int)redComp,(int)greenComp,(int)blueComp,redComp,greenComp,blueComp);
    // NSLog(@"position-x: %f | position-y:%f | dx: %f | dy:%f",player.position.x,player.position.y,dxColor,dyColor);
    // player.color = ccc3(redComp, greenComp, blueComp);
    // scoreLabel.color = player.color;
    redPlayer = redComp*multiplier;
    greenPlayer = greenComp*multiplier;
    bluePlayer = blueComp*multiplier;
    for(int i = 0;i< balls.count ;i++){
        CCSprite *ballB = [balls objectAtIndex:i];
        
        ballB.color = ccc3(255-redPlayer, 255-greenPlayer, 255-bluePlayer);
        if(i == 0)
            scoreLabel.color=ballB.color;
        // ball.color = ccc3(abs(155-redPlayer)+100, abs(155-greenPlayer)+100, abs(155-bluePlayer)+100);
        ballB = nil;
    }
    
    /*  randRed = arc4random()%205 + 50;
     randGreen = arc4random()%205 + 50;
     randBlue = arc4random()%205 + 50;
     background.color = ccc3(randRed, randGreen, randBlue);*/
    [self controlBackgroundColor];
    //  NSLog(@"about to change powerupcolor");
    if(isPowerUpOnScreen)
        powerup.color = ccc3(bgBlue, bgRed, bgGreen);
    //NSLog(@"change powerupcolor");
    
}

-(void)controlBackgroundColor
{
    //NSLog(@"BC: %u",arc4random()%3+1);
    //NSLog(@"Current Colors: (%f,%f,%f)",bgRed,bgGreen,bgBlue);
    // The current background.color = {0,0,0}
    if(bgRed == 5 && bgGreen == 5 && bgBlue == 5){
        bgRedFull = bgGreenFull = bgBlueFull = NO;
        int whichToStart = arc4random()%3 + 1;
        switch (whichToStart) {
            case 1:
                bgRed = bgRed + colorInc;
                break;
                
            case 2:
                bgGreen = bgGreen + colorInc;
                break;
                
            case 3:
                bgBlue = bgBlue + colorInc;
                break;
                
        }
        
        background.color = ccc3(bgRed, bgGreen, bgBlue); 
        return;
    }
    // If x, y or z in {x,y,z} isn't = 0 or = 255, then that is the current color in progress and increment that
    if(bgRed > 5 && bgRed < 255 && !bgRedFull)
    {bgRed = bgRed +colorInc; background.color = ccc3(bgRed, bgGreen, bgBlue);  return;}
    if(bgGreen > 5 && bgGreen < 255 && !bgGreenFull)
    {bgGreen = bgGreen +colorInc; background.color = ccc3(bgRed, bgGreen, bgBlue);  return;}
    if(bgBlue > 5 && bgBlue < 255 && !bgBlueFull)
    {bgBlue = bgBlue +colorInc; background.color = ccc3(bgRed, bgGreen, bgBlue);  return;}
    
    // if it has been incremented to 255, then set its "Full" bool value to YES, so that we can move onto NEXT color
    if(bgRed == 255)
        bgRedFull = YES;
    if(bgGreen == 255)
        bgGreenFull = YES;
    if(bgBlue == 255)
        bgBlueFull = YES;
    
    if(bgRed == 135)
        bgRedFull = NO;
    if(bgGreen == 135)
        bgGreenFull = NO;
    if(bgBlue == 135)
        bgBlueFull = NO;
    
    /*if(bgRedFull){
     if(bgGreenFull && bgBlueFull)
     {
     int whichToStart = arc4random()%3 + 1;
     switch (whichToStart) {
     case 1:
     bgRed = bgRed - 5;
     break;
     
     case 2:
     bgGreen = bgGreen - 5;
     break;
     
     case 3:
     bgBlue = bgBlue - 5;
     break;
     
     }
     }
     if(bgGreenFull && !bgBlueFull)
     {
     
     }
     }*/
    if(bgRedFull || bgGreenFull || bgBlueFull) 
    {
        if(!bgRedFull){
            bgRed = bgRed+colorInc;
            background.color = ccc3(bgRed, bgGreen, bgBlue); 
            return;
        }
        if(!bgGreenFull){
            bgGreen = bgGreen + colorInc;
            background.color = ccc3(bgRed, bgGreen, bgBlue); 
            return;
        }
        if(!bgBlueFull){
            bgBlue = bgBlue + colorInc;
            background.color = ccc3(bgRed, bgGreen, bgBlue); 
            return;
        }
        if(bgRedFull & bgGreenFull & bgBlueFull)
        {
            int whichToStart = arc4random()%3 + 1;
            switch (whichToStart) {
                case 1:
                    bgRed = bgRed - colorInc;
                    background.color = ccc3(bgRed, bgGreen, bgBlue); 
                    return;
                    break;
                    
                case 2:
                    bgGreen = bgGreen - colorInc;
                    background.color = ccc3(bgRed, bgGreen, bgBlue); 
                    return;
                    break;
                    
                case 3:
                    bgBlue = bgBlue - colorInc;
                    background.color = ccc3(bgRed, bgGreen, bgBlue); 
                    return;
                    break;
                    
            }
            
        }
    }
    
    
    background.color = ccc3(bgRed, bgGreen, bgBlue); 
    NSLog(@"%@",background.color);
}

-(void)nextFrame:(ccTime)dT{
    if(backgroundPaused){
        [self pauseGame];
        return;
    }
    for(int i = 0;i< balls.count ;i++){
        // NSLog(@"Start next frame object: %i",i);
        // NSLog(@"creatingball");
        CCSprite *ballA= [balls objectAtIndex:i];
        // NSLog(@"ball created -- creating movement");
        NSValue *move1 = (NSValue*)[ballsMotion objectAtIndex:i];
        //NSLog(@"movement value created --- converting tocgpoint");
        CGPoint move = [move1 CGPointValue];
        //NSLog(@"cgpoint converted");
        if(whichPowerUp == 200){
            ballA.position = ccp((ballA.position.x + (dT*move.x/2)), (ballA.position.y + (dT*move.y/2)));
        } else {
            ballA.position = ccp((ballA.position.x + dT*move.x), (ballA.position.y + dT*move.y));
        }
        
        if(whichPowerUp == 400){
            shield.position = player.position;
            shield.rotation = player.rotation;
        }
        if(whichPowerUp == 800){
            shieldmult.position = player.position;
            shieldmult.rotation = player.rotation;
        }
        /* bool changeX = ball.position.x < 0 +[ball contentSize].width/6 || ball.position.x > 320-[ball contentSize].width/6;
         bool changeY = ball.position.y < 0 +[ball contentSize].height/6 || ball.position.y > 480 -[ball contentSize].height/6;
         if (changeX)
         move.x = -move.x;
         if(changeY)
         move.y = -move.y;*/
        bool _lessX = ballA.position.x < 0 +[ballA contentSize].width/3;
        bool _greaterX = ballA.position.x > 320-[ballA contentSize].width/3;
        bool _lessY = ballA.position.y < 0 +[ballA contentSize].height/3;
        bool _greaterY = ballA.position.y > 480 -[ballA contentSize].height/3;
        if(_lessX)
            move.x = fabsf(move.x);
        if(_greaterX)
            move.x = -1*fabsf(move.x);
        if(_lessY)
            move.y = fabsf(move.y);
        if(_greaterY)
            move.y = -1*fabsf(move.y);
        
        if(_lessX || _greaterX || _lessY || _greaterY)
            [[SimpleAudioEngine sharedEngine] playEffect:@"balloffwall.wav"];
        
        
        if(move.x > 0){
            ballA.rotation = ballA.rotation + 270*dT;
            //NSLog(@"width: %f",ball.contentSize.width/2);
        } else {
            ballA.rotation = ballA.rotation - 270*dT;
        }
        /* CGRect ballBox = CGRectMake(ball.position.x-(ball.contentSize.width/2), ball.position.y-(ball.contentSize.height/2), ball.contentSize.width,ball.contentSize.height);
         CGRect playerBox = CGRectMake(player.position.x-(player.contentSize.width/2), player.position.y-(player.contentSize.height/2), player.contentSize.width, player.contentSize.height);
         if(CGRectIntersectsRect(ballBox,playerBox))*/
        float playerball = ((player.contentSize.width/2)+(ballA.contentSize.width/2))*((player.contentSize.width/2)+(ballA.contentSize.width/2));
        
        //COLLISION
        if((float)[self asbs:player.position ballPos:ballA.position]<=(playerball+(1230187.5/playerball)))
        {
            NSLog(@"which power up: %i",whichPowerUp);
            switch (whichPowerUp) {
                case 400:
                case 800:
                    move.x = -1*move.x;
                    move.y = -1*move.y;
                    //[self performSelector:@selector(cleanupPowerupLayer)];
                    usage = 0;
                    break;
                    
                case 500:
                    break;
                    
                default:
                    NSLog(@"size %.f",player.contentSize.width);
                    NSLog(@"Colision detected  @ player location:(%.f,%.f) and ball location(%.f,%.f)", player.position.x,player.position.y,ballA.position.x,ballA.position.y);
                    [self unscheduleAllSelectors];
                    //[self unscheduleUpdate];
                    self.isTouchEnabled = NO;
                    started = NO;
                    [self reset];
                    NSLog(@"about to call callme");
                    [self performSelector:@selector(callme) withObject:nil afterDelay:.7f];
                    NSLog(@"call callme");
                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                    [[SimpleAudioEngine sharedEngine] playEffect:@"death.caf"];
                    return;
                    break;
            }
            
            
        }
        
        float playerpowerup = ((player.contentSize.width/2)+(ballA.contentSize.width/2))*((player.contentSize.width/2)+(ballA.contentSize.width/2));
        //Does this touch the power-up?
        if(isPowerUpOnScreen){
            if((float)[self asbs:player.position ballPos:powerup.position]<=(playerpowerup+(1230187.5/playerpowerup)))
            {
                [self activatePowerup];
                
            }
        }
        /*if(daScore*1000 > 5000){
         ball.scale = .75;
         }*/
        [ballsMotion replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:move]];
        ballA = nil;
        move1 = nil;
        //[whichBall release];
        //   NSLog(@"Start next frame object: %i",i);
        
    }
    player.rotation = player.rotation + 180*dT;
    [self updateScore:dT];
    /*if(daScore*1000 > 5000){
     [player setDisplayFrame:[CCSpriteFrame frameWithTexture:[[CCSprite spriteWithFile:@"player-small.png"] texture] rect:CGRectMake(0,0, 49, 49)]];
     
     }*/
    // [self changeColor];
}


-(void)callme
{
    NSLog(@"CALLEDME");
    if(isGamePaused){
        [self resumeGame:0];
    }
    [self checkAchievementsAndUploadScore];
    NSLog(@"past checking acievements");
    [self diedAlert];
    NSLog(@"past died alert");
}

-(void)presentNewPowerup:(NSString*)powerupN
{
   CCLayer *congratsLayer = [CCLayer node];
    congratsLayer.tag = 1994;
    congratsLayer.position=ccp(0,10);
    CCSprite *bck = [CCSprite spriteWithFile:@"deathscreen.png"];
        CCSprite *bck1 = [CCSprite spriteWithFile:@"deathscreen.png"];
    congratsLayer.scale = .1;
    bck.position = ccp(160, 10);
    bck1.position = ccp(160, 10);
    [congratsLayer addChild:bck];
    [congratsLayer addChild:bck1 ];
    NSString *msg = @"You have unlocked: ";
    NSString *unlock;
    
    float updown;
    
    if([powerupN isEqualToString:POWER_DE_BALL]){
        unlock = @"Decrease Ball Size";
        updown = 38;
    }
    if([powerupN isEqualToString:POWER_DE_PLAYER]){
        unlock = @"Decrease Player Size";
        updown = 38;
    }
    if([powerupN isEqualToString:POWER_INVINCIBILITY]){
        unlock = @"Invincibility";
        updown = 55;
    }
    if([powerupN isEqualToString:POWER_REVERSE_GUN]){
        unlock = @"Reverse Gun";
        updown = 55;
    }
    if([powerupN isEqualToString:POWER_SHIELD]){
        unlock = @"Shield";
        updown = 55;
    }
    if([powerupN isEqualToString:POWER_SHIELD_MULTI]){
        unlock = @"Multiplier Shield";
        updown = 38;
    }
    if([powerupN isEqualToString:POWER_SLOW_BALL]){
        unlock = @"Decrease Ball Speed";
        updown = 38;
    }
    if([powerupN isEqualToString:POWER_STUN_GUN]){
        unlock = @"Stun Gun";
        updown = 55;
    }
    
    CCLabelTTF *Label = [CCLabelTTF labelWithString:msg  dimensions:CGSizeMake(220, 142) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Marker Felt" fontSize:26];
    CCLabelTTF *unlockLabel = [CCLabelTTF labelWithString:unlock dimensions:CGSizeMake(220, 142) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Marker Felt" fontSize:40];
    Label.position = ccp(160,10);
    Label.color = ccc3(0, 255, 0);
    unlockLabel.position = ccp(160, -1*(updown-10));
    unlockLabel.color = ccc3(60, 255, 60);
    unlockLabel.anchorPoint = ccp(.5f,.5f);
    [congratsLayer addChild:Label];
    [congratsLayer addChild:unlockLabel];
    [self addChild:congratsLayer];
    
    [congratsLayer runAction:[CCScaleTo actionWithDuration:.4 scale:.7]];
    congrats = YES;
}



-(void)checkAchievementsAndUploadScore
{
    
    switch (UIAppDelegate.mode) {
        case 1:
            //fast
            board = [OFLeaderboard leaderboard:LEADER_FAST];
            if(daScore*1000 >= 30000){
                [[OFAchievement achievement:FAST_30K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 60000){
                [[OFAchievement achievement:FAST_60K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 120000){
                [[OFAchievement achievement:FAST_120K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 500000){
                [[OFAchievement achievement:FAST_500K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            /*if([save secureFloatForKey:@"FastHighScore" valid:&valid] < daScore*1000)
            {
                [save setFloat:(daScore*1000) forKey:@"FastHighScore"];
                score = [[OFHighScore alloc] initForSubmissionWithScore:(daScore*1000)];
                [score submitTo:board];
                //[OFHighScoreService setHighScore:(daScore*1000) forLeaderboard:LEADER_FAST onSuccessInvocation:OFDele onFailureInvocation:OFDelegate()];
            }*/
            validno;
            BOOL beatFScore = [save secureFloatForKey:@"FastHighScore" valid:&valid] < daScore*1000;
            if(!valid){
                NSLog(@"Score Modified");
                [save setSecureFloat:0 forKey:@"FastHighScore"];
            } else {
                if(beatFScore){
                    [save setSecureFloat:(daScore*1000) forKey:@"FastHighScore"];
                    score = [[OFHighScore alloc] initForSubmissionWithScore:(daScore*1000)];
                    [score submitTo:board];
                    //[OFHighScoreService setHighScore:(daScore*1000) forLeaderboard:LEADER_FAST onSuccessInvocation:OFDele onFailureInvocation:OFDelegate()];
                }
            }
            break;
        case 2:
            //medium
            board = [OFLeaderboard leaderboard:LEADER_MED];
            if(daScore*1000 >= 30000){
                [[OFAchievement achievement:MED_30K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 60000){
                [[OFAchievement achievement:MED_60K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 120000){
                [[OFAchievement achievement:MED_120K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 500000){
                [[OFAchievement achievement:MED_500K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            /*if([save floatForKey:@"MediumHighScore"] < daScore*1000)
            {
                [save setFloat:(daScore*1000) forKey:@"MediumHighScore"];
                score = [[OFHighScore alloc] initForSubmissionWithScore:(daScore*1000)];
                [score submitTo:board];
            }*/
            validno;
            BOOL beatMScore = [save secureFloatForKey:@"MediumHighScore" valid:&valid] < daScore*1000;
            if(!valid){
                NSLog(@"Score Modified");
                [save setSecureFloat:0 forKey:@"MediumHighScore"];
            } else {
                if(beatMScore){
                    [save setSecureFloat:(daScore*1000) forKey:@"MediumHighScore"];
                    score = [[OFHighScore alloc] initForSubmissionWithScore:(daScore*1000)];
                    [score submitTo:board];
                    //[OFHighScoreService setHighScore:(daScore*1000) forLeaderboard:LEADER_FAST onSuccessInvocation:OFDele onFailureInvocation:OFDelegate()];
                }
            }
            
            break;
        case 3:
            //slow
            board = [OFLeaderboard leaderboard:LEADER_SLOW];
            if(daScore*1000 >= 30000){
                [[OFAchievement achievement:SLOW_30K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 60000){
                [[OFAchievement achievement:SLOW_60K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 120000){
                [[OFAchievement achievement:SLOW_120K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            if(daScore*1000 >= 500000){
                [[OFAchievement achievement:SLOW_500K] updateProgressionComplete:100.0f andShowNotification:YES];
            }
            /*if([save floatForKey:@"SlowHighScore"] < daScore*1000)
            {
                [save setFloat:(daScore*1000) forKey:@"SlowHighScore"];
                score = [[OFHighScore alloc] initForSubmissionWithScore:(daScore*1000)];
                [score submitTo:board];
            }*/
            validno;
            BOOL beatSScore = [save secureFloatForKey:@"SlowHighScore" valid:&valid] < daScore*1000;
            if(!valid){
                NSLog(@"Score Modified");
                [save setSecureFloat:0 forKey:@"SlowHighScore"];
            } else {
                if(beatSScore){
                    [save setSecureFloat:(daScore*1000) forKey:@"SlowHighScore"];
                    score = [[OFHighScore alloc] initForSubmissionWithScore:(daScore*1000)];
                    [score submitTo:board];
                    //[OFHighScoreService setHighScore:(daScore*1000) forLeaderboard:LEADER_FAST onSuccessInvocation:OFDele onFailureInvocation:OFDelegate()];
                }
            }
            break;
    }
    
    if(daScore*1000 < 30000){
         NSLog(@"<30k");
    } else if (daScore*1000 <60000){
        [self checkALL_30K];   
        NSLog(@"30k-60k");
    } else if (daScore*1000 < 120000){
        [self checkALL_30K];
        [self checkALL_60K];
         NSLog(@"60k-120k");
    } else if (daScore* 1000 < 500000){
        [self checkALL_30K];
        [self checkALL_60K];
        [self checkALL_120K];
         NSLog(@"120k-500k");
    } else if (daScore*1000 >= 500000){
        [self checkALL_30K];
        [self checkALL_60K];
        [self checkALL_120K];
        [self checkALL_500K];
         NSLog(@">500k");
    }
    validno;
    float oldCum = [save secureFloatForKey:@"CumulativeScore" valid:&valid];
    if(!valid){
        oldCum = 0;
    } else {
        
    }
    float newCum = oldCum + daScore*1000;
    [save setSecureFloat:newCum forKey:@"CumulativeScore"];
    
    [self performSelector:@selector(updateCumPercentagesAndSendCum)];
    
    
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateCumPercentagesAndSendCum
{
    
    OFLeaderboard*CumBoard = [OFLeaderboard leaderboard:LEADER_CUM];
    validno;
    float Cum = [save secureFloatForKey:@"CumulativeScore" valid:&valid];
    if(!valid){
        Cum = 0;
        NSLog(@"Cum Cheating");
    } else {
        
    }
    OFHighScore *CumScore = [[OFHighScore alloc] initForSubmissionWithScore:Cum];
    
    [CumScore submitTo:CumBoard];
    float outOf250 = 250000 > Cum ? Cum / 250000 *100 : 100;
    outOf250 < 100 ? [[OFAchievement achievement:CUM_250K] updateProgressionComplete:outOf250 andShowNotification:NO] : [[OFAchievement achievement:CUM_250K] updateProgressionComplete:outOf250 andShowNotification:YES];
    
    float outOf750 = 750000 > Cum ? Cum / 750000 * 100 : 100;
    outOf750 < 100 ? [[OFAchievement achievement:CUM_750K] updateProgressionComplete:outOf750 andShowNotification:NO] : [[OFAchievement achievement:CUM_750K] updateProgressionComplete:outOf250 andShowNotification:YES];
    
    float outOf1500 = 1500000 > Cum ? Cum / 1500000 * 100 : 100;
    outOf1500 < 100 ? [[OFAchievement achievement:CUM_1500K] updateProgressionComplete:outOf1500 andShowNotification:NO] : [[OFAchievement achievement:CUM_1500K] updateProgressionComplete:outOf1500 andShowNotification:YES];
    
    float outOf3000 = 3000000 > Cum ? Cum / 3000000 * 100 : 100;
    outOf3000 < 100 ? [[OFAchievement achievement:CUM_3000K] updateProgressionComplete:outOf3000 andShowNotification:NO] : [[OFAchievement achievement:CUM_3000K] updateProgressionComplete:outOf3000 andShowNotification:YES];
    
    float outOf5000 = 5000000 > Cum ? Cum / 5000000 * 100: 100;
    outOf5000 < 100 ? [[OFAchievement achievement:CUM_5000K] updateProgressionComplete:outOf5000 andShowNotification:NO] : [[OFAchievement achievement:CUM_5000K] updateProgressionComplete:outOf5000 andShowNotification:YES];
    
    float outOf10000 = 10000000 > Cum ? Cum / 10000000 * 100 : 100;
    outOf10000 < 100 ? [[OFAchievement achievement:CUM_10000K] updateProgressionComplete:outOf10000 andShowNotification:NO] : [[OFAchievement achievement:CUM_10000K] updateProgressionComplete:outOf10000 andShowNotification:YES];
    
    validno;
    if(outOf750 == 100){
        BOOL POWER_SHIELD_Activated = [save secureBoolForKey:POWER_SHIELD valid:&valid];
        if(!valid){
            [save setSecureBool:NO forKey:POWER_SHIELD];
        } else {
            if(!POWER_SHIELD_Activated){
                [save setSecureBool:YES forKey:POWER_SHIELD];
                [UIAppDelegate.powerups addObject:POWER_SHIELD];
                [self performSelector:@selector(presentNewPowerup:) withObject:POWER_SHIELD];
            }
        }
    }
    validno;
    if(outOf1500 == 100){
        BOOL POWER_INVINCIBILITY_Activated = [save secureBoolForKey:POWER_INVINCIBILITY valid:&valid];
        if(!valid){
            [save setSecureBool:NO forKey:POWER_INVINCIBILITY];
        } else {
            if(!POWER_INVINCIBILITY_Activated){
                [save setSecureBool:YES forKey:POWER_INVINCIBILITY];
                [UIAppDelegate.powerups addObject:POWER_INVINCIBILITY];
                [self performSelector:@selector(presentNewPowerup:) withObject:POWER_INVINCIBILITY];
            }
        }
    }
    
    validno;
    if(outOf3000 == 100){
        BOOL POWER_REVERSE_GUN_Activated = [save secureBoolForKey:POWER_REVERSE_GUN valid:&valid];
        if(!valid){
            [save setSecureBool:NO forKey:POWER_REVERSE_GUN];
        } else {
            if(!POWER_REVERSE_GUN_Activated){
                [save setSecureBool:YES forKey:POWER_REVERSE_GUN];
                [UIAppDelegate.powerups addObject:POWER_REVERSE_GUN];
                [self performSelector:@selector(presentNewPowerup:) withObject:POWER_REVERSE_GUN];
            }
        }
    }
    
    validno;
    /*if(outOf5000 == 100){
        BOOL POWER_STUN_GUN_Activated = [save secureBoolForKey:POWER_STUN_GUN valid:&valid];
        if(!valid){
            [save setSecureBool:NO forKey:POWER_STUN_GUN];
        } else {
            if(!POWER_STUN_GUN_Activated){
                [save setSecureBool:YES forKey:POWER_STUN_GUN];
                [UIAppDelegate.powerups addObject:POWER_STUN_GUN];
            }
        }
    }*/
    
    validno;
    if(outOf10000 == 100){
        BOOL POWER_SHIELD_MULTI_Activated = [save secureBoolForKey:POWER_SHIELD_MULTI valid:&valid];
        if(!valid){
            [save setSecureBool:NO forKey:POWER_SHIELD_MULTI];
        } else {
            if(!POWER_SHIELD_MULTI_Activated){
                [save setSecureBool:YES forKey:POWER_SHIELD_MULTI];
                [UIAppDelegate.powerups addObject:POWER_SHIELD_MULTI];
                [self performSelector:@selector(presentNewPowerup:) withObject:POWER_SHIELD_MULTI];
            }
        }
    }
    
}

-(void)checkALL_30K
{
    int complete30 = 0;
    /*complete30 = [[OFAchievement achievement:SLOW_30K] isUnlocked] ? complete30 + 1 : complete30;
    complete30 = [[OFAchievement achievement:MED_30K] isUnlocked] ? complete30 + 1 : complete30;
    complete30 = [[OFAchievement achievement:FAST_30K] isUnlocked] ? complete30 + 1 : complete30;*/
    validno;
    float num = [save secureFloatForKey:@"SlowHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 29999){
            complete30 = complete30+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"MediumHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 29999){
            complete30 = complete30+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"FastHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 29999){
            complete30 = complete30+1;
        }
    }
    
    NSLog(@"complete30: %i",complete30);
    switch (complete30) {
        case 0:
            break;
            
        case 1:
            [[OFAchievement achievement:ALL_30K] updateProgressionComplete:33.3f andShowNotification:NO];
            NSLog(@"complete30 : 1");
            break;
            
        case 2:
            [[OFAchievement achievement:ALL_30K] updateProgressionComplete:66.6f andShowNotification:NO];
            NSLog(@"complete30 : 2");
            break;
            
        case 3:
            [[OFAchievement achievement:ALL_30K] updateProgressionComplete:100.0f andShowNotification:YES];
            NSLog(@"complete30 : 3");
            /*if(![save boolForKey:POWER_DE_PLAYER]){
                [save setBool:YES forKey:POWER_DE_PLAYER];
                [UIAppDelegate.powerups addObject:POWER_DE_PLAYER];
            }*/
            validno;
            BOOL POWER_DE_PLAYER_Activated = [save secureBoolForKey:POWER_DE_PLAYER valid:&valid];
            if(!valid){
                [save setSecureBool:NO forKey:POWER_DE_PLAYER];
                NSLog(@"Cheater on powerup");
            } else {
                if(!POWER_DE_PLAYER_Activated){
                    [save setSecureBool:YES forKey:POWER_DE_PLAYER];
                    [UIAppDelegate.powerups addObject:POWER_DE_PLAYER];
                    [self performSelector:@selector(presentNewPowerup:) withObject:POWER_DE_PLAYER];
                }
            }
            break;
        default:
            break;
    }
    
}

-(void)checkALL_60K
{
    int complete60 = 0;
   /* complete60 = [[OFAchievement achievement:SLOW_60K] isUnlocked] ? complete60 + 1 : complete60;
    complete60 = [[OFAchievement achievement:MED_60K] isUnlocked] ? complete60 + 1 : complete60;
    complete60 = [[OFAchievement achievement:FAST_60K] isUnlocked] ? complete60 + 1 : complete60;*/
    validno;
    float num = [save secureFloatForKey:@"SlowHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 59999){
            complete60 = complete60+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"MediumHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 59999){
            complete60 = complete60+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"FastHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 59999){
            complete60 = complete60+1;
        }
    }

    
    switch (complete60) {
        case 0:
            break;
            
        case 1:
            [[OFAchievement achievement:ALL_60K] updateProgressionComplete:33.3f andShowNotification:NO];
            break;
            
        case 2:
            [[OFAchievement achievement:ALL_60K] updateProgressionComplete:66.6f andShowNotification:NO];
            break;
            
        case 3:
            [[OFAchievement achievement:ALL_60K] updateProgressionComplete:100.0f andShowNotification:YES];
           /* if(![save boolForKey:POWER_SLOW_BALL]){
                [save setBool:YES forKey:POWER_SLOW_BALL];
                [UIAppDelegate.powerups addObject:POWER_SLOW_BALL];
            }*/
            validno;
            BOOL POWER_SLOW_BALL_Activated = [save secureBoolForKey:POWER_SLOW_BALL valid:&valid];
            if(!valid){
                [save setSecureBool:NO forKey:POWER_SLOW_BALL];
                NSLog(@"Cheater on powerup");
            } else {
                if(!POWER_SLOW_BALL_Activated){
                    [save setSecureBool:YES forKey:POWER_SLOW_BALL];
                    [UIAppDelegate.powerups addObject:POWER_SLOW_BALL];
                    [self performSelector:@selector(presentNewPowerup:) withObject:POWER_SLOW_BALL];
                }
            }
            break;
        default:
            break;
    }
    
}

-(void)checkALL_120K
{
    int complete120 = 0;
   /* complete120 = [[OFAchievement achievement:SLOW_120K] isUnlocked] ? complete120 + 1 : complete120;
    complete120 = [[OFAchievement achievement:MED_120K] isUnlocked] ? complete120 + 1 : complete120;
    complete120 = [[OFAchievement achievement:FAST_120K] isUnlocked] ? complete120 + 1 : complete120;*/
    validno;
    float num = [save secureFloatForKey:@"SlowHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 119999){
            complete120 = complete120+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"MediumHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 119999){
            complete120 = complete120+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"FastHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 119999){
            complete120 = complete120+1;
        }
    }

    
    switch (complete120) {
        case 0:
            break;
            
        case 1:
            [[OFAchievement achievement:ALL_120K] updateProgressionComplete:33.3f andShowNotification:NO];
            break;
            
        case 2:
            [[OFAchievement achievement:ALL_120K] updateProgressionComplete:66.6f andShowNotification:NO];
            break;
            
        case 3:
            [[OFAchievement achievement:ALL_120K] updateProgressionComplete:100.0f andShowNotification:YES];
            /*if(![save boolForKey:POWER_STUN_GUN]){
                [save setBool:YES forKey:POWER_STUN_GUN];
                [UIAppDelegate.powerups addObject:POWER_STUN_GUN];
            }*/
            validno;
            BOOL POWER_DE_BALL_Activated = [save secureBoolForKey:POWER_DE_BALL valid:&valid];
            if(!valid){
                [save setSecureBool:NO forKey:POWER_DE_BALL];
                NSLog(@"Cheater on powerup");
            } else {
                if(!POWER_DE_BALL_Activated){
                    [save setSecureBool:YES forKey:POWER_DE_BALL];
                    [UIAppDelegate.powerups addObject:POWER_DE_BALL];
                    [self performSelector:@selector(presentNewPowerup:) withObject:POWER_DE_BALL];
                }
            }
            break;
        default:
            break;
    }
    
}

-(void)checkALL_500K
{
    int complete500 = 0;
    /*complete500 = [[OFAchievement achievement:SLOW_500K] isUnlocked] ? complete500 + 1 : complete500;
    complete500 = [[OFAchievement achievement:MED_500K] isUnlocked] ? complete500 + 1 : complete500;
    complete500 = [[OFAchievement achievement:FAST_500K] isUnlocked] ? complete500 + 1 : complete500;*/
    validno;
    float num = [save secureFloatForKey:@"SlowHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 499999){
            complete500 = complete500+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"MediumHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 499999){
            complete500 = complete500+1;
        }
    }
    validno;
    num = [save secureFloatForKey:@"FastHighScore" valid:&valid];
    if(!valid){
        
    } else {
        if (num > 499999){
            complete500 = complete500+1;
        }
    }

    
    switch (complete500) {
        case 0:
            break;
            
        case 1:
            [[OFAchievement achievement:ALL_500K] updateProgressionComplete:33.3f andShowNotification:NO];
            break;
            
        case 2:
            [[OFAchievement achievement:ALL_500K] updateProgressionComplete:66.6f andShowNotification:NO];
            break;
            
        case 3:
            [[OFAchievement achievement:ALL_500K] updateProgressionComplete:100.0f andShowNotification:YES];
            /*if(![save boolForKey:POWER_SHIELD_MULTI]){
                [save setBool:YES forKey:POWER_SHIELD_MULTI];
                [UIAppDelegate.powerups addObject:POWER_SHIELD_MULTI];
            }*/
            validno;
            BOOL POWER_STUN_GUN_Activated = [save secureBoolForKey:POWER_STUN_GUN valid:&valid];
            if(!valid){
                [save setSecureBool:NO forKey:POWER_STUN_GUN];
                NSLog(@"Cheater on powerup");
            } else {
                if(!POWER_STUN_GUN_Activated){
                    [save setSecureBool:YES forKey:POWER_STUN_GUN];
                    [UIAppDelegate.powerups addObject:POWER_STUN_GUN];
                    [self performSelector:@selector(presentNewPowerup:) withObject:POWER_STUN_GUN];
                }
            }

            break;
        default:
            break;
    }
    
}

-(void)reset
{
    int whichBall = arc4random()%4;
    NSMutableArray *numbers = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:whichBall%4],[NSNumber numberWithInt:(whichBall+1)%4],[NSNumber numberWithInt:(whichBall+2)%4],[NSNumber numberWithInt:(whichBall+3)%4],nil];
    id moveSpace1 = [CCMoveTo actionWithDuration:3 position:ccp([[balls objectAtIndex:whichBall] contentSize].width, 480-[[balls objectAtIndex:whichBall] contentSize].height)];
    id moveSpace2 = [CCMoveTo actionWithDuration:3 position:ccp(320-[[balls objectAtIndex:whichBall] contentSize].width, 480-[[balls objectAtIndex:whichBall] contentSize].height)];
    id moveSpace3 = [CCMoveTo actionWithDuration:3 position:ccp([[balls objectAtIndex:whichBall] contentSize].width, [[balls objectAtIndex:whichBall] contentSize].height)];
    id moveSpace4 = [CCMoveTo actionWithDuration:3 position:ccp(320-[[balls objectAtIndex:whichBall] contentSize].width, [[balls objectAtIndex:whichBall] contentSize].height)];
    id a1 = [CCEaseElasticOut actionWithAction:moveSpace1 period:0.3f];
    id a2 = [CCEaseElasticOut actionWithAction:moveSpace2 period:0.3f];
    id a3 = [CCEaseElasticOut actionWithAction:moveSpace3 period:0.3f];
    id a4 = [CCEaseElasticOut actionWithAction:moveSpace4 period:0.3f];
    
    [[balls objectAtIndex:[[numbers objectAtIndex:0] intValue]] runAction:a1];
    [[balls objectAtIndex:[[numbers objectAtIndex:1] intValue]] runAction:a2];
    [[balls objectAtIndex:[[numbers objectAtIndex:2] intValue]] runAction:a3];
    [[balls objectAtIndex:[[numbers objectAtIndex:3] intValue]] runAction:a4];
    
    id move = [CCMoveTo actionWithDuration:2 position:ccp(160,240)];
    id action = [CCEaseBounceOut actionWithAction:move];
    [player runAction: action];
    [player runAction:[CCRotateTo actionWithDuration:1 angle:0]];
    //[player setTexture:[[CCTextureCache sharedTextureCache] addImage:@"playerdude3.png"]];
    
    NSLog(@"about to remove powerup");
    if(isPowerUpOnScreen){
        [self removeChild:powerup cleanup:YES];
        isPowerUpOnScreen = NO;
    }
    NSLog(@"remove powerup");
    /*//int whichBall = arc4random()%(4-i);
     //NSLog(@"i: %i and whichBall:%i",i,whichBall);
     
     //      NSLog(@"%i called",i);
     [[balls objectAtIndex:whichBall] runAction:[CCMoveTo actionWithDuration:1 position:ccp([[balls objectAtIndex:whichBall] contentSize].width, 480-[[balls objectAtIndex:whichBall] contentSize].height)]];
     //    NSLog(@"after called");
     //  [numbers removeObjectAtIndex:whichBall];
     
     
     //  NSLog(@"%i called",i);
     [[balls objectAtIndex:whichBall] runAction:[CCMoveTo actionWithDuration:1 position:ccp(320-[[balls objectAtIndex:whichBall] contentSize].width, 480-[[balls objectAtIndex:whichBall] boundingBox].size.height)]];
     //NSLog(@"after called");
     //[numbers removeObjectAtIndex:whichBall];
     
     //NSLog(@"%i called",i);
     [[balls objectAtIndex:whichBall] runAction:[CCMoveTo actionWithDuration:1 position:ccp([[balls objectAtIndex:whichBall] boundingBox].size.width, [[balls objectAtIndex:whichBall] boundingBox].size.height)]];
     //NSLog(@"after called");
     //[numbers removeObjectAtIndex:whichBall];
     
     
     //NSLog(@"%i called",i);
     [[balls objectAtIndex:whichBall] runAction:[CCMoveTo actionWithDuration:1 position:ccp(320-[[balls objectAtIndex:whichBall] boundingBox].size.width, [[balls objectAtIndex:whichBall] boundingBox].size.height)]];
     //NSLog(@"after called");
     //[numbers removeObjectAtIndex:whichBall];
     */
    
    
    
    NSLog(@"its over");
    [numbers release];
    [self schedule:@selector(controlBackgroundColor) interval:.2];
    [self schedule:@selector(changeColor)];
    if(isPowerupLayerOnScreen){
        [self performSelector:@selector(cleanupPowerupLayer)];
    }
    
    //  [self schedule:@selector(placePowerUp) ];
}

-(void)diedAlert
{
    self.isTouchEnabled = NO;
    /*UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Game Over"];
    	[dialog setMessage:msg];
	[dialog addButtonWithTitle:@"Yes"];
	[dialog addButtonWithTitle:@"No"];
	[dialog show];
	[dialog release];
    [msg release];*/
    NSString *msg = [[NSString alloc] initWithFormat:@"Score: %.f",daScore*1000];
    CCLayer *diedlayer = [[CCLayer alloc] init];
    diedlayer.tag = 666;
    CCSprite *bckDied = [[CCSprite alloc] initWithFile:@"deathscreen.png"];
    bckDied.tag = 1212;
    bckDied.position = ccp(160,240);
    bckDied.scale = .1;
    
    CCMenuItemLabel *score1 = [[CCMenuItemLabel alloc] initWithLabel:[CCLabelTTF labelWithString:msg fontName:@"Arial" fontSize:20] target:nil selector:nil];
    CCMenuItemLabel *gohome = [[CCMenuItemLabel alloc] initWithLabel:[CCLabelTTF labelWithString:@"RETURN TO MENU" fontName:@"Arial" fontSize:20] target:self selector:@selector(goHome:)];
    CCMenuItemLabel *playagain = [[CCMenuItemLabel alloc] initWithLabel:[CCLabelTTF labelWithString:@"PLAY AGAIN" fontName:@"Arial" fontSize:20] target:self selector:@selector(playAgain)];
    /*CCMenuItemLabel *call = [[CCMenuItemLabel alloc] initWithLabel:[CCLabelTTF labelWithString:@"TESTICLES" fontName:@"Arial" fontSize:20] target:self selector:@selector(haveFun)];*/
    CCMenu *menu4 = [CCMenu menuWithItems:score1, gohome,playagain,nil];
    [menu4 alignItemsVerticallyWithPadding:10];
    menu4.tag = 4444;
    
    [diedlayer addChild:bckDied];
    [diedlayer addChild:menu4];
    [menu4 setOpacity:0];
    [bckDied setOpacity:0];
    [self addChild:diedlayer];
    [msg release];
    [bckDied runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:.4 scale:1],[CCFadeIn actionWithDuration:.4],nil]];
    [menu4 runAction:[CCFadeIn actionWithDuration:.4]];
}


-(void)playAgain
{
    if(congrats){
        [self removeChildByTag:1994 cleanup:YES];
    }
    NSLog(@"width: %f height: %f",[self getChildByTag:666].contentSize.width,[self getChildByTag:666].contentSize.height);
    self.isTouchEnabled = YES;
    NSLog(@"called");
    [[[self getChildByTag:666] getChildByTag:4444] runAction:[CCFadeOut actionWithDuration:.3]];
    [[[self getChildByTag:666] getChildByTag:1212] runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:.4 scaleX:(.1) scaleY:(.1)],[CCSequence actions:[CCFadeOut actionWithDuration:.5],[CCCallBlock actionWithBlock:(^{
        
         [self removeChildByTag:666 cleanup:YES];
        
    })],nil],nil]];

   
}

/*- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isTouchEnabled = YES;
	if(buttonIndex==0) {
        NSLog(@"yes");
        
        return;
    } else if (buttonIndex == 1){
        NSLog(@"no");
        [self goHome:nil];
        return;
    }
}*/

-(float)asbs:(CGPoint)_arrowPos ballPos:(CGPoint)_ballPos
{
    float x = _arrowPos.x-_ballPos.x;
    float y = _arrowPos.y-_ballPos.y;
    float xy = x*x+y*y;
    
    return xy;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	//[balls removeAllObjects];
    [self removeAllChildrenWithCleanup:YES];
	self.balls = nil;
	self.ballsMotion = nil;
	self.fileNames = nil;
	
	//self.player = nil;
	//self.pauseBtn = nil;
	//self.background = nil;
	//self.scoreLabel = nil;
	//self.powerupLabel = nil;
	//self.pauseLayer = nil;
	//self.pauseMenu = nil;
	//if(self.poweruplayer != nil)
      //  self.poweruplayer = nil;
	//self.shield = nil;
	//self.shieldmult = nil;
    [balls release];
    [ballsMotion release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@synthesize powerup;
@end
