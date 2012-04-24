//
//  InviteViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookViewController.h"

@class AddressBookViewController;

@interface InviteViewController : UIViewController 
{
	UITextField *userInput;
	UIButton *sendButton;
	UIButton *addButton;
	
	AddressBookViewController *contactsController;
	
	NSMutableString *phoneNum;
	NSMutableString *emailAddress;
 }

@property (nonatomic, retain) IBOutlet UITextField *userInput;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) NSMutableString *phoneNum;
@property (nonatomic, retain) NSMutableString *emailAddress;

@property (nonatomic, retain) IBOutlet AddressBookViewController *contactsController;


-(void)setChoice:(NSString *)name:(NSString *)num:(NSString *)email;
- (IBAction)addButtonClicked:(id)sender;
- (IBAction)sendInviteButtonClicked:(id)sender;

@end
