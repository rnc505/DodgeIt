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
    IBOutlet UIView *feedbackview;
    IBOutlet UIView *mainview;
    IBOutlet UITextField *name;
    IBOutlet UITextField *subject;
    IBOutlet UITextView *message;
    IBOutlet UIButton *submit;
    NSMutableData *data;
}

-(IBAction)textfieldEnded:(id)sender;
-(IBAction)outClick:(id)sender;
-(IBAction)checkAndSubmit:(id)sender;
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
@property (nonatomic, retain) IBOutlet UIView *feedbackview;
@property (nonatomic, retain) IBOutlet UIView *mainview;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *subject;
@property (nonatomic, retain) IBOutlet UITextView *message;
@property (nonatomic, retain) IBOutlet UIButton *submit;
@property (nonatomic, retain) NSMutableData *data;
@end
