//
//  ResponTableViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResponTableViewController.h"
#import "ResponsibilityViewController.h"
#import "RoomiesAppDelegate.h"
#import "User.h"
#import "Parser.h"

@implementation ResponTableViewController

@synthesize responsibilityViewController;
@synthesize tableView;
@synthesize searchBar;
@synthesize isEvent;
@synthesize iconsData;
//@synthesize eventsResponList;

@synthesize filterText;
@synthesize searchList;
@synthesize deletedBills;
@synthesize event_id;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSLog(@"Responsibilities: initWithNibName");
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        NSLog(@"Responsibilities: good pointer");
    }
    return self;
}*/

- (void)viewDidLoad 
{
	NSLog(@"RESPONS of viewDidLoad");
    [super viewDidLoad];
	
	self.iconsData= [[NSMutableArray alloc] initWithObjects: @"DefaultResponsibility.png", @"Shopping.png", @"Bake.png", @"CleanHouse.png", @"Cook.png", @"Food.png", nil];

	//self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"nav_grey2.png"]];
	
	currentSelection = -1;
	/* for testing */
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	searchBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
	
	if([isEvent intValue] == 1)
	{		
		/* if(self.tableViewE == nil)
		{
		self.tableViewE = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44, 320, 416) 
														style:UITableViewStylePlain]; // autorelease];
		self.tableViewE.dataSource = self;
		self.tableViewE.delegate = self;
		[self.tableViewE setAlwaysBounceVertical:YES];
		self.tableViewE.backgroundColor = [UIColor clearColor];
		self.tableViewE.opaque = NO;
		
		NSLog(@"**** SELF %p TABLE FOR EVENT %p isEvent %d", 
			  self, self.tableViewE, [isEvent intValue]);
						   
		[self.view addSubview:tableViewE];
		} */
	
		UIBarButtonItem *btn =
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
												  target:self
													  action:@selector(buttonClicked:)];
		self.navigationItem.rightBarButtonItem = btn;
		[btn release];
		//[self.tableViewE reloadData];
	}
	else
	{
		/* self.tableViewR = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 44, 320, 416) 
												style:UITableViewStylePlain]; // autorelease];
		
		NSLog(@"**** TABLE FOR RESPONS SELF %p isEvent %d TABLE %p", 
			  self, [isEvent intValue], self.tableViewR);
		
		if(self.tableViewR == nil)
		{
		self.tableViewR.dataSource = self;
		self.tableViewR.delegate = self;
		//self.tableViewR.scrollingE;
		[self.tableViewR setAlwaysBounceVertical:YES];
		self.tableViewR.backgroundColor = [UIColor clearColor];
		self.tableViewR.opaque = NO;
		
		[self.view addSubview:tableViewR];
		} */
		
		NSMutableArray *temp = [User instance].responsList;
		NSLog(@"number of responsibilities : %d, isEvent = %d", [temp count], [isEvent intValue]);
		[temp release];
		
		// need to create Edit button
		/*UIBarButtonItem *customEditButton = [[UIBarButtonItem alloc]  
		 initWithImage:[UIImage imageNamed:@"nav_grey2.png"] 
		 style:UIBarButtonItemStylePlain  
		 target:nil action:nil]; */ 
		//self.navigationItem.backBarButtonItem = backButton;  
		//self.navigationItem.leftBarButtonItem = customEditButton;
		//[customEditButton release]; 
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
		//[self.tableViewR reloadData];
		
	}
	self.title = NSLocalizedString(@"Responsibilities", @"Account Responsobilities");
	self.filterText = [[NSMutableString alloc] init];
	self.searchList = [NSMutableArray array];
	[self.tableView reloadData];
	
}

- (void) loadResponsibilities
{
	NSLog(@" LOADING RESPONS ++++ for event %d ", [event_id intValue]);
	
	Parser *parser = [Parser alloc];
	NSMutableString * query = nil;
	query = [[NSMutableString alloc ]initWithFormat:@"event_id="] ;
	[query appendString :(@"%@", [event_id stringValue])];
	[query appendString:@"&UDID="];
	[query appendString:(@"%@",[User instance].UDID)];
	[query appendString:@"&request_type=request_resp_event_info"];
	
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	@try 
	{
		if([User instance].eventsResponList != nil)
		{
			[[User instance].eventsResponList release];
			NSLog(@"Released [User instance].eventsResponList ");
		}
		[parser initWithNSData:[del setUpConnection:query]];
		[User instance].eventsResponList = [parser parseObjectList:Resps];
		NSLog(@"Size of eventsResponList : %d", [[User instance].eventsResponList count]);
	}
	@catch(NSException * e) 
	{
		NSLog(@"RESPONS No rows found in resps !");
		[User instance].eventsResponList = nil ;
	}
	//[self.tableViewE reloadData];
	[self.tableView reloadData];
	
	//[self printEventsResp];
}

