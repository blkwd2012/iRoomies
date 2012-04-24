//
//  AddressBookViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

//#import <ABPeoplePickerNavigationController.h>
//#import <ABAdd
@class InviteViewController;

@interface AddressBookViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>
{
	IBOutlet ABPeoplePickerNavigationController *picker;
	IBOutlet InviteViewController *inviteViewController;
}

@property (nonatomic, retain) IBOutlet ABPeoplePickerNavigationController *picker;
@property (nonatomic, retain) IBOutlet InviteViewController *inviteViewController;


@end
