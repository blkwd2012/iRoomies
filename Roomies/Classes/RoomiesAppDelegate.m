//
//  RoomiesAppDelegate.m
//  Roomies
//
//  Created by Antoine Boyer on 15/10/10.
//  Copyright : 2010. All rights reserved.
//
#import "XMPPJID.h"
#import "XMPPStream.h"
#import "RoomiesAppDelegate.h"
#import "ResponNavController.h"
#import "BillsNavController.h"
#import "EventsNavController.h"
#import "SettingsNavController.h"
#import "ApplicationInfoViewController.h"
#import "ResponTableViewController.h"
#import "RoomiesViewController.h"
#import "BillsViewController.h"

#import "InvitationsViewController.h"
#import "InvitationNavController.h"

#import "User.h"
#import "Parser.h"

@implementation RoomiesAppDelegate

@synthesize window;
@synthesize accountController;// tab bar controller

@synthesize invitationsViewController; //invitation controller
@synthesize invitationNavController; // invitation navigation controller

@synthesize responNavController;
@synthesize billsNavController;
@synthesize eventsNavController;
@synthesize settingsNavController;
@synthesize applicationInfoViewController;
@synthesize eventsViewController;

@synthesize accountInfoViewController;
@synthesize roomiesViewController;
@synthesize responTableViewController;
@synthesize responEventTableViewController;
@synthesize connectionFeed;
@synthesize responseData;
@synthesize queue, xmppStream;
@synthesize password;


//@synthesize state; ANNA what is it for ????
@synthesize parser;

@synthesize billsViewController;

#pragma mark -
#pragma mark Application lifecycle

