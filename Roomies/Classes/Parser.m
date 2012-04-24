//
//  Parser.m
//  Roomies
//
//  Created by Jinru Wu on 11/1/10.
//  Copyright 2010 Polytechnic Institute of NYU. All rights reserved.
//

#import "Parser.h"

@interface Parser() <NSXMLParserDelegate>
@property (nonatomic, retain) AccountData *currentAccountObject;
@property (nonatomic, retain) BillData *currentBillObject;
@property (nonatomic, retain) RespData *currentRespObject;
@property (nonatomic, retain) RoomieData *currentRoomieObject;
@property (nonatomic, retain) EventData *currentEventObject;
@property (nonatomic, retain) NSMutableArray *objectsArray;
//we can add other objects here to parse
@property (nonatomic, retain) NSMutableString *currentElementValue;
@property (nonatomic, retain) NSString *currentElement;

@end

@implementation Parser

@synthesize errorString, currentAccountObject, currentElementValue, currentElement, currentBillObject, currentRespObject, objectsArray, currentRoomieObject, currentEventObject;


//@synthesize errorString, currentAccountObject, currentElementValue, currentElementcur,rentBillObject, currentRespObject, objectsArray, currentRoomieObject, currentEventObject;


- (void) initWithNSData:(NSData *)xmldata
{
	data = [xmldata copy];
	NSString *stringdata=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"data received from server: string data %@ ", stringdata);
	parser = [[NSXMLParser alloc] initWithData:data];
	[data release];
	[stringdata release];
	didFinishParsing = FALSE;
	currentXMLType = Unknown;
}

- (void) startParsing:(XMLType) parseType
{
	[parser setDelegate:self];
	[parser parse];
	if (currentXMLType == Error) {
		if (currentErrorType == AccountNotFound) 
		{
			[NSException raise:NSObjectInaccessibleException format:@"%@", errorString];
		}		
	}
	else if(currentXMLType == Unknown){
		[NSException raise:NSObjectNotAvailableException format:@"Invalid XML File"];
	}
	else if(currentXMLType == parseType)
		NSLog(@"right xml type");
	[parser release];	
}

-(AccountData*) parseAccountInfo
{
	[self startParsing:Accounts];
	NSLog(@"parseAccoutinfo called");
	return currentAccountObject;
}

