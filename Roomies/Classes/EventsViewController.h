//
//  EventsViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventData.h"
#import "User.h"

@class EventViewController;


@interface EventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{	
	UISearchBar *searchBar;
	UITableView *tableView;
	NSInteger currentSelection;
	EventViewController *eventViewController;
	
	NSMutableString *filterText;
	NSMutableArray *searchList;
	NSMutableArray *iconsData;
	NSMutableArray *deletedBills;
}

@property (nonatomic, retain) NSMutableArray *deletedBills;
@property (nonatomic, retain) NSMutableArray *iconsData;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet EventViewController *eventViewController;

@property (nonatomic, retain) NSMutableString *filterText;
@property (nonatomic, retain) NSMutableArray *searchList;

- (IBAction)buttonClicked:(id)sender;

- (void) addItem:(EventData *)data;
- (void) updateItem:(EventData *)data;
- (int) deleteItem:(EventData *)data;


@end
