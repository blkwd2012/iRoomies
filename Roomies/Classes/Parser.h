//
//  Parser.h
//  Roomies
//
//  Created by Jinru Wu on 11/1/10.
//  Copyright 2010 Polytechnic Institute of NYU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountData.h"
#import "BillData.h"
#import "RespData.h"
#import "RoomieData.h"
#import "EventData.h"

typedef enum _XMLType
{
	Error, Accounts, Bills, Events, Resps, Roomies, Unknown
} XMLType;

typedef enum _ErrorType
{
	AccountNotFound, BillNotFound, RespNotFound, EventNotFound, UserNotFound, RoomieNotFound
} ErrorType;

@interface Parser : NSObject 
{
@private
	
	NSXMLParser *parser;
	NSData *data;
	BOOL didFinishParsing;
	NSMutableString *errorString;
	XMLType currentXMLType;
	ErrorType currentErrorType;
	
}

@property (nonatomic, copy) NSMutableString *errorString;

- (AccountData*) parseAccountInfo;
- (NSMutableArray *) parseObjectList:(XMLType) parseType;
//- (NSMutableArray *) parseRespList;
- (void) initWithNSData: (NSData* ) xmldata;
- (void) startParsing:(XMLType) parseType;
- (ErrorType) getErrorType;

@end
