    //
//  InvitationsViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InvitationsViewController.h"
#import "RoomiesAppDelegate.h"
#import "ApplicationInfoViewController.h"
#import "AccountInfoViewController.h"
#import "User.h"
#import "Parser.h"
#import "InvitationAccounts.h"

@implementation InvitationsViewController

@synthesize invitBtn;
@synthesize accountBtn;
@synthesize infoBtn;

@synthesize applInfoController;
@synthesize accountInfoViewController;
@synthesize invitationAccounts;

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
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"burgund3.png"]];
	
    [super viewDidLoad];
	
}

- (IBAction)buttonClicked:(id)sender
{
	if(sender == invitBtn)
	{
		NSLog(@"view invitations");
		[self createInvitationsView];
	}
	if(sender == accountBtn)
	{
		NSLog(@"view accountBtn");
		[self displayAccountPage];
	}
	if(sender == infoBtn)
	{
		NSLog(@"view info");
		[self displayApplInfo];
	}
}

- (void) createInvitationsView
{
	NSLog(@"im in create createInvitationsView");
	/*if([User instance].connect_status == FAILED)
	{
		return;
	}
	else {*/
	
	if(invitationAccounts == nil)
	{
		InvitationAccounts *details = [[InvitationAccounts alloc] initWithNibName:@"InvitationAccounts" bundle:nil];
		self.invitationAccounts = details;
		[details release];
		
	}
	NSLog(@" createInvitationsView applInfoController %p ", invitationAccounts);
	
	/*UILabel *titleLabel = [[UILabel alloc] init];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel sizeToFit];
	[titleLabel setText:@"Pending Invitations"];
	[titleLabel setFont:[UIFont fontWithName:@"Georgia" size:20.0]];	
	[self.navigationItem setTitleView:titleLabel];
	[titleLabel release];*/
	
	invitationAccounts.title = [NSString stringWithFormat:@"Pending Invitations"];
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[UIView  beginAnimations:nil context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:del.window cache:NO];
	[del loadInvitation];
	//[del.invitationNavController reload];
    
	[del.invitationNavController pushViewController:invitationAccounts animated:YES];
	[invitationAccounts.tableView reloadData];
	[UIView commitAnimations];
	
	//[del.invitationNavController pushViewController:invitationAccounts animated:YES];
	
	/* getting the phone number
	NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
	NSLog(@"Phone Number: %@", num);
	NSMutableString * query = nil;
	Parser *parser = [Parser alloc];
	RoomiesAppDelegate *del = [[UIApplication sharedApplication] delegate];
	
	if(num != NULL)
	{
		query = [[NSMutableString alloc ]initWithFormat:@"user_phone_num="] ;
		[query appendString:(@"%@", num)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=request_invitations"];
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"response from request_invitations :  %@", response) ; 
	}
	
	else {
		query = [[NSMutableString alloc ]initWithFormat:@"user_phone_num="] ;
		[query appendString:(@"3472773248")];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=request_invitations"];
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"response from request_invitations :  %@", response);
	}
	[parser initWithNSData:[del setUpConnection:query]];
	[User instance].invitationsList = [parser parseObjectList:Accounts];
	NSLog(@"DATA");
	NSLog(@"%d", [[User instance].invitationsList count]); */
	
}

- (void) displayApplInfo
{
	NSLog(@" info,,,,,,,");
	
	if(self.applInfoController == nil)
	{
		NSLog(@" info 2");
		ApplicationInfoViewController *details = [[ApplicationInfoViewController alloc] initWithNibName:@"iRoomiesinfo" bundle:nil];
		self.applInfoController = details;
		[details release];
	}
	
	applInfoController.title = [NSString stringWithFormat:@"iRoomies"];
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[UIView  beginAnimations:nil context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:del.window cache:NO];
	[del.invitationNavController pushViewController:applInfoController animated:YES];
	[UIView commitAnimations];
	
	//[del.invitationNavController pushViewController:applInfoController animated:YES];
}

- (void) displayAccountPage
{
	NSLog(@"displayAccountPage ");
	
	if(self.accountInfoViewController == nil)
	{
		AccountInfoViewController *details = [[AccountInfoViewController alloc] initWithNibName:@"Account" bundle:nil];
		self.accountInfoViewController = details;
		// add mode
		self.accountInfoViewController.mode = 1;
		[details release];
	}
	
	applInfoController.title = [NSString stringWithFormat:@"iRoomies"];
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[UIView  beginAnimations:nil context: nil];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:del.window cache:NO];
	[del.invitationNavController pushViewController:accountInfoViewController animated:YES];
	[UIView commitAnimations];
	
	//[del.invitationNavController pushViewController:accountInfoViewController animated:YES];
	NSLog(@"++++ displayAccountPage : invitationNavController pushViewController:accountInfoViewController");
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[invitBtn release];
	[accountBtn release];
	[infoBtn release];
	[applInfoController release];
	[accountInfoViewController release];
	[invitationAccounts release];
	
    [super dealloc];
}


@end
