//
//  BillsViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BillsViewController.h"
#import "BillViewController.h"
#import "RoomiesAppDelegate.h"
#import "User.h"

@implementation BillsViewController

@synthesize searchBar;
@synthesize tableView;
@synthesize totalLbl;
@synthesize personLbl;
@synthesize filterText;
@synthesize searchList;
@synthesize billViewController;

@synthesize deletedBills;
@synthesize iconsData;

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


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSLog(@"BILLS inside of viewDidLoad bills number %d ", [[User instance].billsList count]);
	
	self.iconsData= [[NSMutableArray alloc] initWithObjects: @"house.png", @"TV.png", @"Internet.png", @"Phone.png", @"Light.png", @"dollar.png", nil];
	
	currentSelection = -1;
	self.title = NSLocalizedString(@"Bills", @"Account Bills");
	self.filterText = [[NSMutableString alloc] init];
	self.searchList = [NSMutableArray array];
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	searchBar.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
	
	// need to create Edit button
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	[self.tableView reloadData];
	[self updateTotals];
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
		for(BillData *data in deletedBills)
		{
			NSString *idStr = [NSString stringWithFormat:@"%d", [data.bill_id intValue]];
			NSLog(@"deleting bill id %@ ", idStr);
			
			NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
			[query appendString:(@"%@",[User instance].UDID)];
			[query appendString:@"&bill_id="];
			[query appendString:(@"%@",idStr)];
			[query appendString:@"&request_type=bill_delete"];
			
			@try
			{
				
				NSString *response  = [self remoteRequest:query] ;
				NSLog(@" DELETE RESPONSE FROM SERVER %@  ", response);
			}
			@catch (NSException * e) 
			{
				NSLog(@"delete bill exception caught for bill id %@", idStr);
				NSLog(@"exception: %@", [e reason]);
			}
		}
		[deletedBills release];
	}
	
	NSLog(@"editing is %d", editing);
}

