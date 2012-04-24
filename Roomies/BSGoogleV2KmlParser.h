//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSKmlResult.h"

@interface BSGoogleV2KmlParser : NSObject <NSXMLParserDelegate>
{
	NSMutableString *contentsOfCurrentProperty;
	int statusCode;
	NSString *name;
	NSMutableArray *placemarkArray;
	BSKmlResult *currentPlacemark;
	
}

@property (nonatomic, readonly) int statusCode;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly) NSMutableArray *placemarks;

- (BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;

@end