- (NSMutableArray *) parseObjectList :(XMLType) parseType
{
	[self startParsing:parseType];
	return objectsArray;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
    NSLog(@"Document started", nil);
    currentElement = nil;
	objectsArray = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
    [currentElement release];
    currentElement = [elementName copy];
	//set current XML file type
	if([elementName isEqualToString:@"accounts"]) 
	{
		//currentAccountObject = [[AccountData alloc] init];
		currentXMLType = Accounts;
	} 
	else if ([elementName isEqualToString:@"account"])
	{
		currentAccountObject = [[AccountData alloc]init];
	}
	else if ([elementName isEqualToString:@"error"]) 
	{
		currentXMLType = Error;
	} 
	else if ([elementName isEqualToString:@"bills"]) 
	{
		NSLog(@"***** found tag billS");
		currentXMLType = Bills;
	} 
	else if ([elementName isEqualToString:@"bill"]) 
	{
		NSLog(@"***** found tag bill");
		currentBillObject = [[BillData alloc] init];
	} 
	else if ([elementName isEqualToString:@"responsibilities"]) 
	{
		NSLog(@"***** found tag responsibilities");
		currentXMLType = Resps;
	} 
	else if ([elementName isEqualToString:@"responsibility"]) 
	{
		NSLog(@"***** found tag responsibility");
		currentRespObject = [[RespData alloc] init];
	} 
	else if ([elementName isEqualToString:@"roomies"]) 
	{
		NSLog(@"found tag roomies");
		currentXMLType = Roomies;
	} 
	else if ([elementName isEqualToString:@"roomie"]) 
	{
		NSLog(@"found tag roomie");
		currentRoomieObject = [[RoomieData alloc]init];
	}
	else if ([elementName isEqualToString:@"events"]) 
	{
		NSLog(@"found tag events");
		currentXMLType = Events;
	}
	else if ([elementName isEqualToString:@"event"]) 
	{
		NSLog(@"found tag event");
		currentEventObject = [[EventData alloc]init];
	}
	//NSLog(@"didstartelement called, current XML Type: %d", currentXMLType);
	//other objects can be initialized here
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"account"]) 
	{
		[objectsArray addObject:currentAccountObject];
		[currentAccountObject release];
		//can be used if there are more than one account to be returned
	}
	else if ([elementName isEqualToString:@"bill"]) 
	{
		[objectsArray addObject:currentBillObject];
		[currentBillObject release];
	}
	else if ([elementName isEqualToString:@"responsibility"]) 
	{
		[objectsArray addObject:currentRespObject];
		[currentRespObject release];
	}
	else if ([elementName isEqualToString:@"roomie"]) 
	{
		[objectsArray addObject:currentRoomieObject];
		[currentRoomieObject release];
	}
	else if ([elementName isEqualToString:@"event"]) 
	{
		[objectsArray addObject:currentEventObject];
		[currentEventObject release];
	}
}        

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	switch (currentXMLType) 
	{	
			//tags for a regular accounts info xml
		case Accounts:
			if ([currentElement isEqualToString:@"account_name"])
			{
				[currentAccountObject setAccount_name:string];
			} 
			else if ([currentElement isEqualToString:@"account_address1"]) 
			{
				[currentAccountObject setAddress1:string];
			} 
			else if ([currentElement isEqualToString:@"account_address2"])
			{
				[currentAccountObject setAddress2:string];
			} 
			else if ([currentElement isEqualToString:@"user_name"]) 
			{
				[currentAccountObject setCreator_name:string];
			}
			else if([currentElement isEqualToString:@"user_phone_num"])
			{
				[currentAccountObject setPhone_number:string];
			}
			else if([currentElement isEqualToString:@"account_id"])
			{
				[currentAccountObject setAccount_id:[string intValue]];
			}
			break;
			
		case Bills:
			if ([currentElement isEqualToString:@"bill_id"])
			{
				NSNumber *billid = [NSNumber numberWithInt:[string integerValue]];
				[currentBillObject setBill_id:billid];
				NSLog(@"%d", [billid intValue]);
			}
			else if([currentElement isEqualToString:@"bill_title"])
			{
				[currentBillObject setBill_title:string];
			}
			else if([currentElement isEqualToString:@"bill_start_date"])
			{
				[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				//[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
				[dateFormatter setDateFormat:@"YYYY-MM-dd"];
				[currentBillObject setBill_start_date:[dateFormatter dateFromString:string]];
				[dateFormatter release];
			}
			else if([currentElement isEqualToString:@"bill_end_date"])
			{
				
				[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"YYYY-MM-dd"];
				[currentBillObject setBill_end_date:[dateFormatter dateFromString:string]];
				[dateFormatter release];
			}
			else if([currentElement isEqualToString:@"repeat_schedule"])
			{
				[currentBillObject setRepeat_schedule:[NSNumber numberWithInt:[string integerValue]]];
			}
			else if([currentElement isEqualToString:@"bill_amount"])
			{
				[currentBillObject setBill_amount:string];
			}
			else if([currentElement isEqualToString:@"bill_status"])
			{
				[currentBillObject setBill_status:[NSNumber numberWithInt:[string integerValue]]];
			}
			else if([currentElement isEqualToString:@"bill_note"])
			{
				if(string != nil)
					[currentBillObject setBill_note:string];
				else
					[currentBillObject setBill_note:@""];
			}
			else if([currentElement isEqualToString:@"icon_id"])
			{
				[currentBillObject setIcon_id:[NSNumber numberWithInt:[string integerValue]]];
			}
			break;
			//if there is an error tag then we need to handle exception	 
		case Error:
		{
			NSLog(@"in case error, and current string: %@", string);
			if ([string isEqualToString:@"no rows found in bills"]) {
				currentErrorType = BillNotFound;
			}
			else if ([string isEqualToString:@"no rows found in accounts"]){
				currentErrorType = AccountNotFound;
			}
			else if ([string isEqualToString:@"no rows found in responsibilities"]){
				currentErrorType = RespNotFound;
			}
			else if ([string isEqualToString:@"no rows found in events"]){
				currentErrorType = EventNotFound;
			}				
			errorString = [[NSString alloc]initWithString:string];
			NSLog(@"current error type set to: %d", currentErrorType);
			break;
		}
		case Resps:
		{
			//NSLog(@"innnnnn respons parser ");
			if ([currentElement isEqualToString:@"resp_id"])
			{
				[currentRespObject setResp_id:[NSNumber numberWithInt:[string intValue]]];
			}
			else if([currentElement isEqualToString:@"user_id"])
			{
				[currentRespObject setRespon_user_id:[NSNumber numberWithInt:[string intValue]]];
			}
			else if([currentElement isEqualToString:@"event_id"])
			{
				[currentRespObject setEvent_id:[NSNumber numberWithInt:[string intValue]]];
			}
			else if([currentElement isEqualToString:@"resp_title"])
			{
				[currentRespObject setResp_title:string];
			}
			else if([currentElement isEqualToString:@"resp_start_date"])
			{
				[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"YYYY-MM-dd"];
				[currentRespObject setResp_start_date:[dateFormatter dateFromString:string]];
				[dateFormatter release];
			}
			else if([currentElement isEqualToString:@"resp_end_date"])
			{
				[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"YYYY-MM-dd"];
				[currentRespObject setResp_end_date:[dateFormatter dateFromString:string]];
				//Jinru's change Nov24
				[dateFormatter release];
			}
			else if([currentElement isEqualToString:@"resp_repeat_schedule"])
			{
				[currentRespObject setRepeat_schedule:[NSNumber numberWithInt:[string intValue]]];
			}
			else if([currentElement isEqualToString:@"resp_status"])
			{
				[currentRespObject setResp_status:[NSNumber numberWithInt:[string integerValue]]];
			}
			else if([currentElement isEqualToString:@"resp_note"])
			{
				if(string != nil)
					[currentRespObject setResp_note:string];
				else 
					[currentRespObject setResp_note:@""];
				
			}
			else if ([currentElement isEqualToString:@"alert_on"])
			{
				[currentRespObject setAlert_on:[NSNumber numberWithInt:[string intValue]]];
			}	
			else if([currentElement isEqualToString:@"icon_id"])
			{
				[currentRespObject setIcon_id:[NSNumber numberWithInt:[string integerValue]]];
			}
			break;
		}
		case Roomies:
			if ([currentElement isEqualToString:@"user_id"]){
				[currentRoomieObject setUser_id:[NSNumber numberWithInt:[string intValue]]];
			}
			else if([currentElement isEqualToString:@"user_name"])
			{
				[currentRoomieObject setUser_name:string];
			}
			else if([currentElement isEqualToString:@"user_phone_num"])
			{
				[currentRoomieObject setUser_phone_num:string];
			}
			else if([currentElement isEqualToString:@"user_account_status"])
			{
				[currentRoomieObject setUser_status:[NSNumber numberWithInt:[string intValue]]];
			}
			break;
			
		case Events:
		{
			if ([currentElement isEqualToString:@"event_id"])
			{
				[currentEventObject setEvent_id:[NSNumber numberWithInt:[string intValue]]];
			}
			else if([currentElement isEqualToString:@"event_title"])
			{
				[currentEventObject setEvent_title:string];
			}
			else if([currentElement isEqualToString:@"event_start_date"])
			{
				[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
				[currentEventObject setEvent_start_date:[dateFormatter dateFromString:string]];
				//Jinru's change Nov24
				[dateFormatter release];
			}
			else if([currentElement isEqualToString:@"event_end_date"])
			{
				[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
				[currentEventObject setEvent_end_date:[dateFormatter dateFromString:string]];
				[dateFormatter release];
			}
			else if([currentElement isEqualToString:@"event_note"])
			{
				if(string != nil)
					[currentEventObject setEvent_note:string];
				else 
					[currentEventObject setEvent_note:@""];
				
			}
			else if ([currentElement isEqualToString:@"alert_on"])
			{
				[currentEventObject setAlert_on:[NSNumber numberWithInt:[string intValue]]];
			}	
			else if([currentElement isEqualToString:@"icon_id"])
			{
				[currentEventObject setIcon_id:[NSNumber numberWithInt:[string integerValue]]];
			}
			break;
		}
		default:
			break;
	}
	
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	didFinishParsing = TRUE;
	NSLog(@"Finished parsing document array count: %@",[NSNumber numberWithInt:[objectsArray count]]);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
    //If we throw an exception here the entire app will terminate. Dont know why. So I'm considering whether to handle error here.
}

- (ErrorType)getErrorType
{
	NSLog(@"get errortype called : current XML type: %d", currentXMLType);
	if (currentXMLType == Unknown) 
	{
		currentErrorType = AccountNotFound;
	}
	NSLog(@"current error type :%d", currentErrorType);
	return currentErrorType;
}

@end