- (NSString *)remoteRequest:(NSString *)query 
{
	//method to execute a request 
	NSString *post = [[NSString alloc]initWithFormat:@"%@",query];
	NSLog(@"POST DATA: %@", post);
	NSData *postData=[post dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://128.238.66.30/~map01/authenticate.php"]];
	[connectionRequest setHTTPMethod:@"POST"];
	[connectionRequest setTimeoutInterval:30.0];
	[connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[connectionRequest setHTTPBody:postData];
	
	NSData *data=[NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:nil];
	NSString *stringdata=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return stringdata;
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"editingStyle is %d row %d ", editingStyle, indexPath.row);
	if(editingStyle == UITableViewCellEditingStyleDelete) 
	{	
		BillData *data = [[User instance].billsList objectAtIndex:indexPath.row];
		NSLog(@"Need to store bill_id %d ", [data.bill_id intValue]);
		// store in deletedBills
		if(deletedBills == nil)
		{
			deletedBills = [[NSMutableArray alloc] init];
		}
		BillData *tmp = [[BillData alloc] init];
		tmp = data;
		[deletedBills addObject:tmp];
		
		[[User instance].billsList removeObjectAtIndex:indexPath.row];
		
		// delete from table view:
		[self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];		
		[self.tableView endUpdates];
		
		NSLog(@"Need to update database store bill_ids in array and update when user presses Done");
	}
}

- (IBAction)buttonClicked:(id)sender
{
	NSLog(@"buttonClicked BILLS called");
	//if(sender == <buttonName)
	
	if(self.billViewController == nil)
	{		
		BillViewController *BillDeatils = [[BillViewController alloc] initWithNibName:@"BillView" bundle:nil];
		self.billViewController = BillDeatils;
		[BillDeatils release];
	}
	
	billViewController.title = [NSString stringWithFormat:@"Add Bill"];
	billViewController.isViewOnly = FALSE;
	self.billViewController.billData = nil;
	currentSelection = -1;
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	[del.billsNavController pushViewController:billViewController animated:YES];
	[billViewController populate_bill_info];
	//NSLog(@"finish of buttonClicked");
}

- (void) addItem:(BillData *)data
{
	if ([User instance].billsList == nil) {
		[User instance].billsList = [[NSMutableArray alloc]init];
	}
	//NSLog(@"addItem called count %d", [[User instance].billsList count]);
	//NSLog(@"%p", data);
	[[User instance].billsList addObject:data];
	NSLog(@"addItem after count %d", [[User instance].billsList count]);
	[self.tableView reloadData];
	[self updateTotals];
}


- (int) deleteItem:(BillData *)data
{
	NSLog(@"deleteItem called, index %d count %d", currentSelection, [[User instance].billsList count]);

	User *user = [User instance];
	int count = -1;
	if(currentSelection == -1)
	{
		for(BillData *tmp in user.billsList)
		{
			count = count + 1;
			if([tmp.bill_id intValue] == [data.bill_id intValue])
			{
				NSLog(@"deleteItem called, index %d bills count %d before", count, [[User instance].billsList count]);
				[[User instance].billsList removeObjectAtIndex:count];
				break;
			}
		}
	}
	else
	{
		count = currentSelection;
		[user.billsList removeObjectAtIndex:currentSelection];
	}
	NSLog(@"deleteItem after count %d after ", [[User instance].billsList count]);
	[self.tableView reloadData];
	[self updateTotals];
	
	return count;
}


- (void) updateItem:(BillData *)data
{
	NSLog(@"updateItem called, index %d count %d, icon_id %d", 
		  currentSelection, [[User instance].billsList count], [data.icon_id intValue]);

	int position = [self deleteItem:data];
	NSLog(@"insert at position %d", position);
	if(position != -1)
		[[User instance].billsList insertObject:data atIndex:position];
	//return;
	NSLog(@"updateItem after count %d", [[User instance].billsList count]);
	[self.tableView reloadData];
	[self updateTotals];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
	NSLog(@"numberOfSectionsInTableView is called");
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
	NSLog(@"BILLS numberOfRowsInSection is called");
	[searchList removeAllObjects];
	if([filterText length] == 0)
		return [[User instance].billsList count];
	
	for(BillData *data in [User instance].billsList)
	{
		NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:filterText 
												options:NSRegularExpressionCaseInsensitive error:nil];
		NSUInteger numberOfMatches = 0;
		NSLog(@" BILL TITLE %@ ", data.bill_title);
		numberOfMatches = [reg numberOfMatchesInString:data.bill_title									  
													options:0
													range:NSMakeRange(0, [data.bill_title length])];
		
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
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
    static NSString *CellIdentifier = @"Cell";
    
	UILabel *nameLbl = nil;
	UILabel *statusLbl = nil;
	static NSUInteger const kNameLabelTag = 2;
    static NSUInteger const kStatusLabelTag = 3;
	
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
		//cell.font = [UIFont fontWithName:@"Georgia" size:22.0];
		[cell.textLabel setFont:[UIFont fontWithName:@"Georgia" size:22]];
		
		nameLbl = [[[UILabel alloc] initWithFrame:CGRectMake(50, 3, 190, 20)] autorelease];
        nameLbl.tag = kNameLabelTag;
        nameLbl.font = [UIFont boldSystemFontOfSize:16];
		nameLbl.opaque = NO;
		[nameLbl  setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:nameLbl];
        
        statusLbl = [[[UILabel alloc] initWithFrame:CGRectMake(50, 28, 170, 14)] autorelease];
        statusLbl.tag = kStatusLabelTag;
        statusLbl.font = [UIFont systemFontOfSize:13];
		statusLbl.opaque = NO;		
		[statusLbl  setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:statusLbl];
		
		cell.textLabel.opaque = NO;
	}
	else
	{
		nameLbl = (UILabel *)[cell.contentView viewWithTag:kNameLabelTag];
        statusLbl = (UILabel *)[cell.contentView viewWithTag:kStatusLabelTag];
	}
    
    // setup cell
	User *user = [User instance];
	NSUInteger row = [indexPath row];	
	BillData *data;
	if([filterText length] == 0 || [searchList count] == 0)
		data = [user.billsList objectAtIndex:row];
	else 
		data = [searchList objectAtIndex:row];
	
	//[cell.textLabel setText:data.bill_title];
	nameLbl.text = data.bill_title;
	
	NSString *status = nil;
	if([data.bill_status intValue] == 1)
		status = [NSString stringWithFormat:@"Paid"];
	else
		status = [NSString stringWithFormat:@"Not Paid"];
	
    statusLbl.text = [NSString stringWithFormat:@"Bill status : %@", status];
	[cell.textLabel setBackgroundColor:[UIColor clearColor]];
	
	NSInteger xx = [data.icon_id intValue];
	UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:xx]];// autorelease] ; 
	cell.imageView.image = img;
	//[img release];
	/*
	 cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal.png"]];
	 cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];

	 */
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
	currentSelection = [indexPath row];
	NSLog(@">>>> BILLS ROW %d ", currentSelection);
	if(self.billViewController == nil)
	{		
		BillViewController *BillDeatils = [[BillViewController alloc] initWithNibName:@"BillView" bundle:nil];
		self.billViewController = BillDeatils;
		[BillDeatils release];
	}
	self.billViewController.isViewOnly = TRUE;
	BillData *data = [[User instance].billsList objectAtIndex:currentSelection];
	self.billViewController.billData = data; //[[BillData alloc] init];
	
	NSString *temp = [[NSString alloc] initWithString:data.bill_title];
	billViewController.title = temp;
	[temp release];
	
	// push on navigation stack 
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[del.billsNavController pushViewController:billViewController animated:YES];
	
	NSLog(@"BILLS BEFORE TITLE populate_bill_info %@ ", data.bill_title);
	[billViewController populate_bill_info];
	NSLog(@"BILLS AFTER populate_bill_info ");
	
}

- (void) updateTotals
{
	NSLog(@"updateTotals is called bills count %d ", [[User instance].billsList count]);
	float total = 0.0;
	for(BillData *data in [User instance].billsList)
	{
		total += [data.bill_amount floatValue];
	}
	NSLog(@"updateTotals total: %f number of roomies %d ", total, [User instance].accountData.active_roomies_number);
	float perPerson = 0.0;
	
	if(total != 0.0) perPerson = total / [User instance].accountData.active_roomies_number;
	
	NSString *temp = [[NSString alloc] initWithFormat:@"Bills Total: $%.2f", total];
	totalLbl.text = temp;
	[temp release];
	
	temp = [[NSString alloc] initWithFormat:@"Per person: $%.2f", perPerson];
	personLbl.text = temp;
	[temp release];
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
	[billViewController release];
	[filterText release];
	[searchList release];
	
	[searchBar release];
	[tableView release];
	[totalLbl release];
	[personLbl release];
	[deletedBills release];
	[iconsData release];
	
    [super dealloc];
}


@end

