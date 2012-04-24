//
//  BillsViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillData.h"

@class BillViewController;


@interface BillsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
	
	UISearchBar *searchBar;
	UITableView *tableView;
	UILabel *totalLbl;
	UILabel *personLbl;
	NSInteger currentSelection;
	NSMutableString *filterText;
	NSMutableArray *searchList;
	
	NSMutableArray *deletedBills;
	NSMutableArray *iconsData;
	
	BillViewController *billViewController;

}

@property (nonatomic, retain) NSMutableArray *iconsData;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *totalLbl;
@property (nonatomic, retain) IBOutlet UILabel *personLbl;
@property (nonatomic, retain) IBOutlet BillViewController *billViewController;
@property (nonatomic, retain) NSMutableString *filterText;
@property (nonatomic, retain) NSMutableArray *searchList;

@property (nonatomic, retain) NSMutableArray *deletedBills;

- (IBAction)buttonClicked:(id)sender;

- (void) addItem:(BillData *)data;
- (void) updateItem:(BillData *)data;
- (int) deleteItem:(BillData *)data;
- (void) updateTotals;
- (NSString *)remoteRequest:(NSString *)query;

@end
