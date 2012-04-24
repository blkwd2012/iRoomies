//
//  User.m
//  Roomies
//
//  Created by Anna Zakharova on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "User.h"


@implementation User
static User *_instance = nil; 

+ (User*) instance
{
	// skip everything
	if(_instance) 
	{
		return _instance; 
	}
	
	// Singleton
	@synchronized([User class]) 	
	{
		if(!_instance)
		{

			_instance = [[self alloc] init];
			
			//billsIcons = [[NSMutableArray alloc] initWithObjects: @"house.png", @"TV.png", @"Internet.png", @"Phone.png", @"Light.png", @"dollar.png", nil];

		}
		
		return _instance;
	}
	
	return nil;	
}

 - (void)dealloc 
{
	NSLog(@"USER dealloc all data");
	
	
    [UDID release];
	[phone_number release];
	[accountData release];
	[billsList release];
	[responsList release];
	[eventsList release];
	[eventsResponList release];
	//Code added by antoine nov 21
	[accountInvitations release] ;
	
	//[billsIcons release];
    [super dealloc];
} 

@synthesize UDID, connect_status, phone_number, accountData, billsList, responsList, offline_mode; 
@synthesize eventsList, eventsResponList;
//Code added by antoine nov 21
@synthesize accountInvitations;
//=====
@end
