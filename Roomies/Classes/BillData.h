//
//  BillData.h
//  Roomies
//
//  Created by Anna Zakharova on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BillData : NSObject 
{	
	NSNumber *bill_id;
	NSNumber *icon_id;
	NSString *bill_title;
	NSString *bill_amount;
	NSDate   *bill_start_date;
	NSDate   *bill_end_date;
	NSNumber *bill_status;
	NSString *bill_note;
	NSNumber *repeat_schedule;
	
}

@property (nonatomic, retain) NSNumber *bill_id;
@property (nonatomic, copy)   NSString *bill_title;
@property (nonatomic, copy)   NSString *bill_amount;
@property (nonatomic, retain) NSDate   *bill_start_date;
@property (nonatomic, retain) NSDate   *bill_end_date;
@property (nonatomic, retain) NSNumber *bill_status;
@property (nonatomic, copy)   NSString *bill_note;
@property (nonatomic, copy)   NSNumber *icon_id;
@property (nonatomic, retain) NSNumber *repeat_schedule;


@end