- (void)handleError:(NSError *)error 
{	
    NSString *errorMessage = [error localizedDescription];
	NSLog(@"APP handleError %@", errorMessage);
	
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"User Error Message",
                       @"Title for alert displayed when download or parse error occurs.")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
    
    // Override point for customization after app launch    
	//ANNA [window addSubview:accountController.view];
    //ANNA [window makeKeyAndVisible];
	
	NSLog(@"APP applicationDidFinishLaunching is called");
	
	// get user UDID
	NSString *ident = [[UIDevice currentDevice] uniqueIdentifier];
	NSLog(@"UDID %@", ident); 
	
	User *user = [User instance];
	user.UDID = ident;
	user.connect_status = FAILED;
	[ident release];
	
	responTableViewController.isEvent = [NSNumber numberWithInt:0] ;
	
	NSLog(@"****** UDID set to  %@ status %d", user.UDID, user.connect_status);
	
	
	NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"http://128.238.66.30/map01"];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	self.connectionFeed = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    
    NSAssert(self.connectionFeed != nil, @"Failure to create URL connection.");
    
    // Start the status bar network activity indicator. We'll turn it off when the connection
    // finishes or experiences an error.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	user.connect_status = CONNECTED;
	[urlString release];
	NSLog(@"APP applicationDidFinishLaunching is done connection %d", user.connect_status);
	
	// connect to gtalk:
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
 {
	 responseData = [[NSMutableData alloc] init];
 
	 NSLog(@"APP didReceiveResponse status %d", [User instance].connect_status);
	 NSLog(@"APP didReceiveResponse udid %@", [User instance].UDID);
	 
	 //User *user = [User instance];
	 [User instance].connect_status = CONNECTED;
	 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	 self.responseData = [NSMutableData data];
	  
	 NSLog(@"UDID set to  %@ status %d", 
			[User instance].UDID, 
			[User instance].connect_status);
 } 

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
 {
	 [responseData appendData:data];
	 NSLog(@"APP didReceiveData is done connection %d", [User instance].connect_status);
	 
 } 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	NSLog(@"APP didFailWithError: code=%d domain=%@ userInfo=%@ ", error.code, error.domain, error.userInfo );
	[User instance].connect_status = FAILED;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    if (error.code == kCFURLErrorNotConnectedToInternet)
		/*error.code == -1004)*/ 
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:
         NSLocalizedString(@"No Connection Error",
                           @"Error message displayed when not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                         code:kCFURLErrorNotConnectedToInternet
                                                     userInfo:userInfo];
        [self handleError:noConnectionError];
    } 
	else 
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.connectionFeed = nil;
	self.responseData = nil;
	
	NSLog(@"applicationDidBecomeActive is called %d", [User instance].connect_status);
	NSLog(@"applicationDidBecomeActive is called <%@>", [User instance].UDID);
 } 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
 {
	 NSLog(@"APP Succeeded! Received %d bytes of data",[responseData length]);
	 self.connectionFeed = nil;   // release our connection
	 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	 
	 [User instance].connect_status = FAILED;
	 self.responseData = nil;
 } 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
 {    
    
	 UILocalNotification *localNotif = [launchOptions
										objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	 //true means user received the local notif to launch the app
	 if (localNotif) 
	 {
		 application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
		 NSLog(@"DELEGATE running b/c localNotif %@",localNotif.alertBody);
		 [self displayMainSettingView];
		 //[window addSubview:invitationNavController.view];
		 //[window makeKeyAndVisible];
	 }
	 else 
	 {
		 NSLog(@"DELEGATE didnt get any notif when launching");
		 //application.applicationIconBadgeNumber = 0;
	 }

    // Override point for customization after application launch.
	 NSLog(@"didFinishLaunchingWithOptions LOADING APPLICATION !!!! ");
	 
	 [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert];
	 
	 NSString *num = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
	 if(num == nil)
	 {
		 NSLog(@"didFinishLaunchingWithOptions phone number was nil ");
		 num = @"7062063165";
	 }
	 
	 //op queue
	 queue = [[NSOperationQueue alloc] init];
	 
	 NSLog(@"here is my phone number %@ ", num);
	 
	 NSString *ident = [[UIDevice currentDevice] uniqueIdentifier];
	 NSLog(@"UDID %@", ident);
	 
	 User *user = [User instance];
	 user.UDID = ident;
	 user.connect_status = FAILED;
	 user.phone_number = num;
	 /* FOR TESTING ANNA */
	 user.offline_mode = 0;
	 //It doesnt like it .. application doesnt launch [ident release]; 
	 
	 responTableViewController.isEvent = [NSNumber numberWithInt:0] ;
	 
	 NSLog(@"GETTING SERVERRRRRR ****** UDID set to  %@ status %d", user.UDID, user.connect_status);
	 
	 NSMutableString *request_acct = [[NSMutableString alloc ]initWithFormat:@"request_type=request_account_info"];
	 [request_acct appendString:@"&UDID="];
	 [request_acct appendString:(@"%@",user.UDID)];
	 NSData *postData = [request_acct dataUsingEncoding:NSUTF8StringEncoding];
	 
	 NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"http://128.238.66.30/~map01/authenticate.php"];
	 NSURL *url = [NSURL URLWithString:urlString];
	 
	 // NSURLRequestReloadIgnoringCacheData
	 NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
	 
	 self.connectionFeed = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	 
	 NSLog(@"GETTING SERVERRRRRR BEFORE ASSERTION ");
	 NSAssert(self.connectionFeed != nil, @"Failure to create URL connection.");
	 
	 NSLog(@"GETTING SERVERRRRRR AFTER ASSERTION urlRequest %p ", urlRequest);
	 
	 [urlRequest setHTTPMethod:@"POST"];
	 [urlRequest setHTTPBody:postData];
	 NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];

	 NSLog(@"GETTING data %p", data);
	 parser = [Parser alloc];
	 [parser initWithNSData:data];
	 
	 @try 
	 {
		//Code Modified by Antoine nov 21
		 NSMutableArray *accountsArray = [parser parseObjectList:Accounts];		
		 AccountData * currentAccount = [accountsArray objectAtIndex:0];
		 
		//======
		 NSLog(@" ***** Got account if any .... %p UDID %@ ", currentAccount, user.UDID);
		 user.accountData = [[AccountData alloc] init];
		 user.accountData = currentAccount;
		 // CRASH [currentAccount release];
		 
		 NSLog(@"Account name %@ ", user.accountData.account_name);
		 NSLog(@"Account address1 %@ ", user.accountData.address1);
		 NSLog(@"Account address2 %@ ", user.accountData.address2);
		 NSLog(@"Account creator %@ ", user.accountData.creator_name);
		 NSLog(@"Account creator phone number %@ ", user.accountData.phone_number);
		 NSLog(@"Acccount ID %d ", user.accountData.account_id);
		 
		[accountsArray release];
		 
		 // load bills for account
		 [self loadBillsData];
		 [self setupBillsNotif];
		 // rommates
		 [self loadRoomiesData];
		 
		 // loading all data in OP queue
		 [self loadDataInOpQueue];
		 
		 // load responsibilities should be done in different thread
		 //[self loadResponsibilitiesData];
		 // load events if any
		 //[self loadEvents];
		 
		 [self loadEvents];
		 
		 // display tab view
		 [self displayMainApplicationTab];
	 }
	 @catch (NSException *e) 
	 {
		 NSLog(@"exception caught");
		 //display the reason why server cannot send back correct XML file
		 NSLog(@"DELEGATE exception: %@", [e reason]);
		 
		 
		 
		 if(user.offline_mode != 1)
		 {
			 NSLog(@"DELEGATE 1");
			 //[window addSubview:invitationNavController.view];
			 [self displayMainSettingView];
		 }
		 else
		 {
			 NSLog(@"DELEGATE 2");
			 [self displayMainApplicationTab];
		 }
		 [window makeKeyAndVisible];
		 
		 NSLog(@"DELEGATE CATCH DONE");
	 }
	 
	 // Start the status bar network activity indicator. We'll turn it off when the connection
	 // finishes or experiences an error.
	 if(data != nil)
	 {
		 //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		 //user.connect_status = CONNECTED;
	 }
	 else 
	 {
		 //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		 //user.connect_status = FAILED;
	 }
	 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	 user.connect_status = CONNECTED;
	 ////[urlString release];
	 NSLog(@"APP didFinishLaunchingWithOptions is done connection %d", user.connect_status);
	 [self connecttoxmpp];
    return YES;
} 

