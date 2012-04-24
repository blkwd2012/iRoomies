//
//  InvitationsViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 11/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationInfoViewController;
@class AccountInfoViewController;
@class InvitationAccounts;


@interface InvitationsViewController : UIViewController {
	
	IBOutlet UIButton *invitBtn;
	IBOutlet UIButton *accountBtn;
	IBOutlet UIButton *infoBtn;
	InvitationAccounts *invitationAccounts;
	
	//AccountInfoViewController ?? create here or use delegate one 
	
	ApplicationInfoViewController *applInfoController;
	AccountInfoViewController *accountInfoViewController;

}

@property (nonatomic, retain) IBOutlet UIButton *invitBtn;
@property (nonatomic, retain) IBOutlet UIButton *accountBtn;
@property (nonatomic, retain) IBOutlet UIButton *infoBtn;

@property (nonatomic, retain) IBOutlet InvitationAccounts *invitationAccounts;
@property (nonatomic, retain) IBOutlet AccountInfoViewController *accountInfoViewController;
@property (nonatomic, retain) IBOutlet ApplicationInfoViewController *applInfoController;

- (IBAction)buttonClicked:(id)sender;

- (void) displayAccountPage;
- (void) displayApplInfo;
- (void) createInvitationsView;

@end
