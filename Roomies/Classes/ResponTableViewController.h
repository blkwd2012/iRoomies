//
//  ResponTableViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResponsibilityViewController;
#import "RespData.h"

@interface ResponTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate> {

	UITableView *tableView;
	UISearchBar *searchBar;
	
	//UITableView *tableViewR;
	//UITableView *tableViewE;
	
	ResponsibilityViewController *responsibilityViewController;
	NSMutableString *filterText;
	NSMutableArray *searchList;

	NSInteger currentSelection;
	NSMutableArray *deletedBills;
	
	//NSMutableArray *eventsResponList;
	NSMutableArray *iconsData;
	
	
@public
	NSNumber *isEvent;
	NSNumber *event_id;
}

//@property (nonatomic, retain) NSMutableArray *eventsResponList;
@property (nonatomic, retain) NSMutableArray *iconsData;
@property (nonatomic, retain) NSNumber *event_id;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

//@property (nonatomic, retain) UITableView *tableViewR;
//@property (nonatomic, retain) UITableView *tableViewE;

@property (nonatomic, retain) IBOutlet ResponsibilityViewController *responsibilityViewController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableString *filterText;
@property (nonatomic, retain) NSMutableArray *searchList;
@property (nonatomic, retain) NSMutableArray *deletedBills;

@property (nonatomic, retain) NSNumber *isEvent;

- (IBAction)buttonClicked:(id)sender;

- (void) addItem:(RespData *)data;
- (void) updateItem:(RespData *)data;
- (int) deleteItem:(RespData *) data;
- (void) loadResponsibilities;
- (void) printEventsResp;

@end
