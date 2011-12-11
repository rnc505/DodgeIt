//
//  TitleScreen.m
//  DodgeIt
//
//  Created by Android on 11/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TitleScreen.h"
#import "AppDelegate.h"
#import "HelloWorldLayer.h"
#import "OpenFeint/OpenFeint.h"
#import "AppOFDelegate.h"
#define UIAppDelegate \
((AppDelegate *)[UIApplication sharedApplication].delegate)
#define save [NSUserDefaults standardUserDefaults]
@implementation TitleScreen

CCSprite *background;
CCSprite *DodgeText;
CCSprite *ItText;
CCSprite *FastMode;
CCSprite *SlowMode;
CCSprite *MediumMode;
CCSprite *Settings;
CCSprite *highScores;
CCSprite *player1;
float _bgRed;
float _bgGreen;
float _bgBlue;
bool _bgRedFull;
bool _bgGreenFull;
bool _bgBlueFull;
int colorDt = 10;
int whichBackgroundColor=0;
CCMenu *gameModes;
NSArray *ballsA;
NSMutableArray *ballsMotionA;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScreen *layer = [TitleScreen node];
	//CCMe
	// add layer as a child to scene
	[scene addChild: layer];
	//srand(time(NULL));
	// return the scene
	return scene;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint location = [self convertTouchToNodeSpace:[touches anyObject]];
    CCLOG(@"Location: (%.f,%.f)",location.x,location.y);
    
    bool touchingFast = CGRectContainsPoint(CGRectMake(FastMode.position.x-FastMode.contentSize.width/2, FastMode.position.y-FastMode.contentSize.height/2, FastMode.contentSize.width, FastMode.contentSize.height), location);
    bool touchingMedium = CGRectContainsPoint(CGRectMake(MediumMode.position.x-MediumMode.contentSize.width/2, MediumMode.position.y-MediumMode.contentSize.height/2, MediumMode.contentSize.width, MediumMode.contentSize.height), location);
    bool touchingSlow = CGRectContainsPoint(CGRectMake(SlowMode.position.x-SlowMode.contentSize.width/2, SlowMode.position.y-SlowMode.contentSize.height/2, SlowMode.contentSize.width, SlowMode.contentSize.height), location);
    
    bool touchingHI = CGRectContainsPoint(CGRectMake(highScores.position.x-highScores.contentSize.width/2, highScores.position.y-highScores.contentSize.height/2, highScores.contentSize.width, highScores.contentSize.height), location);
    
    if(touchingFast){
        UIAppDelegate.mode = 1;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionPageTurn transitionWithDuration:.8  scene:[HelloWorldLayer scene:(NSInteger*)1] backwards:NO]];         
    }
    if(touchingMedium){
        UIAppDelegate.mode = 2;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionRotoZoom transitionWithDuration:.8  scene:[HelloWorldLayer scene:(NSInteger*)2] ]];         
    }
    
    if(touchingSlow){
        UIAppDelegate.mode = 3;
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionShrinkGrow transitionWithDuration:.8  scene:[HelloWorldLayer scene:(NSInteger*)3] ]];         
    }
    if(touchingHI){
                NSLog(@"touch hi");
        [OpenFeint launchDashboard];
    }
}



