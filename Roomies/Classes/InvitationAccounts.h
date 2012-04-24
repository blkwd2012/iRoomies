//
//  InvitationAccounts.h
//  Roomies
//
//  Created by Anna Zakharova on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfoViewController.h"


@interface InvitationAccounts : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *tableView;
	
	AccountInfoViewController *accountInfoViewController;
	NSInteger currentSelection;
}

@property (nonatomic, assign) NSInteger currentSelection;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet AccountInfoViewController *accountInfoViewController;
- (void) deleteItem;

@end
