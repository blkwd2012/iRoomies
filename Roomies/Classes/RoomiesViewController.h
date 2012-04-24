//
//  RoomiesViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomieData.h"
#import "RoomiesAppDelegate.h"

@interface RoomiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> 
{
	UITableView *tableView;
	//NSMutableArray *dataArray;
	UISearchBar *searchBar;
	
	NSMutableString *filterText;
	NSMutableArray *searchList;
	NSMutableArray *deletedRoomies;

}

@property (nonatomic, retain) NSMutableArray *deletedRoomies;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableString *filterText;
@property (nonatomic, retain) NSMutableArray *searchList;

- (IBAction) didEndEdit:(id) sender;
- (void) deleteUser:(RoomieData *) UserData;


@end
