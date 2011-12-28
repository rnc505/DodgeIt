//
//  InfopaneViewController.m
//  DodgeIt
//
//  Created by Android on 12/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfopaneViewController.h"
#import "RootViewController.h"
#import "TitleScreen.h"
#import "AppDelegate.h"
#import "OFConstants.h"
#define UIAppDelegate \
((AppDelegate *)[UIApplication sharedApplication].delegate)
#define save [NSUserDefaults standardUserDefaults]
#define validno valid = NO;
@implementation InfopaneViewController
@synthesize valid;
@synthesize slow;
@synthesize med;
@synthesize fast;
@synthesize cum;
@synthesize slowb;
@synthesize medb;
@synthesize fastb;
@synthesize cumb;

@synthesize pups;

@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"initWithNibCalled");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"custom init");
        pups = [[NSArray alloc] initWithArray:UIAppDelegate.powerups];
       // NSLog(@"Poewrups: %@", pups);
    }
    NSLog(@"initWithNibEnded.");
    return self;
}

- (void)dealloc
{
	self.pups = nil;
	self.slowb = nil;
	self.medb = nil;
	self.fastb = nil;
	self.cumb = nil;


    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad Starting.");
    UIBarButtonItem *back = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goHome)]autorelease];

   self.title = @"Scores and Power-Ups";
    
    //self.navigationController.navigationBar.backItem.title = @"Custom";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;  
   
    self.navigationItem.leftBarButtonItem = back;
    
    NSLog(@"view did loaded");
    //NSLog(@"Poewrups: %@", pups);
    validno;
    slow = [save secureFloatForKey:@"SlowHighScore" valid:&valid];
    if(!valid){
        [save setSecureFloat:0 forKey:@"SlowHighScore"];
    } else {
       // slowb = [[[UITextField alloc] init] autorelease];
        //slowb.titleLabel.text = [NSString stringWithFormat:@"%i",slow];
         [slowb setText:[NSString stringWithFormat:@"%i",slow]];
    }
    validno;
    med = [save secureFloatForKey:@"MediumHighScore" valid:&valid];
    if(!valid){
        [save setSecureFloat:0 forKey:@"MediumHighScore"];
    } else {
       // medb = [[[UITextField alloc] init] autorelease];
       // medb.titleLabel.text = [NSString stringWithFormat:@"%i",med];
         [medb setText:[NSString stringWithFormat:@"%i",med]];
    }
    validno;
    fast = [save secureFloatForKey:@"FastHighScore" valid:&valid];
    if(!valid){
        [save setSecureFloat:0 forKey:@"FastHighScore"];
    } else {
       // fastb = [[[UITextField alloc] init] autorelease];
       //fastb.titleLabel.text = [NSString stringWithFormat:@"%i",fast];
         [fastb setText:[NSString stringWithFormat:@"%i",fast]];
    }
    validno;
    cum = [save secureFloatForKey:@"CumulativeScore" valid:&valid];
    if(!valid){
        [save setSecureFloat:0 forKey:@"CumulativeScore"];
    } else {
       
       // cumb.titleLabel.text = ;
       // [cumb setText:;
        [cumb setText:[NSString stringWithFormat:@"%i",cum]];
        
        NSLog(@"is this even called");
    }
    NSLog(@"slow: %i, medium: %i, fast: %i, cumulative: %i",slow,med,fast,cum);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)goHome{
    //[delegate didReceiveMessage:@"Hello World"];
    
   // NSNotification *note = [NSNotification notificationWithName:@"goHomeNow"  object:nil userInfo:nil];
    //[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"goHomeNow" object:nil];
    [self dismissModalViewControllerAnimated:YES];
    
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}


- (void)viewDidUnload
{
    self.slowb = nil;
	self.medb = nil;
	self.fastb = nil;
	self.cumb = nil;
    self.pups = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"here: %i",[self.pups count]);
    //return [self.pups count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	//return [[self.pups allKeys] objectAtIndex:section];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSString *continent = [self tableView:tableView titleForHeaderInSection:section];
	//return [[self.pups valueForKey:continent] count];
    if([self.pups count]==0){
        return 1;
    } else {
        return [self.pups count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	/*NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *country = [[self.pups valueForKey:continent] objectAtIndex:indexPath.row];*/
	NSString *current;
	//cell.textLabel.text = [self.pups objectAtIndex:indexPath.row];;
    if([self.pups count] == 0)
    {
    current = @"No Power-Ups Activated";
        cell.textLabel.text = current;
    } else {
	current = [self.pups objectAtIndex:indexPath.row];
    }
    
    if([current isEqualToString:POWER_DE_BALL]){
        cell.textLabel.text = @"Decrease Ball Size Power-Up";
        [cell.imageView setImage:[UIImage imageNamed:@"ball_small.png"]];
    }
    if([current isEqualToString:POWER_DE_PLAYER]){
        cell.textLabel.text = @"Decrease Player Size Power-Up";
        [cell.imageView setImage:[UIImage imageNamed:@"player_small.png"]];
    }
    if([current isEqualToString:POWER_INVINCIBILITY]){
        cell.textLabel.text = @"Invincibility Power-Up";
        [cell.imageView setImage: [UIImage imageNamed:@"invincibility.png"]];
    }
    if([current isEqualToString:POWER_REVERSE_GUN]){
        cell.textLabel.text = @"Reverse Gun Power-Up";
        [cell.imageView setImage: [UIImage imageNamed:@"reverse_gun.png"]];
    }
    if([current isEqualToString:POWER_SHIELD]){
        cell.textLabel.text = @"Shield Power-Up";
        [cell.imageView setImage: [UIImage imageNamed:@"shield.png"]];
    }
    if([current isEqualToString:POWER_SHIELD_MULTI]){
        cell.textLabel.text = @"Multiplier Shield Power-Up";
        [cell.imageView setImage: [UIImage imageNamed:@"shield_multiplier.png"]];
    }
    if([current isEqualToString:POWER_SLOW_BALL]){
        cell.textLabel.text = @"Decrease Ball Speed Power-Up";
        [cell.imageView setImage: [UIImage imageNamed:@"ball_speed.png"]];
    }
    if([current isEqualToString:POWER_STUN_GUN]){
        cell.textLabel.text = @"Stun Gun Power-Up";
        [cell.imageView setImage: [UIImage imageNamed:@"stun_gun.png"]];
    }
        
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   // [cell.textLabel sizeToFit
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
	[current release];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
	NSString *country = [[self.pups valueForKey:continent] objectAtIndex:indexPath.row];
    NSString *powerup = [self.pups objectAtIndex:indexPath.row];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:[NSString stringWithFormat:@"You selected %@!", powerup]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];*/
}


@end
