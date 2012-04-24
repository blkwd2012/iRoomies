//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "CustomPlacemark.h"


@implementation CustomPlacemark
@synthesize title, message, coordinate, coordinateRegion;

-(id)initWithRegion:(MKCoordinateRegion) coordRegion {
	self = [super init];
	
	if (self != nil) {
		coordinate = coordRegion.center;
		coordinateRegion = coordRegion;
	}
	
	return self;
}

- (void)dealloc {
	if(title != nil){
		[title release];
	}
	if(message != nil){
		[message release];
	}
	
	
	[super dealloc];
}
@end
