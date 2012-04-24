//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BSAddressComponent.h"


@implementation BSAddressComponent
@synthesize shortName, longName, types;


-(void)dealloc
{
	[shortName release];
	[longName release];
	[types release];
	[super dealloc];
}
@end
