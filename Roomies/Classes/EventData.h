//
//  EventData.h
//  Roomies
//
//  Created by Anna Zakharova on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventData : NSObject 
{
	NSNumber *event_id; 
	NSString *event_title;
	NSDate   *event_start_date;
	NSDate   *event_end_date;
	NSString *event_note;
	NSNumber *alert_on;
	NSNumber *icon_id;
	
	NSMutableArray *respList;  // list of responsibilities
}

@property (nonatomic, retain) NSNumber *event_id; 
@property (nonatomic, copy)   NSString *event_title;
@property (nonatomic, retain) NSDate   *event_start_date;
@property (nonatomic, retain) NSDate   *event_end_date;
@property (nonatomic, copy) NSString *event_note;
@property (nonatomic, retain) NSNumber *alert_on;
@property (nonatomic, copy)   NSNumber *icon_id;

@property (nonatomic, retain) NSMutableArray *respList;

@end
