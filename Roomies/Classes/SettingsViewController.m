    //
//  SettingsViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApplicationInfoViewController.h"
#import "AccountInfoViewController.h"
#import "RoomiesAppDelegate.h"
#import "RoomiesViewController.h"



@implementation SettingsViewController

@synthesize infoBtn1;
@synthesize infoBtn2;
@synthesize roomies1;
@synthesize roomies2;
@synthesize about1;
@synthesize about2;
@synthesize applInfoController;
@synthesize accountInfoViewController;
@synthesize roomiesViewController;
@synthesize accountView;
@synthesize infoView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Settings", @"Account Settings");
	accountView.hidden = YES;
	infoView.hidden = YES;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"burgund2.png"]];
}

- (IBAction)buttonClicked:(id)sender
{
	NSLog(@"in click ");
	if(sender == about1 || sender == about2)
	{
		NSLog(@" about account");
		[self displayAccountPage];
	}
	if(sender == infoBtn1 || sender == infoBtn2)
	{
		NSLog(@" info");
		
		[self displayApplicationInfo];
		
		
	}
	if(sender == roomies1 || sender == roomies2)
	{
		NSLog(@" roomies");
		[self displayRoomiesPage];
	}
}

- (void) displayRoomiesPage
{
	NSLog(@" infoView");
	
	if(self.roomiesViewController == nil)
	{
		NSLog(@" roomies in if");
		RoomiesViewController *details = [[RoomiesViewController alloc] initWithNibName:@"RoomiesView" bundle:nil];
		self.roomiesViewController = details;
		[details release];
	}
	NSLog(@" roomies out if");
	roomiesViewController.title = [NSString stringWithFormat:@"Roomies"];
	NSLog(@" roomies 2");
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[UIView  beginAnimations:nil context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:del.window cache:NO];
	[del.settingsNavController pushViewController:roomiesViewController animated:YES];
	[UIView commitAnimations];
	NSLog(@"finish of roomoiesViewController");
}

- (void) displayAccountPage
{
	//[self.view addSubview:accountView];
	//accountView.hidden = NO;
	NSLog(@" account,,,,,,,");
	
	// create save button and back button
	/*UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
								   initWithTitle: @"Back"  // Account Settings
								   style:UIBarButtonItemStylePlain 
								   target:self 
								   action:@selector(settingsBack)];
	self.navigationItem.backBarButtonItem = backButton;*/
	
	//self.navigationItem.leftBarButtonItem = self.backButtonItem;
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	if(self.accountInfoViewController == nil)
	{
		NSLog(@" info 2");
		AccountInfoViewController *details = [[AccountInfoViewController alloc] initWithNibName:@"Account" bundle:nil];
		self.accountInfoViewController = details;
		[details release];
	}
	// add mode
	self.accountInfoViewController.mode = 0;
	applInfoController.title = [NSString stringWithFormat:@"iRoomies"];
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[UIView  beginAnimations:nil context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:del.window cache:NO];
	[del.settingsNavController pushViewController:accountInfoViewController animated:YES];
	[UIView commitAnimations];
	NSLog(@"finish of accountInfoViewController");
	
}

- (void) displayApplicationInfo
{

	//[self.view addSubview:infoView];
	
	infoView.hidden = NO;
	
	NSLog(@" infoView");
	
	if(self.applInfoController == nil)
	{
		NSLog(@" info 2");
		ApplicationInfoViewController *details = [[ApplicationInfoViewController alloc] initWithNibName:@"iRoomiesinfo" bundle:nil];
		self.applInfoController = details;
		[details release];
	}
	
	applInfoController.title = [NSString stringWithFormat:@"iRoomies"];
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[UIView  beginAnimations:nil context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:del.window cache:NO];
	[del.settingsNavController pushViewController:applInfoController animated:YES];
	[UIView commitAnimations];

}


 

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[applInfoController release];
	[roomiesViewController release];
	[accountView release];
}


@end
