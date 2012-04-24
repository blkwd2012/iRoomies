//
//  main.m
//  Roomies
//
//  Created by Antoine Boyer on 15/10/10.
//  Copyright Moi 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
	NSLog(@"in tha main");
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
