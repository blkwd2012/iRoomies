    //
//  ApplicationInfoViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationInfoViewController.h"


@implementation ApplicationInfoViewController

@synthesize textView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"papyrus.png"]];
	
	//[self addSubview:iRoomies.view];
	
	CGRect frame = textView.frame;
	frame.size.height = textView.contentSize.height;
	textView.frame = frame;
	//cell.font=[UIFont fontWithName:@"Georgia" size:20.0];
	
	UIImageView *imgView = [[UIImageView alloc]initWithFrame: textView.frame];
	textView.font=[UIFont fontWithName:@"Georgia" size:17.0];
    imgView.image = [UIImage imageNamed: @"papyr.png"];
    [textView addSubview: imgView];
    [textView sendSubviewToBack: imgView];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[textView release];
    [super dealloc];
}


@end