-(id) init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super init])) {
       
        ballsMotionA = [[NSMutableArray alloc] init];
        background = [CCSprite spriteWithFile:@"backgroundtitle.png"];
        background.position = ccp(160, 240);
        [self addChild:background];
        
        ballsA = [[NSArray alloc] initWithObjects:[CCSprite spriteWithFile:@"ball10.png"],[CCSprite spriteWithFile:@"ball10.png"],[CCSprite spriteWithFile:@"ball10.png"],[CCSprite spriteWithFile:@"ball10.png"], nil];
        
        for(int i = 0;i<ballsA.count;i++){
            CCSprite *ball = [ballsA objectAtIndex:i];
            switch (i) {
                case 0:
                    ball.position = ccp([ball contentSize].width, 480-[ball contentSize].height);
                    break;
                    
                case 1:
                    ball.position = ccp(320-[ball contentSize].width, 480-[ball contentSize].height);
                    break;
                    
                case 2:
                    ball.position = ccp([ball contentSize].width, [ball contentSize].height);
                    break;
                    
                case 3:
                    ball.position = ccp(320-[ball contentSize].width, [ball contentSize].height);
                    break;
                    
                    
                default:
                    break;
            }
            
            float xMovement = [self getXMovement];//arc4random()%100;
            float yMovement = [self getYMovement:xMovement];//sqrtf(20000 - (xMovement*xMovement));
           // NSLog(@"movement:(%f,%f)",xMovement,yMovement);
            NSValue *move = [NSValue valueWithCGPoint:CGPointMake(xMovement, yMovement)];
            [ballsMotionA addObject:move];
            [self addChild:ball];
           // ball = nil;
            move = nil;
        }
        
        player1 = [CCSprite spriteWithFile:@"playerdude3.png"];
        player1.position = ccp(221.25, 342.75);
        //player1.scale = 2;
        [self addChild:player1];
        
        DodgeText = [CCSprite spriteWithFile:@"Dodge.png"];
        DodgeText.position = ccp(158,434.75);
        [self addChild:DodgeText];
        
        ItText = [CCSprite spriteWithFile:@"It.png"];
        ItText.position = ccp(91.75,351.25);
        [self addChild:ItText];
        
        
        
        
        FastMode = [CCSprite spriteWithFile:@"FASTMODE.png"];
        FastMode.position = ccp(158.75-25, 133.25);
        
        [self addChild:FastMode];
        
        MediumMode = [CCSprite spriteWithFile:@"MEDIUMMODE.png"];
        MediumMode.position = ccp(158.75,194.5+1);
        [self addChild:MediumMode];
        
        SlowMode = [CCSprite spriteWithFile:@"SLOWMODE.png"];
        SlowMode.position = ccp(130.25,259);
        [self addChild:SlowMode];
        
        
        
        
        highScores = [CCSprite spriteWithFile:@"highscores.png"];
        highScores.position = ccp(193.75,74.5);
       [self addChild:highScores];
        
        /*Settings = [CCSprite spriteWithFile:@"SETTINGS.png"];
        Settings.position = ccp(191.75,31.5);
        [self addChild:Settings];*/
        
        _bgBlue =   _bgRed =   _bgGreen =  95;
        
        _bgRedFull = _bgGreenFull = _bgBlueFull = NO;
        [self commenceColor];
        NSLog(@"runTB schedule --- Start");
        [self schedule:@selector(runTitleAndBalls:)];
        NSLog(@"runTB schedule --- End");
        NSLog(@"color schedule --- Start");
        [self schedule:@selector(commenceColor) interval:.2];
        NSLog(@"color schedule --- Start");
        // NSLog(@"init complete");
        self.isTouchEnabled = YES;
      // [self runTests];
       
                
        NSLog(@"save information:");
        NSLog(@"current slow high score: %i",[save integerForKey:@"SlowHighScore"]);
         NSLog(@"current med high score: %i",[save integerForKey:@"MediumHighScore"]);   
         NSLog(@"current fast high score: %i",[save integerForKey:@"FastHighScore"]);
         NSLog(@"current cum score: %i",[save integerForKey:@"CumulativeScore"]);
        
        for(int i = 0; i< UIAppDelegate.powerups.count;i++){
            NSLog(@"POWER: %@",(NSString*)[UIAppDelegate.powerups objectAtIndex:i]);
        }
        UIAppDelegate.running = 1;
        
        [(AppDelegate*)[[UIApplication sharedApplication] delegate] displayGoogleAd:CGSizeMake(320, 50)];
        //UIAppDelegate.
    }
    
    return self;
}

-(void)runTests
{
    CCSprite *ballTest = [CCSprite spriteWithFile:@"ball10.png"];
    CCSprite *ballTest1 = [CCSprite spriteWithFile:@"ball10.png"];
    CCSprite *ballTest2 = [CCSprite spriteWithFile:@"ball10.png"];
    
    ballTest.scale = .5;
    ballTest.position = ccp(ballTest.contentSize.width,ballTest.contentSize.height);
    [self addChild:ballTest];
    
    ballTest1.scale = .75;
    ballTest1.position = ccp(ballTest1.contentSize.width+50,ballTest1.contentSize.height);
    [self addChild:ballTest1];
    
    ballTest2.scale = .85;
    ballTest2.position = ccp(ballTest2.contentSize.width+100,ballTest2.contentSize.height);
    [self addChild:ballTest2];
    
    
}

