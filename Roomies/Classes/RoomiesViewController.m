    //
//  RoomiesViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RoomiesViewController.h"
#import "User.h"

@implementation RoomiesViewController

@synthesize tableView;
@synthesize searchBar;

@synthesize filterText;
@synthesize searchList;
@synthesize deletedRoomies;

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
	
	NSLog(@"viewDidLoad for roomies view ");
	
	self.title = NSLocalizedString(@"Rommies", @"Account Roomies");
	self.filterText = [[NSMutableString alloc] init];
	self.searchList = [NSMutableArray array];
	
	// need to create Edit button
	searchBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	tableView.backgroundColor = [UIColor clearColor];
	/* NSMutableArray *temp;
	temp = [[NSMutableArray alloc] initWithObjects: @"Anna", @"Jinru", @"Antoine", nil];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.dataArray = temp;
	[temp release]; */
}

// Receives Edit/Done button clicks:
- (void) setEditing:(BOOL) editing animated:(BOOL) animated 
{
	
	[self.tableView setEditing:editing];
	
    // pass "editing" state to base class so that edit/done button toggles
    [super setEditing:editing animated:animated];
	/* delete all preselected bills */
	if(editing == 0)
	{
		for(RoomieData *data in deletedRoomies)
		{
			NSLog(@" delete user id %d ", [data.user_id intValue]);
			[self deleteUser:data];
		}
	}
	
	NSLog(@"editing is %d", editing);
}

- (void) deleteUser:(RoomieData *) UserData
{
	NSString *idStr = [NSString stringWithFormat:@"%d", [UserData.user_id intValue]];
	
	NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
	[query appendString:(@"%@",[User instance].UDID)];
	[query appendString:@"&user_id="];
	[query appendString:(@"%@",idStr)];
	[query appendString:@"&request_type=roomie_delete"];
	
	@try
	{
		RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@" DELETE RESPONSE FROM SERVER %@  ", response);
	}
	@catch (NSException * e) 
	{
		NSLog(@"delete user exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
	}
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"editingStyle is %d row %d ", editingStyle, indexPath.row);
	if(editingStyle == UITableViewCellEditingStyleDelete) 
	{	
		RoomieData *data = [[User instance].accountData.roomiesData objectAtIndex:indexPath.row];
		NSLog(@"Need to store user_id %d ", [data.user_id intValue]);
		// store in deletedRoomies
		if(deletedRoomies == nil)
		{
			deletedRoomies = [[NSMutableArray alloc] init];
		}
		
		RoomieData *tmp = [[RoomieData alloc] init];
		tmp = data;
		[deletedRoomies addObject:tmp];
		
		[[User instance].accountData.roomiesData removeObjectAtIndex:indexPath.row];
		
		// delete from table view:
		[self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
		[self.tableView endUpdates];
		
		NSLog(@"Need to update database store bill_ids in array and update when user presses Done");
	}
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	// Return the number of rows in the section.
	NSLog(@"ROOMIES numberOfRowsInSection is called");
	[searchList removeAllObjects];
	
	if([filterText length] == 0)
		return [[User instance].accountData.roomiesData count];
		
	for(RoomieData *data in [User instance].accountData.roomiesData)
	{
		NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:filterText 
														options:NSRegularExpressionCaseInsensitive error:nil];
		NSUInteger numberOfMatches = 0;
		NSLog(@" ROOMIES TITLE %@ ", data.user_name);
		numberOfMatches = [reg numberOfMatchesInString:data.user_name									  
												   options:0
													 range:NSMakeRange(0, [data.user_name length])];
			
		if(numberOfMatches > 0)
		{
			NSLog(@"match found!!!!");
			[searchList addObject:data];
		}
	}
	NSLog(@"!!!!!!!!!!!!return searchList count %d", [searchList count]);
	return [searchList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"roomies of cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"RoomieID"; 
	
	UILabel *nameLbl = nil;
    UILabel *statusLbl = nil;
	// Each subview in the cell will be identified by a unique tag.
    static NSUInteger const kNameLabelTag = 2;
    static NSUInteger const kStatusLabelTag = 3;
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
        // No reusable cell was available, so we create a new cell and configure its subviews.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        
        nameLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, 190, 20)] autorelease];
        nameLbl.tag = kNameLabelTag;
        nameLbl.font = [UIFont boldSystemFontOfSize:16];
		nameLbl.opaque = NO;
		[nameLbl  setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:nameLbl];
        
        statusLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 28, 170, 14)] autorelease];
        statusLbl.tag = kStatusLabelTag;
        statusLbl.font = [UIFont systemFontOfSize:13];
		statusLbl.opaque = NO;		
		[statusLbl  setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:statusLbl];
		
		cell.textLabel.opaque = NO;
	}
	else 
	{
		// A reusable cell was available, so we just need to get a reference to the subviews
        // using their tags.
        nameLbl = (UILabel *)[cell.contentView viewWithTag:kNameLabelTag];
        statusLbl = (UILabel *)[cell.contentView viewWithTag:kStatusLabelTag];
	}

    // setup cell
	NSUInteger row = [indexPath row];
	NSLog(@" row %d", row);
	User *user = [User instance];
	AccountData *account = user.accountData;
	RoomieData *data = nil;
	if([filterText length] == 0 || [searchList count] == 0)
		data = [account.roomiesData objectAtIndex:row];
	else 
		data = [searchList objectAtIndex:row];

	nameLbl.text = data.user_name;
	
	NSString *status = nil;
	if([data.user_status intValue] == 1)
		status = [NSString stringWithFormat:@"Accepted"];
	else
		status = [NSString stringWithFormat:@"Pending"];
	
    statusLbl.text = [NSString stringWithFormat:@"Account status : %@", status];
	[cell.textLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (IBAction) didEndEdit:(id) sender
{
	NSLog(@"didEndEdit");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
	NSLog(@"searchBarSearchButtonClicked is called");
	[sBar resignFirstResponder];
	[self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	//NSLog(@"textDidChange is called");
	
	[filterText setString:searchText];
	NSLog(@"textDidChange is called with: %@", filterText);
	[self.tableView reloadData]; // dont repaint when there is no search by location
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sBar
{
	NSLog(@"searchBarCancelButtonClicked is called");
	sBar.text = @"";
	
	[sBar resignFirstResponder];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"inside of didSelectRowAtIndexPath");
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	NSInteger row = [indexPath row];
	RoomieData *roomie = [[User instance].accountData.roomiesData objectAtIndex:row];
	NSLog(@"finish of didSelectRowAtIndexPath %@", roomie.user_name);
}



- (void)dealloc 
{	
	[tableView release];
	[deletedRoomies release];
    [searchBar release];
	[super dealloc];
}


@end
