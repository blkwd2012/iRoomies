//
//  User.h
//  
//
//  Created by Anna Zakharova on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*typedef connection_status
{
	FAILED = -1,
	CONNECTED = 0
} CONNT_STATUS;*/

#import <Foundation/Foundation.h>
#import "AccountData.h"
//@class AccountData;

typedef enum connection_status
 {
     FAILED = -1,
	 CONNECTED = 0
	 
 } CONNT_STATUS;


@interface User : NSObject 
{	
	NSString *UDID;
	NSInteger connect_status; /* -1(failed), 0(connected) */
	NSString *phone_number;
	AccountData *accountData;
	
	NSMutableArray *billsList;   // contain list of bills
	NSMutableArray *responsList; //contain list of responsibilities
	
	NSMutableArray *eventsList;       //list of events
	NSMutableArray *eventsResponList; //list of responsibilities for events
	
	//Code added by Antoine nov 21
	NSMutableArray *accountInvitations ; //List of invitations sent to the user
	//======
	NSInteger offline_mode; // to run application offline
	
	//NSMutableArray *billsIcons;
}

@property (nonatomic, copy) NSString *UDID;
@property (nonatomic, assign) NSInteger connect_status;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, retain) AccountData *accountData;

//@property (nonatomic, retain) NSMutableArray *billsIcons;
@property (nonatomic, retain) NSMutableArray *billsList;
@property (nonatomic, retain) NSMutableArray *responsList;
@property (nonatomic, retain) NSMutableArray *eventsList; 
@property (nonatomic, retain) NSMutableArray *eventsResponList;
//Code added by antoine nov 21
@property (nonatomic, retain) NSMutableArray *accountInvitations ;
//===
@property (nonatomic, assign) NSInteger offline_mode;

//@property (nonatomic, retain) NSString *UDID;
//@property (nonatomic, assign) NSInteger connect_status;
//@property (nonatomic) NSInteger connect_status;



+ (User*) instance;
//- (void) clear; 
//- (void) initialize;


@end
