//
//  InvitationAccounts.m
//  Roomies
//
//  Created by Anna Zakharova on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InvitationAccounts.h"
#import "AccountInfoViewController.h"
#import "User.h"


@implementation InvitationAccounts

@synthesize tableView;
@synthesize accountInfoViewController;
@synthesize currentSelection;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
    [super viewDidLoad];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	currentSelection = -1;
	NSLog(@" ACCOUNTS viewDidLoad");
	tableView.backgroundColor = [UIColor clearColor];
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	NSLog(@"numberOfSectionsInTableView is called");
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[User instance].accountInvitations count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.opaque = NO;

		//cell.font=[UIFont fontWithName:@"Georgia" size:20.0];
		[cell.textLabel setFont:[UIFont fontWithName:@"Georgia" size:20]];

		//cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]]autorelease];
		//cell.selectedBackgroundView = [UIColor whiteColor];

		cell.imageView.image = [UIImage imageNamed:@"profile4.png"];
		
		// Making it transparent:
		//CGImageRef myMaskedImage = [cell.imageView.image CGImage];
		//const float whiteMask[6] = { 254,254,254, 254,254,254 }; // the more white it is - the more transparent
		//cell.imageView.image = [UIImage imageWithCGImage:CGImageCreateWithMaskingColors(myMaskedImage, whiteMask)];
		//cell.imageView.image setTransp
	}
	
	// colors
	[cell.textLabel setBackgroundColor:[UIColor clearColor]];	
	    
    // setup cell
	NSUInteger row = [indexPath row];	
	AccountData *data = [[User instance].accountInvitations objectAtIndex:row];
	
	[cell.textLabel setText:data.account_name];
    
	//cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table.png"]]autorelease];
	//cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	currentSelection = [indexPath row];
	NSLog(@"didSelectRowAtIndexPath %d DISPLAY ACCOUNT ", currentSelection);
	
	if(self.accountInfoViewController == nil)
	{		
		AccountInfoViewController *tmp = [[AccountInfoViewController alloc] initWithNibName:@"Account" bundle:nil];
		self.accountInfoViewController = tmp;
		[tmp release];
	}
	AccountData *account = [[User instance].accountInvitations objectAtIndex:currentSelection];
	accountInfoViewController.title = [NSString stringWithFormat:@"%@", account.account_name];
	accountInfoViewController.mode = 3;
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	accountInfoViewController.invitationAccountsController = self;
	[del.invitationNavController pushViewController:accountInfoViewController animated:YES];
    
	[accountInfoViewController viewAccount:account];
	
	NSLog(@"didSelectRowAtIndexPath DONE");
}

- (void) deleteItem
{
	User *user = [User instance];
	NSLog(@"deleteItem called, index %d count %d", currentSelection, [user.accountInvitations count]);
	
	[user.accountInvitations removeObjectAtIndex:currentSelection];
	
	NSLog(@"deleteItem after count %d after ", [[User instance].accountInvitations count]);
	[self.tableView reloadData];
}

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
	
	[tableView release];
	[accountInfoViewController release];
    [super dealloc];
}


@end
