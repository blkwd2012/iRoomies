    //
//  EventsViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventsViewController.h"
#import "EventViewController.h"
#import "RoomiesAppDelegate.h"


@implementation EventsViewController

@synthesize searchBar;
@synthesize tableView;
@synthesize eventViewController;

@synthesize filterText;
@synthesize searchList;
@synthesize iconsData;
@synthesize deletedBills;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

	[super viewDidLoad];
	
	NSLog(@"events inside of viewDidLoad");

	self.iconsData= [[NSMutableArray alloc] initWithObjects: @"house.png", @"Cake.png", 
					 @"Martini.png", @"PartyHat.png", @"Pineapple.png", @"Umbrella.png",@"BBQ.png", nil];
	
	self.title = NSLocalizedString(@"Events", @"Account Events");
	
	self.filterText = [[NSMutableString alloc] init];
	self.searchList = [NSMutableArray array];
	currentSelection = -1;
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	searchBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];

	// need to create Edit button
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
	[self.tableView reloadData];
	}

- (void) addItem:(EventData *)data
{
	if ([User instance].eventsList == nil) {
		[User instance].eventsList = [[NSMutableArray alloc]init];
	}
	[[User instance].eventsList addObject:data];
	NSLog(@"addItem after count %d", [[User instance].eventsList count]);
	[self.tableView reloadData];
}

- (void) updateItem:(EventData *)data
{
	NSLog(@"updateItem called, index %d count %d", currentSelection, [[User instance].eventsList count]);
	
	int position = [self deleteItem:data];
	if(position != -1)
		[[User instance].eventsList insertObject:data atIndex:position];
	NSLog(@"updateItem after count %d", [[User instance].eventsList count]);
	[self.tableView reloadData];
}

- (int) deleteItem:(EventData *)data;
{
	NSLog(@"deleteItem called, currentSelection %d list size %d", currentSelection, [[User instance].eventsList count]);

	User *user = [User instance];
	int count = -1;
	if(currentSelection == -1)
	{
		for(EventData *tmp in user.eventsList)
		{
			count = count + 1;
			NSLog(@"%d: id from list = %d, delete id = %d", count, [tmp.event_id intValue], [data.event_id intValue]);
			if([tmp.event_id intValue] == [data.event_id intValue])
			{
				NSLog(@"deleteItem called, index %d events count %d before", count, [[User instance].eventsList count]);
				[[User instance].eventsList removeObjectAtIndex:count];
				break;
			}
		}
	}
	else
	{
		count = currentSelection;
		[user.eventsList removeObjectAtIndex:currentSelection];
	}
	
	[self.tableView reloadData];
	NSLog(@"deleteItem after count %d after", [[User instance].eventsList count]);
	[self.tableView reloadData];
	return count;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
		if(editingStyle == UITableViewCellEditingStyleDelete) 
		{	
			EventData *data = [[User instance].eventsList objectAtIndex:indexPath.row];
			NSLog(@"Need to store event_id %d ", [data.event_id intValue]);
			// store in deletedEvent
			if(deletedBills == nil)
			{
				deletedBills = [[NSMutableArray alloc] init];
			}
			EventData *tmp = [[EventData alloc] init];
			tmp = data;
			[deletedBills addObject:tmp];
			
			[[User instance].eventsList removeObjectAtIndex:indexPath.row];
			
			// delete from table view:
			[self.tableView beginUpdates];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
			[self.tableView endUpdates];
			
			NSLog(@"Need to update database store bill_ids in array and update when user presses Done");
		}
}
	
