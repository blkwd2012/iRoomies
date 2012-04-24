//
//  SettingsViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationInfoViewController;
@class AccountInfoViewController;
@class RoomiesViewController;


@interface SettingsViewController : UIViewController {
	
	UIButton *infoBtn1;
	UIButton *infoBtn2;
	UIButton *roomies1;
	UIButton *roomies2;
	UIButton *about1;
	UIButton *about2;
	
	ApplicationInfoViewController *applInfoController;
	AccountInfoViewController *accountInfoViewController;
	RoomiesViewController *roomiesViewController;
	
	UIView *accountView;
	UIView *infoView;

}

@property (nonatomic, retain) IBOutlet UIButton *infoBtn1;
@property (nonatomic, retain) IBOutlet UIButton *infoBtn2;
@property (nonatomic, retain) IBOutlet UIButton *roomies1;
@property (nonatomic, retain) IBOutlet UIButton *roomies2;
@property (nonatomic, retain) IBOutlet UIButton *about1;
@property (nonatomic, retain) IBOutlet UIButton *about2;
@property (nonatomic, retain) IBOutlet ApplicationInfoViewController *applInfoController;
@property (nonatomic, retain) IBOutlet AccountInfoViewController *accountInfoViewController;
@property (nonatomic, retain) IBOutlet RoomiesViewController *roomiesViewController;

@property (nonatomic, retain) IBOutlet UIView *accountView;
@property (nonatomic, retain) IBOutlet UIView *infoView;

- (IBAction)buttonClicked:(id)sender;
- (void) displayAccountPage;
- (void) displayApplicationInfo;
- (void) displayRoomiesPage;


@end