- (void) loadOpInvitationAccounts
{
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadInvitation) object:nil];
	
	NSLog(@"Pushing loadInvitation on queue +++++");
	// push load invitations on queue
	[queue addOperation:op];
	[op release];
}

- (void) loadInvitation
{
	NSLog(@"Called loadInvitation on queue +++++");
	@try 
	{
		NSMutableString * query = nil;
		//Parser *parser = [Parser alloc];

		query = [[NSMutableString alloc ]initWithFormat:@"user_phone_num="] ;
		[query appendString:(@"%@", [User instance].phone_number)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=request_invitations"];
		
		NSString *response  = [self remoteRequest:query] ;
		NSLog(@"response from request_invitations :  %@", response) ; 
		
		[parser initWithNSData:[self setUpConnection:query]];
		[User instance].accountInvitations = [parser parseObjectList:Accounts];
		NSLog(@"******* DELEGATE invitations list count: %@", [NSNumber numberWithInt:[[User instance].accountInvitations count]]);
	}
	@catch(NSException * e) 
	{
		[User instance].accountInvitations = nil;
		NSLog(@"exception caught invitations");
		//display the reason why server cannot send back correct XML file OR There is no respons
		NSLog(@"exception: %@", [e reason]);
		
	}
}

- (void) displayMainApplicationTab
{
	//[self loadAllData];
	NSLog(@"12233");
	[window addSubview:accountController.view];
	NSLog(@"12");
	[window makeKeyAndVisible];
	NSLog(@"33");

}

- (void) displayMainSettingView
{
	[self loadOpInvitationAccounts];

	[window addSubview:invitationNavController.view];

	[window makeKeyAndVisible];

}

- (void) loadRoomiesData
{
	User *user = [User instance];
	[parser initWithNSData:[self setUpConnection:@"request_type=request_cur_roommies"]];
	
	NSMutableArray *roomiesArray = [parser parseObjectList:Roomies];
	NSLog(@"roomies list size number %d ", [roomiesArray count]);
	if([roomiesArray count] > 0)
	{
		NSInteger count = 0;
		for(RoomieData *data in roomiesArray)
		{
			NSLog(@"Roomies name %@ status %d ", data.user_name, [data.user_status intValue] );
			if([data.user_status intValue] == 1)
				count = count+1;
		}
		NSLog(@"Roomies Active number %d Account %p ", count, user.accountData);

		if(user.accountData.roomiesData == nil)
		{
			NSLog(@"Roomies 2");
			user.accountData.roomiesData = [[NSMutableArray alloc] init];
		}
		else 
		{
			NSLog(@"Roomies 3");
			[user.accountData.roomiesData release];
			user.accountData.roomiesData = nil;
		}
		// number of active roomates 
		user.accountData.active_roomies_number = count;
		NSLog(@"Roomies 1");
		user.accountData.roomiesData = roomiesArray;
	}
	else
	{
		user.accountData.active_roomies_number = 0;
		user.accountData.roomiesData = nil;
	}
	
	NSLog(@"DELEGATE active_roomies_number %d ", [User instance].accountData.active_roomies_number);
}

- (NSString *)remoteRequest:(NSString *)query 
{
	//method to execute a request 
	NSString *post = [[NSString alloc]initWithFormat:@"%@",query];
	NSLog(@"POST DATA: %@", post);
	NSData *postData=[post dataUsingEncoding:NSUTF8StringEncoding];
	NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://128.238.66.30/~map01/authenticate.php"]];
	[connectionRequest setHTTPMethod:@"POST"];
	[connectionRequest setTimeoutInterval:30.0];
	[connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy]; //NSURLRequestUseProtocolCachePolicy
	[connectionRequest setHTTPBody:postData];

	NSData *data=[NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:nil];
	NSString *stringdata=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

	return stringdata;
	
}

- (void) setupNotificationOperation
{
	NSLog(@"setupNotificationOperation+++++++++++>>>> ");
		
	// create op to call to setup bills notif
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(setupBillsNotif) object:nil];
		
	// add bills notif to queue
	[queue addOperation:op];
	[op release];
}