- (void) printEventsResp
{
	NSLog(@" PRINT DATA PTR %p ", [User instance].eventsResponList);
	
	for(RespData *data in [User instance].eventsResponList)
	{
		NSLog(@"EVENT ID %d ", [data.event_id intValue]);
		NSLog(@" TITLE %@ ", data.resp_title);
	}
}

- (void) addItem:(RespData *)data
{
	NSLog(@" >>>>> SELF %p RESPONS adding item isEvent %d >>>> tableView %p", 
		  self, 
		  [isEvent intValue] , self.tableView);
	
	User *user = [User instance];
	
	NSLog(@"ADD ITEM BEFORE RESPS list %d EVENT list %d ",
		  [user.responsList  count], [user.eventsResponList count] );
	
	if([isEvent intValue] != 1)
	{
		if(user.responsList == nil)
			user.responsList = [[NSMutableArray alloc] init];
		
		[user.responsList addObject:data];
		NSLog(@"addItem12 responsList after count %d", [user.responsList count]);
		//[self.tableViewR reloadData];
	}
	else 
	{
		if(user.eventsResponList == nil)
			user.eventsResponList = [[NSMutableArray alloc] init];
		
		NSLog(@"addItem23 eventsResponList BEFORE count %d", [user.eventsResponList count]);
		
		[user.eventsResponList addObject:data];
		NSLog(@"addItem23 eventsResponList after count %d", [user.eventsResponList count]);
		[self printEventsResp];
		
		//[self.tableViewE reloadData];
	}
	NSLog(@"ADD ITEM AFTER RESPS list %d EVENT list %d ",
		  [user.responsList  count], [user.eventsResponList count] );
	[self.tableView reloadData];
}

- (void) updateItem:(RespData *)data
{
	User *user = [User instance];
	int position = [self deleteItem:data];
	
	if([isEvent intValue] != 1)
	{
		if(position != -1)
			[user.responsList insertObject:data atIndex:position];
		NSLog(@"updateItem responsList after count %d", [user.responsList count]);
		//[self.tableViewR reloadData];
	}
	else 
	{
		if(position != -1)
			[[User instance].eventsResponList insertObject:data atIndex:position];
		
		NSLog(@"updateItem eventsResponList after count %d POSITION %d ", 
			  [[User instance].eventsResponList count], position);
		//[self.tableViewE reloadData];
	}
	[self.tableView reloadData];
}

- (int) deleteItem:(RespData *)data
{
	User *user = [User instance];
	int count = -1;
	
	NSLog(@"deleteItem currentSelection %d ", currentSelection);
	
	if(currentSelection == -1)
	{
		if([isEvent intValue] != 1)
		{
			for(RespData *tmp in user.responsList)
			{
				count = count + 1;
				if([tmp.resp_id intValue] == [data.resp_id intValue])
				{
					NSLog(@"deleteItem called, index %d resp count %d before", count, [[User instance].responsList count]);
					[[User instance].responsList removeObjectAtIndex:count];
					break;
				}
			}
		}
		else 
		{
			for(RespData *tmp in [User instance].eventsResponList)
			{
				count = count + 1;
				if([tmp.resp_id intValue] == [data.resp_id intValue])
				{
					NSLog(@"deleteItem called, index %d resp count %d before", count, [[User instance].eventsResponList count]);
					[[User instance].eventsResponList removeObjectAtIndex:count];
					break;
				}
			}
		}

	}
	else 
	{
		count = currentSelection;
		if([isEvent intValue] != 1)
		{
			[user.responsList removeObjectAtIndex:currentSelection];
			NSLog(@"NOT EVENT deleteItem responsList after count %d", [[User instance].responsList count]);
		}
		else 
		{
			[[User instance].eventsResponList removeObjectAtIndex:currentSelection];
			NSLog(@"EVENT deleteItem responsList after count %d", [[User instance].eventsResponList count]);
		}
	}
	/* if([isEvent intValue] != 1)
		[self.tableViewR reloadData];
	else
		[self.tableViewE reloadData]; */
	[self.tableView reloadData];
	
	return count;
}

