//
//  RoomiesAppDelegate.h
//  Roomies
//
//  Created by Antoine Boyer on 15/10/10.
//  Copyright Moi 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillsNavController;
@class ResponNavController;
@class EventsNavController;
@class SettingsNavController;
@class ApplicationInfoViewController;
@class AccountInfoViewController;
@class ResponTableViewController;
@class RoomiesViewController;

@class EventsViewController;

@class BillsViewController;

@class InvitationsViewController;
@class InvitationNavController;
@class Parser;
@class XMPPStream;

@interface RoomiesAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
	
	XMPPStream *xmppStream;

    UIWindow *window;
	IBOutlet UITabBarController  *accountController; //TabBarController
	
	//test
	IBOutlet InvitationsViewController *invitationsViewController;
	IBOutlet InvitationNavController *invitationNavController;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isOpen;
	
	IBOutlet ResponNavController *responNavController;
	IBOutlet BillsNavController  *billsNavController;
	IBOutlet EventsNavController *eventsNavController;
	IBOutlet SettingsNavController *settingsNavController;  
	IBOutlet ApplicationInfoViewController *applicationInfoViewController;
	IBOutlet AccountInfoViewController *accountInfoViewController;
	IBOutlet RoomiesViewController *roomiesViewController;
	
	IBOutlet ResponTableViewController *responTableViewController;
	IBOutlet ResponTableViewController *responEventTableViewController;
	
	IBOutlet EventsViewController *eventsViewController;
	
	IBOutlet BillsViewController *billsViewController;
	
	NSOperationQueue *queue;
	
	@private
	
	NSURLConnection *connectionFeed;
	NSMutableData *responseData;
	Parser *parser;
	
}

@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) XMPPStream *xmppStream;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *accountController;
//@property (nonatomic, retain) IBOutlet UIViewController  *acceptInvitaionController; 
//@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

@property (nonatomic, retain) IBOutlet ResponNavController *responNavController;
@property (nonatomic, retain) IBOutlet BillsNavController  *billsNavController;
@property (nonatomic, retain) IBOutlet EventsNavController *eventsNavController;
@property (nonatomic, retain) IBOutlet SettingsNavController *settingsNavController; 

@property (nonatomic, retain) IBOutlet ApplicationInfoViewController *applicationInfoViewController;
@property (nonatomic, retain) IBOutlet AccountInfoViewController *accountInfoViewController;
@property (nonatomic, retain) IBOutlet ResponTableViewController *responTableViewController;
@property (nonatomic, retain) IBOutlet ResponTableViewController *responEventTableViewController;
@property (nonatomic, retain) IBOutlet RoomiesViewController *roomiesViewController;
@property (nonatomic, retain) IBOutlet EventsViewController *eventsViewController;

@property (nonatomic, retain) IBOutlet InvitationsViewController *invitationsViewController;
@property (nonatomic, retain) IBOutlet InvitationNavController *invitationNavController;

@property (nonatomic, retain) IBOutlet BillsViewController *billsViewController;

@property (nonatomic, retain) NSURLConnection *connectionFeed;
@property (nonatomic, retain) NSMutableData *responseData; // the data returned from the NSURLConnection

//@property (nonatomic) bool state;
@property (nonatomic, retain) Parser *parser;

- (void)handleError:(NSError *)error;
- (void) displayMainApplicationTab;
- (void) displayMainSettingView;

- (void) loadAllData;
- (void) loadBillsData;
- (void) loadRoomiesData;
- (void) loadResponsibilitiesData;
- (void) loadEvents;
- (void) loadAccount;

- (void) setupBillsNotif;
- (void) setupRespsNotif;
- (void) setupNotificationOperation;
- (void) loadDataInOpQueue;
- (void) loadOpInvitationAccounts;
- (void) loadInvitation;

- (void)connecttoxmpp;

- (NSString *)remoteRequest:(NSString *)query ;
- (NSData *) setUpConnection:(NSString*) requestType;

@end

