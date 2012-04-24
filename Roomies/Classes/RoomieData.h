//
//  RoomieData.h
//  Roomies
//
//  Created by Jinru Wu on 11/13/10.
//  Copyright 2010 Polytechnic Institute of NYU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoomieData : NSObject 
{
	NSNumber *user_id;
	NSString *user_name;
	NSString *user_phone_num;
	NSNumber *user_status;
}

@property (nonatomic, retain) NSNumber *user_id;
@property (nonatomic, copy)   NSString *user_name;
@property (nonatomic, copy)   NSString *user_phone_num;
@property (nonatomic, retain) NSNumber *user_status;

@end
