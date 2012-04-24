//
//  AccountData.h
//  Roomies
//
//  Created by Anna Zakharova on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountData : NSObject 
{
	NSInteger account_id;
	NSString *account_name;
	NSString *address1;
	NSString *address2;
	
	NSString *creator_name;
	NSString *phone_number;
	
	NSInteger active_roomies_number;
	NSMutableArray *roomiesData;

}

@property (nonatomic, assign) NSInteger active_roomies_number;
@property (nonatomic, assign) NSInteger account_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *creator_name;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, retain) NSMutableArray *roomiesData;

@end