-(void)runTitleAndBalls:(ccTime)dt
{
    player1.rotation = player1.rotation + 180*dt;
   // NSLog(@"ballsA count: %i",ballsA.count);
    for(int i = 0;i<ballsA.count;i++){
       // NSLog(@"i = %i",i);
        CCSprite *ballA = [ballsA objectAtIndex:i];
        NSValue *move1 = (NSValue*)[ballsMotionA objectAtIndex:i];
        CGPoint move = [move1 CGPointValue];
        ballA.position = ccp((ballA.position.x + dt*move.x),(ballA.position.y+ dt*move.y));
       // NSLog(@"move:(%f,%f)",move.x,move.y);
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
        
        if(move.x > 0){
            ballA.rotation = ballA.rotation + 270*dt;
            //NSLog(@"width: %f",ballA.contentSize.width/2);
        } else {
            ballA.rotation = ballA.rotation - 270*dt;
        }
        
        [ballsMotionA replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:move]];
        ballA = nil;
        move1 = nil;
    }
}

-(float) getXMovement
{
    int pORn = arc4random()%2 + 1;
    // NSLog(@"pORn:%i",pORn);
    float random1 = arc4random()%80 + 20;
    float random2 = arc4random()%80 + 20;
    float movement = sqrtf(random1*random2);
    if(pORn == 1){
     //     NSLog(@"movement: %f",movement);
        return movement;
    } else if (pORn == 2){
       // NSLog(@"movement: %f",(-1)*movement);
        return (-1)*movement;
    } else {
        //NSLog(@"failure...");
        return 50;
    }
    
    
    
}

-(float)getYMovement:(float)dx
{
    int pORn = arc4random()%2 + 1;
    float movement = sqrtf(20000 - (dx*dx));
    if(pORn == 1){
          // NSLog(@"y --- movement: %f",movement);
        return movement;
    } else if (pORn == 2){
          //NSLog(@"y --- movement: %f",(-1)*movement);
        return (-1)*movement;
    } else {
        //NSLog(@"failure...");
        return 50;
    }
}


-(void)commenceColor
{
    [self colorTheBackground2];
    // NSLog(@"red: %f |green: %f |blue: %f",_bgRed,_bgGreen,_bgBlue);
    [self colorTheTitle];
   [self colorTheHISettings];
    [self colorTheModes];
    [self colorTheBalls];
    
    
}

-(void)colorTheBalls
{
    for (int i = 0; i<ballsA.count; i++) {
        CCSprite *ball = [ballsA objectAtIndex:i];
        ball.color = ccc3(255-_bgRed, 255-_bgGreen, 255-_bgBlue);
        ball = nil;
    }
}

-(void)colorTheTitle
{
    DodgeText.color = ccc3(_bgRed,_bgGreen,_bgBlue);
    ItText.color = ccc3(_bgRed,_bgGreen,_bgBlue);
    player1.color = ccc3(_bgRed,_bgGreen,_bgBlue);
    
}

-(void)colorTheHISettings
{
    float red = abs(185-_bgRed)+70;
    float green =abs(185-_bgGreen)+70;
    float blue =abs(185-_bgBlue)+70;
    highScores.color = ccc3(red,green,blue);
    Settings.color = ccc3(red,green,blue);
}