- (void) setupBillsNotif // FOR JINRU, use this to setup reminders
{	
	NSLog(@"setupBillsNotif");
	NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	NSLog(@"notif array count before canceling : %d", [notificationArray count]);
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	NSLog(@"NOTIF array count AFTER canceling : %d", [notificationArray count]);
	
	[[UIApplication sharedApplication]cancelAllLocalNotifications];
	for (BillData *data in [User instance].billsList) 
	{
		NSDate *endDate = [data bill_end_date];
		NSDate *currentDate = [NSDate date];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
		NSString *datestr = [formatter stringFromDate:endDate];
		NSLog(@"end date: %@", datestr);
		//compare the current date with 24 hrs before due date
		NSDate *temp = [currentDate earlierDate:[endDate addTimeInterval:(-1.0*24*60*60)]];
		
		//true means current date is earlier and we should schedule the notification
		if ([temp isEqualToDate:currentDate]) {
			NSLog(@"current date is earlier");
			UILocalNotification *currentNotif = [[UILocalNotification alloc] init];
			if (currentNotif == nil)
			{
				NSLog(@"cannot alloc local notif");
				return;
			}
			currentNotif.fireDate = [endDate addTimeInterval:(-1.0*24*60*60)];
			datestr = [formatter stringFromDate:[currentNotif fireDate]];
			currentNotif.alertBody = [data bill_title];
			NSLog(@"fire date set in local notif: %@", datestr);
			currentNotif.timeZone = [NSTimeZone defaultTimeZone];
			currentNotif.alertAction = @"View";			
			currentNotif.soundName = UILocalNotificationDefaultSoundName;
			NSDictionary *billDict = [NSDictionary dictionaryWithObject:data.bill_id forKey:@"bill id"];
			//store bill id in userinfo dict for further cancellation
			currentNotif.userInfo = billDict;
			currentNotif.applicationIconBadgeNumber = 1;
			//set repeat interval
			switch ([[data repeat_schedule] intValue]) {
				case 1:
					currentNotif.repeatInterval = kCFCalendarUnitDay;
					currentNotif.repeatCalendar = [NSCalendar currentCalendar];
					break;
				case 2:
					currentNotif.repeatInterval = kCFCalendarUnitWeek;
					currentNotif.repeatCalendar = [NSCalendar currentCalendar];
					break;
				case 3:
					currentNotif.repeatInterval = kCFCalendarUnitMonth;
					currentNotif.repeatCalendar = [NSCalendar currentCalendar];
					break;
				default:
					break;
			}
			NSLog(@"repeat interval: %d", currentNotif.repeatInterval);
			[[UIApplication sharedApplication] scheduleLocalNotification:currentNotif];
			NSLog(@"%@", [currentNotif alertBody]);
			[currentNotif release];
		}
	}
	notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	NSLog(@"---------------------------------notif array count after scheduling : %d", [notificationArray count]);
	//[UIApplication sharedApplication].applicationIconBadgeNumber = [notificationArray count];
}