// Receives Edit/Done button clicks:
- (void) setEditing:(BOOL) editing animated:(BOOL) animated 
{
	/* if([isEvent intValue] != 1)
		[self.tableViewR setEditing:editing];
	else
		[self.tableViewE setEditing:editing]; */
	
	[self.tableView setEditing:editing];
	
    // pass "editing" state to base class so that edit/done button toggles
    [super setEditing:editing animated:animated];
	
	if(editing == 0)
	{
		for(RespData *data in deletedBills)
		{
			NSString *idStr = [NSString stringWithFormat:@"%d", [data.resp_id intValue]];
			NSLog(@"deleting resp id %@ ", idStr);
			
			NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
			[query appendString:(@"%@",[User instance].UDID)];
			[query appendString:@"&resp_id="];
			[query appendString:(@"%@",idStr)];
			[query appendString:@"&request_type=resp_delete"];
			
			@try
			{
				RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
				NSString *response  = [del remoteRequest:query] ;
				NSLog(@" DELETE RESPONSE FROM SERVER %@  ", response);
			}
			@catch (NSException * e) 
			{
				NSLog(@"delete respon exception caught for resp id %@", idStr);
				NSLog(@"exception: %@", [e reason]);
			}
		}
		[deletedBills release];
	}
	
	NSLog(@"editing is %d", editing);
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"commitEditingStyle isEvent %d ", [isEvent intValue]);
	User *user = [User instance];
	
	if(editingStyle == UITableViewCellEditingStyleDelete) 
	{
		RespData *data = nil;
		if([isEvent intValue] != 1)
			data = [[User instance].responsList objectAtIndex:indexPath.row];
		else 
			data = [[User instance].eventsResponList objectAtIndex:indexPath.row];

		NSLog(@"Need to store resp_id %d for delete", [data.resp_id intValue]);
		// store in deletedBills
		if(deletedBills == nil)
		{
			deletedBills = [[NSMutableArray alloc] init];
		}
		RespData *tmp = [[RespData alloc] init];
		tmp = data;
		[deletedBills addObject:tmp];
		NSLog(@"Need to store done ");
		
        //delete from the array:
		if([isEvent intValue] != 1)
		{
			[user.responsList removeObjectAtIndex:indexPath.row];
			//Delete the object from the table:
			//[self.tableViewR beginUpdates];
			//[self.tableViewR deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
			//[self.tableViewR endUpdates];
		}
		else 
		{
			[[User instance].eventsResponList removeObjectAtIndex:indexPath.row];
			//[self.tableViewE beginUpdates];
			//[self.tableViewE deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
			//[self.tableViewE endUpdates];
			
		} 
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
		[self.tableView endUpdates];
	}
}

- (IBAction)buttonClicked:(id)sender
{
	NSLog(@"buttonClicked");
	
	if(self.responsibilityViewController == nil)
	{		
		ResponsibilityViewController *responsibility = [[ResponsibilityViewController alloc] initWithNibName:@"ResponsibilityView" bundle:nil];
		self.responsibilityViewController = responsibility;
		[responsibility release];
	}
	
	responsibilityViewController.title = [NSString stringWithFormat:@"Add Responsibility"];
	responsibilityViewController.isViewOnly = FALSE;
	responsibilityViewController.respData = nil;
	responsibilityViewController.isEvent = [isEvent intValue];
	currentSelection = -1;
	if([isEvent intValue] == 1)
		responsibilityViewController.event_id = event_id;
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([isEvent intValue] != 1)
		[del.responNavController pushViewController:responsibilityViewController animated:YES];
	else 
		[del.eventsNavController pushViewController:responsibilityViewController animated:YES];
		
	[responsibilityViewController populate_resp_info];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	//NSLog(@"textDidChange is called");
	
	[filterText setString:searchText];
	NSLog(@"textDidChange is called with: %@", filterText);
	/* if([isEvent intValue] != 1)
		[self.tableViewR reloadData]; 
	else
		[self.tableViewE reloadData]; */
	
	[self.tableView reloadData];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)sBar
{
	NSLog(@"searchBarCancelButtonClicked is called");
	sBar.text = @"";
	
	[sBar resignFirstResponder];
}