// Receives Edit/Done button clicks:
- (void) setEditing:(BOOL) editing animated:(BOOL) animated 
{
	
	[self.tableView setEditing:editing];	
    // pass "editing" state to base class so that edit/done button toggles
    [super setEditing:editing animated:animated];	
	NSLog(@"editing is %d", editing);
	if(editing == 0)
	{
		for(EventData *data in deletedBills)
		{
			NSString *idStr = [NSString stringWithFormat:@"%d", [data.event_id intValue]];
			NSLog(@"deleting event id %@ ", idStr);
			
			NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
			[query appendString:(@"%@",[User instance].UDID)];
			[query appendString:@"&event_id="];
			[query appendString:(@"%@",idStr)];
			[query appendString:@"&request_type=event_delete"];
			
			@try
			{
				RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
				NSString *response  = [del remoteRequest:query] ;
				NSLog(@" DELETE RESPONSE FROM SERVER %@  ", response);
			}
			@catch (NSException * e) 
			{
				NSLog(@"delete event exception caught for bill id %@", idStr);
				NSLog(@"exception: %@", [e reason]);
			}
		}
		[deletedBills release];
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)buttonClicked:(id)sender
{
	NSLog(@"buttonClicked eventsis called");
	
	if(self.eventViewController == nil)
	{		
		EventViewController *tmp = [[EventViewController alloc] initWithNibName:@"EventView" bundle:nil];
		self.eventViewController = tmp;
		[tmp release];
	}
	
	eventViewController.title = [NSString stringWithFormat:@"Add Event"];
	eventViewController.isViewOnly = FALSE;
	eventViewController.eventData = nil;
	currentSelection = -1;
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[del.eventsNavController pushViewController:eventViewController animated:YES];
	[eventViewController populate_event_info];
	
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

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	NSLog(@"numberOfRowsInSection is called");
	[searchList removeAllObjects];
	if([filterText length] == 0)
		return [[User instance].eventsList count];
	
	for(EventData *data in [User instance].eventsList)
	{
		NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:filterText 
																			 options:NSRegularExpressionCaseInsensitive error:nil];
		NSUInteger numberOfMatches = 0;
		numberOfMatches = [reg numberOfMatchesInString:data.event_title									  
											   options:0
												 range:NSMakeRange(0, [data.event_title length])];
		
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
    
    NSLog(@"inside of cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		//cell.font = [UIFont fontWithName:@"Georgia" size:22.0];
		[cell.textLabel setFont:[UIFont fontWithName:@"Georgia" size:22.0]];
	}
    
    // setup cell
	NSUInteger row = [indexPath row];	
	EventData *data;
	if([filterText length] == 0 || [searchList count] == 0)
		data = [[User instance].eventsList objectAtIndex:row];
	else 
		data = [searchList objectAtIndex:row];
	
	[cell.textLabel setText:data.event_title];
	NSInteger xx = [data.icon_id intValue];
	NSLog(@"image to select %d ", xx);
	cell.imageView.image = [UIImage imageNamed:[iconsData objectAtIndex:xx]]; 
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	currentSelection = [indexPath row];
	
	if(eventViewController == nil)
	{
		EventViewController *tmp = [[EventViewController alloc] initWithNibName:@"EventView" bundle:nil];
		self.eventViewController = tmp;
		[tmp release];
	}
	eventViewController.isViewOnly = TRUE;
	EventData *data = [[User instance].eventsList objectAtIndex:currentSelection];
	eventViewController.eventData = data;
	
	NSString *temp = [[NSString alloc] initWithString:data.event_title];
	eventViewController.title = temp;
	[temp release];	
	
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[del.eventsNavController pushViewController:eventViewController animated:YES];
	[eventViewController populate_event_info];
	
	/* if(self.responTableViewController == nil)
	{
		ResponTableViewController *details = [[ResponTableViewController alloc] initWithNibName:@"ResponsibilitiesView" bundle:nil];
		self.responTableViewController = details;
		[details release];
	}
	responTableViewController.isEvent = true;
	responTableViewController.title = [NSString stringWithFormat:@"%@", [eventsArray objectAtIndex:row]];
	
	RoomiesAppDelegate *del = [[UIApplication sharedApplication] delegate];
	NSLog(@"events: before push");
	[del.eventsNavController pushViewController:responTableViewController animated:YES];
	
	*/
	
	NSLog(@"EVENTS: finish of didSelectRowAtIndexPath");
	
}

- (void)dealloc 
{
	[eventViewController release];
	
	[searchBar release];
	[tableView release];
	
	[filterText release];
	[searchList release];
	[iconsData release];
	[deletedBills release];
    [super dealloc];
}


@end