-(void)colorTheModes
{
    float red = _bgRed+20 < 255 ? _bgRed-20 : _bgRed;
    float green =_bgGreen + 20 <255 ? _bgGreen-20:_bgGreen;
    float blue = _bgBlue + 20<255?_bgBlue-20:_bgBlue;
    FastMode.color = ccc3(red,blue,green);
    MediumMode.color = ccc3(blue,green,red);
    SlowMode.color = ccc3(green,red,blue);
}
-(void)colorTheBackground2
{
    if(whichBackgroundColor == 0)
        whichBackgroundColor =  arc4random()%3+1;
    
    switch (whichBackgroundColor) {
        case 1:
            if (_bgRed +colorDt <= 255) {
                _bgRed = _bgRed + colorDt;
                _bgBlue = _bgBlue-colorDt > 50 ? (_bgBlue - colorDt/2):_bgBlue;
                _bgGreen = _bgGreen-colorDt > 50 ?(_bgGreen - colorDt/2):_bgGreen;
            } else {
                whichBackgroundColor = arc4random()%2+2;
            }
            break;
            
        case 2:
            if (_bgGreen +colorDt <= 255) {
                _bgGreen = _bgGreen + colorDt;
                _bgBlue = _bgBlue-colorDt > 50 ? (_bgBlue - colorDt/2):_bgBlue;
                _bgRed = _bgRed-colorDt > 50 ?(_bgRed - colorDt/2):_bgRed;
            } else {
                whichBackgroundColor = arc4random()%2 != 0 ? 3 : 1;
            }
            break;
        case 3:
            if (_bgBlue +colorDt <= 255) {
                _bgBlue = _bgBlue + colorDt;
                _bgGreen = _bgGreen-colorDt > 50 ? (_bgGreen - colorDt/2):_bgGreen;
                _bgRed = _bgRed-colorDt > 50 ?(_bgRed - colorDt/2):_bgRed;
            } else {
                whichBackgroundColor = arc4random()%2 != 0 ? 2 : 1;
            }
            break;
        default:
            break;
    }
    // NSLog(@"red: %f | green: %f | blue: %f ||| whichBackgroundColor: %d",_bgRed,_bgGreen,_bgBlue,whichBackgroundColor);
    background.color = ccc3(_bgRed, _bgGreen, _bgBlue);
}
-(void)colorTheBackground
{
    // NSLog(@"ColorBG started");
    //NSLog(@"BC: %u",arc4random()%3+1);
    //NSLog(@"Current Colors: (%f,%f,%f)",_bgRed,_bgGreen,_bgBlue);
    // The current background.color = {0,0,0}
    if(_bgRed == 105 && _bgGreen == 105 && _bgBlue == 105){
        _bgRedFull = _bgGreenFull = _bgBlueFull = NO;
        int whichToStart = arc4random()%3 + 1;
        switch (whichToStart) {
            case 1:
                _bgRed = _bgRed + colorDt;
                break;
                
            case 2:
                _bgGreen = _bgGreen + colorDt;
                break;
                
            case 3:
                _bgBlue = _bgBlue + colorDt;
                break;
                
        }
        
        background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
        return;
    }
    // If x, y or z in {x,y,z} isn't = 0 or = 255, then that is the current color in progress and increment that
    if(_bgRed > 5 && _bgRed < 255 && !_bgRedFull)
    {_bgRed = _bgRed +colorDt; background.color = ccc3(_bgRed, _bgGreen, _bgBlue);  return;}
    if(_bgGreen > 5 && _bgGreen < 255 && !_bgGreenFull)
    {_bgGreen = _bgGreen +colorDt; background.color = ccc3(_bgRed, _bgGreen, _bgBlue);  return;}
    if(_bgBlue > 5 && _bgBlue < 255 && !_bgBlueFull)
    {_bgBlue = _bgBlue +colorDt; background.color = ccc3(_bgRed, _bgGreen, _bgBlue);  return;}
    
    // if it has been incremented to 255, then set its "Full" bool value to YES, so that we can move onto NEXT color
    if(_bgRed == 255)
        _bgRedFull = YES;
    if(_bgGreen == 255)
        _bgGreenFull = YES;
    if(_bgBlue == 255)
        _bgBlueFull = YES;
    
    if(_bgRed == 135)
        _bgRedFull = NO;
    if(_bgGreen == 135)
        _bgGreenFull = NO;
    if(_bgBlue == 135)
        _bgBlueFull = NO;
    
    /*if(_bgRedFull){
     if(_bgGreenFull && _bgBlueFull)
     {
     int whichToStart = arc4random()%3 + 1;
     switch (whichToStart) {
     case 1:
     _bgRed = _bgRed - 5;
     break;
     
     case 2:
     _bgGreen = _bgGreen - 5;
     break;
     
     case 3:
     _bgBlue = _bgBlue - 5;
     break;
     
     }
     }
     if(_bgGreenFull && !_bgBlueFull)
     {
     
     }
     }*/
    if(_bgRedFull || _bgGreenFull || _bgBlueFull) 
    {
        if(!_bgRedFull){
            _bgRed = _bgRed+colorDt;
            background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
            return;
        }
        if(!_bgGreenFull){
            _bgGreen = _bgGreen + colorDt;
            background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
            return;
        }
        if(!_bgBlueFull){
            _bgBlue = _bgBlue + colorDt;
            background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
            return;
        }
        if(_bgRedFull & _bgGreenFull & _bgBlueFull)
        {
            int whichToStart = arc4random()%3 + 1;
            switch (whichToStart) {
                case 1:
                    _bgRed = _bgRed - colorDt;
                    background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
                    
                    return;
                    break;
                    
                case 2:
                    _bgGreen = _bgGreen - colorDt;
                    background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
                    return;
                    break;
                    
                case 3:
                    _bgBlue = _bgBlue - colorDt;
                    background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
                    return;
                    break;
                    
            }
            
        }
    }
    
    
    background.color = ccc3(_bgRed, _bgGreen, _bgBlue); 
    // NSLog(@"ColorBG ended");
    //NSLog(@"%@",background.color);
}

@end