- (void) setupRespsNotif
{
	
}

- (void) loadAllData
{
	NSLog(@"return from load all data ");

	User *user = [User instance];
	[self loadAccount];
	 
	if(user.accountData.roomiesData != nil)
		user.accountData.roomiesData = nil;	
	user.accountData.active_roomies_number = 0;	
	if(user.accountInvitations != nil) 
		[user.accountInvitations release];
	
	user.accountInvitations = nil;	
	user.billsList = nil;	
	user.responsList = nil;	
	user.eventsList = nil;
	user.eventsResponList = nil;
	
	[self loadBillsData];
	[self setupBillsNotif];
	[self loadRoomiesData];
	[self loadDataInOpQueue];
	[self loadEvents];
} 

- (void) loadAccount
{
	NSLog(@" *** In loadAccount ");
	User *user = [User instance];
	
	[parser initWithNSData:[self setUpConnection:@"&request_type=request_account_info"]];
		
	NSMutableArray *accountsArray = [parser parseObjectList:Accounts];
	NSLog(@"accountsArray list size number %d ", [accountsArray count]);
	if([accountsArray count] > 0)
	{
		AccountData * currentAccount = [accountsArray objectAtIndex:0];
		
		if(user.accountData) [user.accountData release];
		
		user.accountData = [[AccountData alloc] init];
		user.accountData = currentAccount;
		[currentAccount release];
		
		NSLog(@"Account name %@ ", user.accountData.account_name);
		NSLog(@"Account address1 %@ ", user.accountData.address1);
		NSLog(@"Account address2 %@ ", user.accountData.address2);
		NSLog(@"Account creator %@ ", user.accountData.creator_name);
		NSLog(@"Account creator phone number %@ ", user.accountData.phone_number);
		NSLog(@"Acccount ID %d ", user.accountData.account_id);
	}
	else
	{
		NSLog(@"request account info failed");
		
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error request account information",
						   @"Error message displayed when have issues to request account info.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										     userInfo:userInfo];
		[self handleError:error];

	}
	//[accountsArray release];
}

- (void) loadBillsData
{
	[parser initWithNSData:[self setUpConnection:@"request_type=request_bill_info"]];
	[User instance].billsList = [parser parseObjectList:Bills];
	NSLog(@"DELEGATE bills list count: %@", [NSNumber numberWithInt:[[User instance].billsList count]]);
}

- (void) loadDataInOpQueue
{
	NSLog(@"loadDataInOpQueue+++++++++++>>>> ");
	
	// create op to call to load responsibilites and events and setup reminders
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadResponsibilitiesData) object:nil];
	
	// add respon load to queue
	[queue addOperation:op];
	[op release];
	
	//op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadEvents) object:nil];
	// add events load  to queue
	//[queue addOperation:op];
	//[op release];
}

- (void) loadResponsibilitiesData
{
	NSLog(@" loadResponsibilitiesData ++++++++");
	@try 
	{
		NSLog(@"load resps called");
		[parser initWithNSData:[self setUpConnection:@"request_type=request_resp_info"]];
		NSLog(@"parser init for resps");
		[User instance].responsList = [parser parseObjectList:Resps];
		NSLog(@"******* DELEGATE resps list count: %@", [NSNumber numberWithInt:[[User instance].responsList count]]);
	}
	@catch(NSException * e) 
	{
		[User instance].responsList = nil;
		NSLog(@"exception caught respons");
		//display the reason why server cannot send back correct XML file OR There is no respons
		NSLog(@"exception: %@", [e reason]);

	}
}

