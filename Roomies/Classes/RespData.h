//
//  RespData.h
//  Roomies
//
//  Created by Jinru Wu on 11/9/10.
//  Copyright 2010 Polytechnic Institute of NYU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespData : NSObject {
	
	NSNumber *resp_id;
	NSNumber *event_id; // 0 if just responsibility for no event
	NSString *resp_title;
	NSDate   *resp_start_date;
	NSDate   *resp_end_date;
    NSNumber *repeat_schedule;
	NSNumber *resp_status;
	NSString *resp_note;
	NSNumber *alert_on;
	NSNumber *icon_id;
	
	NSNumber *respon_user_id;  // owner of responsibilities
	NSString *respon_user_name;
	NSString *respon_user_phone;
}

@property (nonatomic, retain) NSNumber *resp_id;

@property (nonatomic, retain) NSNumber *event_id;
@property (nonatomic, copy)   NSString *resp_title;
@property (nonatomic, copy)   NSDate   *resp_start_date;
@property (nonatomic, copy)   NSDate   *resp_end_date;
@property (nonatomic, retain) NSNumber *resp_status;
@property (nonatomic, copy)   NSString *resp_note;
@property (nonatomic, retain) NSNumber *alert_on;
@property (nonatomic, retain) NSNumber *repeat_schedule;
@property (nonatomic, copy)   NSNumber *icon_id;

@property (nonatomic, retain) NSNumber *respon_user_id;  // owner of responsibilities
@property (nonatomic, copy) NSString *respon_user_name;
@property (nonatomic, copy) NSString *respon_user_phone;


@end
