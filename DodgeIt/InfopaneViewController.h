//
//  InfopaneViewController.h
//  DodgeIt
//
//  Created by Android on 12/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol ModalViewDelegate;


@interface InfopaneViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  {
    id<ModalViewDelegate> delegate;
    UITextField *slowb;
    UITextField *medb;
    UITextField *fastb;
    UITextField *cumb;
    
}
@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, copy) IBOutlet NSArray *pups;
@property (nonatomic, retain) IBOutlet UITextField *slowb;
@property (nonatomic, retain) IBOutlet UITextField *medb;
@property (nonatomic, retain) IBOutlet UITextField *fastb;
@property (nonatomic, retain) IBOutlet UITextField *cumb;
@property (nonatomic, assign) int slow;
@property (nonatomic, assign)  int med;
@property (nonatomic, assign)  int fast;
@property (nonatomic, assign)  int cum;
@property (nonatomic, assign) IBOutlet BOOL valid;
@end