- (void) loadEvents
{
	NSLog(@" loadEvents ++++++++");
	@try 
	{
		NSLog(@"load events called");
		[parser initWithNSData:[self setUpConnection:@"request_type=request_events_info"]];
		NSLog(@"parser init for events");
		[User instance].eventsList = [parser parseObjectList:Events];
		NSLog(@"DELEGATE eventsList count: %@", [NSNumber numberWithInt:[[User instance].eventsList count]]);
	}
	@catch(NSException * e) 
	{
		[User instance].eventsList = nil;
		NSLog(@"exception caught");
		//display the reason why server cannot send back correct XML file OR There is no events
		NSLog(@"exception: %@", [e reason]);
		
	}
}

//method to set up connection and specify request type, not sure if necessary
- (NSData*) setUpConnection:(NSString *)requestType
{
	User *user = [User instance];
	NSMutableString *urlString = [[NSMutableString alloc] initWithString:@"http://128.238.66.30/~map01/authenticate.php"];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	
	NSMutableString *request = [[NSMutableString alloc ]initWithString:requestType];
	
	[request appendString:@"&UDID="];
	[request appendString:(@"%@",user.UDID)];
	NSData *postData = [request dataUsingEncoding:NSUTF8StringEncoding];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:postData];
	NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	return data;
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSLog(@"applicationDidBecomeActive is called %d", [User instance].connect_status);
	NSLog(@"applicationDidBecomeActive is called %@", [User instance].UDID);
}


- (void)applicationWillTerminate:(UIApplication *)application 
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
	NSLog(@"applicationWillTerminate is called");
}

//method will be called if app is running or in background and notif fires
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif 
{
	NSLog(@"application: didReceiveLocalNotification:");
	application.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1;
}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController: (UIViewController *)viewController 
{
	
    NSLog(@"didSelectViewController %@", viewController);
    if (viewController == responNavController || 
		viewController == billsNavController ||
		viewController == eventsNavController ||
		viewController == settingsNavController)
    {
		//do something nice here …
		[UIView  beginAnimations:nil context: nil];		
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];		
		[UIView setAnimationDuration:0.75];		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:NO];				
		[UIView commitAnimations];
    };
}


- (void)connecttoxmpp
{
	xmppStream = [[XMPPStream alloc] init];

	[xmppStream addDelegate:self];
	
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	      [xmppStream setHostName:@"talk.google.com"];
	      [xmppStream setHostPort:5222];
	
	// Replace me with the proper JID and password    (@"roomie777@gmail.com/iPhoneTest")
	      [xmppStream setMyJID:[XMPPJID jidWithString:@"woodbleak@gmail.com"]];
	      password = @"xiaoyao0923";
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
	
	// Uncomment me when the proper information has been entered above.
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		NSLog(@"Error connecting: %@", error);
	}
	
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	NSLog(@"applicationDidReceiveMemoryWarning is called");
	
}


- (void)dealloc 
{
	NSLog(@"dealloc");
	//[connectionFeed cancel];
    //[connectionFeed release];

	[responseData release];
	
	[responNavController release];
	[billsNavController release];
	[eventsNavController release];
	[settingsNavController release];
	
	[applicationInfoViewController release];
	[accountInfoViewController release];
	[responTableViewController release];
	//[responEventTableViewController release];
	
	[responEventTableViewController release];
	[roomiesViewController release];
	[eventsViewController release];
	[accountController release];
    [invitationsViewController release];
	[invitationNavController release];
	
	[billsViewController release];
	[parser release];
	[queue release];
	
	[xmppStream release];
	[password release];

	[window release];
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Custom
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)goOnline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidSecure: ----------");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidConnect: ----------");
	
	isOpen = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSLog(@"---------- xmppStream:didReceiveMessage: ----------");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" 
													message:@"You just received a new invitation ! Go to invitations to see the list.."
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	[self loadInvitation];
		
	//[window addSubview:invitationNavController.view];
	//[window makeKeyAndVisible];
	
	
	
	
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"---------- xmppStream:didReceivePresence: ----------");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	NSLog(@"---------- xmppStream:didReceiveError: ----------");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	
	if (!isOpen)
	{
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}


@end