- (void)viewWillAppear:(BOOL)animated 
{
	NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	//[self printEventsResp];
	
	if([isEvent intValue] != 1)
	{
		[searchList removeAllObjects];
		if([filterText length] == 0)
			return [[User instance].responsList count];
		
		for(RespData *data in [User instance].responsList)
		{
			NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:filterText 
																				 options:NSRegularExpressionCaseInsensitive error:nil];
			NSUInteger numberOfMatches = 0;
			numberOfMatches = [reg numberOfMatchesInString:data.resp_title									  
												   options:0
													 range:NSMakeRange(0, [data.resp_title length])];
			
			if(numberOfMatches > 0)
			{
				//NSLog(@"found!!!!");
				[searchList addObject:data];
			}
		}
		//NSLog(@"!!!!!!!!!!!!return searchList count %d", [searchList count]);
		return [searchList count];
	}
	else 
	{
		NSLog(@" searchList %d filterText %@ %d ", 
			  [searchList count], filterText, [[User instance].eventsResponList count]);
		
		if([filterText length] == 0)
			return [[User instance].eventsResponList count];
		
		if(searchList) 
			[searchList removeAllObjects];
		
		for(RespData *data in [User instance].eventsResponList)
		{
			NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:filterText 
																				 options:NSRegularExpressionCaseInsensitive error:nil];
			NSUInteger numberOfMatches = 0;
			numberOfMatches = [reg numberOfMatchesInString:data.resp_title									  
												   options:0
													 range:NSMakeRange(0, [data.resp_title length])];
			
			if(numberOfMatches > 0)
			{
				[searchList addObject:data];
			}
		}
		return [searchList count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    NSLog(@"PAINT cellForRowAtIndexPath");
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	/* if(tv == tableViewR)
	{
		NSLog(@"PAINT cellForRowAtIndexPath RESPONS");
		cell = [tableViewR dequeueReusableCellWithIdentifier:CellIdentifier];
	}
	else
	{
		NSLog(@"PAINT cellForRowAtIndexPath EVENT");
		cell = [tableViewE dequeueReusableCellWithIdentifier:CellIdentifier];
	} */
	
    if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell.textLabel setFont:[UIFont fontWithName:@"Georgia" size:22]];
	}
    
    // setup cell
	NSUInteger row = [indexPath row];
	NSLog(@"PAINT CELLS RESPONS  %d IS-EVENT %d ", row, [isEvent intValue]);
	
	RespData *data;
	if([filterText length] == 0 || [searchList count] == 0)
	{
		if([isEvent intValue] != 1)
			data = [[User instance].responsList objectAtIndex:row];
		else 
			data = [[User instance].eventsResponList objectAtIndex:row];
	}
	else 
		data = [searchList objectAtIndex:row];
	
	[cell.textLabel setText:data.resp_title];
	NSInteger xx = [data.icon_id intValue];
	NSLog(@"*** ICON ID %d IMAGE %@ ", xx, [self.iconsData objectAtIndex:xx]);
	cell.imageView.image = [UIImage imageNamed:[self.iconsData objectAtIndex:xx]]; 
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"RESPONS inside of didSelectRowAtIndexPath");
	
	currentSelection = [indexPath row];
	if(self.responsibilityViewController == nil)
	{
		ResponsibilityViewController *respsDeatils = [[ResponsibilityViewController alloc] initWithNibName:@"ResponsibilityView" bundle:nil];
		self.responsibilityViewController = respsDeatils;
		[respsDeatils release];
	}
	
	if([isEvent intValue] == 1)
	{
		responsibilityViewController.isEvent = true;
	}
	else 
	{
		responsibilityViewController.isEvent = false;
	}
	
	self.responsibilityViewController.isViewOnly = TRUE;
	RespData *data = nil;
	if([isEvent intValue] != 1)
		data = [[User instance].responsList objectAtIndex:currentSelection];
	else 
		data = [[User instance].eventsResponList objectAtIndex:currentSelection];
	
	self.responsibilityViewController.respData = data;
	self.responsibilityViewController.event_id = data.event_id;
	
	NSString *temp = [[NSString alloc] initWithString:data.resp_title];
	responsibilityViewController.title = temp;
	[temp release];
	
	RoomiesAppDelegate *del = (RoomiesAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([isEvent intValue] == 1)
		[del.eventsNavController pushViewController:responsibilityViewController animated:YES];
	else 
		[del.responNavController pushViewController:responsibilityViewController animated:YES];

	[responsibilityViewController populate_resp_info];
	//[responsibilityViewController release];
	
	NSLog(@"RESPONS finish of didSelectRowAtIndexPath");
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
	[filterText release];
	[searchList release];
	[tableView release];
	//[tableViewR release];
	//[tableViewE release];
	
	[searchBar release];
	[responsibilityViewController release];
	[deletedBills release];
	[event_id release];
	//[eventsResponList release];
	[iconsData release];
	
    [super dealloc];
}


@end

