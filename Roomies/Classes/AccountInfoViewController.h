//
//  AccountInfoViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
#import "RoomiesViewController.h"
#import "InvitationAccounts.h"
#import "AccountData.h"

@class User;
@class InvitationAccounts;

@interface AccountInfoViewController : UIViewController <MKMapViewDelegate, BSForwardGeocoderDelegate>
{
	
	UITextField *name;
	UITextField *address1;
	UITextField *address2;
	UITextField *creator;
	UITextField *creator_num;
	
	UIButton *addRommies;
	UIButton *viewRoomies;
	UIButton *deleteRommies;
	
	UILabel *invitLbl;
	UIButton *acceptButton;
	UIButton *ignoreButton;	
	UIButton *mapButton;
	
	UIView   *mapView;
	MKMapView *mkMapView;
	
	UIViewController *mapController;
	UIViewController *inviteController;
	
	UIView   *accountView;
	BSForwardGeocoder *forwardGeocoder;
	RoomiesViewController *roomiesViewController;
	NSInteger account_id;
	
	// TRY
	AccountData *account;
	
@public
	NSInteger mode; /* 0 - view, 1 - add, 2 - intitation(show accept and ignore buttons only) */
	InvitationAccounts *invitationAccountsController;
}

@property (nonatomic) NSInteger mode;
//@property (nonatomic) bool isViewOnly; // view or add mode
//@property (nonatomic) bool addAccount; // add or existing account

@property (nonatomic, retain) AccountData *account;

@property (nonatomic, assign) NSInteger account_id;
@property (nonatomic, retain) IBOutlet RoomiesViewController *roomiesViewController;
@property (nonatomic, retain) InvitationAccounts *invitationAccountsController;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;
@property (nonatomic, retain) IBOutlet UIViewController *mapController;

@property (nonatomic, retain) IBOutlet UIViewController *inviteController;
@property (nonatomic, retain) IBOutlet UIView *mapView;
@property (nonatomic, retain) IBOutlet MKMapView *mkMapView;
@property (nonatomic, retain) IBOutlet UIView   *accountView;

@property (nonatomic, retain) IBOutlet UILabel *invitLbl;
@property (nonatomic, retain) IBOutlet UIButton *acceptButton;
@property (nonatomic, retain) IBOutlet UIButton *ignoreButton;

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *address1;
@property (nonatomic, retain) IBOutlet UITextField *address2;
@property (nonatomic, retain) IBOutlet UITextField *creator;
@property (nonatomic, retain) IBOutlet UITextField *creator_num;

@property (nonatomic, retain) IBOutlet UIButton *addRommies;
@property (nonatomic, retain) IBOutlet UIButton *viewRoomies;
@property (nonatomic, retain) IBOutlet UIButton *deleteRommies;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;

- (void) viewAccount:(AccountData *)data;
- (IBAction) editingChanged:(id)sender;
- (IBAction) buttonClicked:(id)sender;
- (IBAction) leaveField:(id) sender;

- (IBAction) deleteAccountClicked:(id) sender;
- (IBAction) viewRoomiesClicked:(id) sender;
- (IBAction) inviteRoomiesClicked:(id) sender;
- (IBAction) acceptClicked:(id) sender;
- (IBAction) ignoreClicked:(id) sender;
- (IBAction) mapClicked:(id) sender;

- (void) displayAccountInfo;
- (void) displayLocationOnMap:(MKCoordinateRegion)region;


@end
