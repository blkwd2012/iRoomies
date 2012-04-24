    //
//  InviteViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InviteViewController.h"
#import "RoomiesAppDelegate.h"
#import  "User.h"

@implementation InviteViewController

@synthesize userInput;
@synthesize sendButton;
@synthesize addButton;
@synthesize contactsController;
@synthesize phoneNum;
@synthesize emailAddress;

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
	
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"buddies_invite.png"]];
	phoneNum = [[NSMutableString alloc] init];
	emailAddress = [[NSMutableString alloc] init];
	phoneNum = [@"" mutableCopy];
	emailAddress = [@"" mutableCopy];
}


- (IBAction)addButtonClicked:(id)sender
{
	NSLog(@"Add buttonClicked");
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	//contactsController.parentViewController = self;
	NSLog(@"parentViewController %p ", self);
	[del.settingsNavController pushViewController:contactsController animated:YES];
}


- (IBAction)sendInviteButtonClicked:(id)sender
{
	//NSLog(@"Send Invite buttonClicked phoneNum %p", phoneNum);
	
	if(userInput.text.length == 0 || phoneNum.length == 0)
	{
		NSLog(@"sendInviteButtonClicked : no user selected");
		return;
	}
	
	NSMutableString * query = nil;

	query = [[NSMutableString alloc ]initWithFormat:@"UDID="] ;
	[query appendString:(@"%@", [User instance].UDID)];
	[query appendString:@"&user_name="];
	[query appendString:(@"%@", userInput.text)];
	[query appendString:@"&user_phone_num="];
	NSLog(@"Send Invite buttonClicked phoneNum2 %p", phoneNum);
	[query appendString:(@"%@",phoneNum)];
	[query appendString:@"&email="];
	[query appendString:(@"%@",emailAddress)];
	[query appendString:@"&request_type=account_invitation"];
	
	RoomiesAppDelegate *del = (RoomiesAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *response  = [del remoteRequest:query] ;
	NSLog(@"respose from invite send %@", response);
	[del loadRoomiesData];
}

-(void)setChoice:(NSString *)name:(NSString *)num:(NSString *)email
{
	NSLog(@" BEFORE %@ ", phoneNum);
	if(num == nil)
		return;
	
	//if(phoneNum) [phoneNum release];
	
	userInput.text = name;
	if(num)		
		phoneNum = [num mutableCopy];
 //[[NSString alloc] initWithString:num];
	else
		phoneNum = [@"" mutableCopy];
 //[[NSString alloc] initWithString:@""];
	
	
	//if(emailAddress) [emailAddress release];
	if(email)
		emailAddress = [email mutableCopy];
	else {
		emailAddress = [@"" mutableCopy];
	}

	//if([name isEqualToString:@"Anna Zakharova"])
		//phoneNum = [[NSString alloc] initWithString:@"3472773248"];
	//else {
		//if ([name isEqualToString:@"Antoine Boyer"]) {
		//	phoneNum = [[NSString alloc] initWithString:@"3474810292"];
		//}
	//}

		
	
	//NSString *escapedPath = [pathToBeConverted stringByReplacingOccurrencesOfString:@" " withString:@"\ "];
	 NSLog(@" Beforre replace %@ ", phoneNum);
	
	[phoneNum replaceOccurrencesOfString:@"(" withString:@""  
								 options:NSLiteralSearch 
								range:NSMakeRange (0, [phoneNum length])];
	[phoneNum replaceOccurrencesOfString:@")" withString:@""  
								 options:NSLiteralSearch 
								   range:NSMakeRange (0, [phoneNum length])];
	[phoneNum replaceOccurrencesOfString:@" " withString:@""  
								 options:NSLiteralSearch 
								   range:NSMakeRange (0, [phoneNum length])];
	[phoneNum replaceOccurrencesOfString:@"-" withString:@""  
								 options:NSLiteralSearch 
								   range:NSMakeRange (0, [phoneNum length])];
	[phoneNum replaceOccurrencesOfString:@"+" withString:@""  
								 options:NSLiteralSearch 
								   range:NSMakeRange (0, [phoneNum length])];

    NSLog(@" AFTER %@ ", phoneNum);
	
	//NSString *finalString = @""
	//NSString *firstString = @"";
	//firstString = phoneNum;
	//finalString = [[[firstString stringByReplacingOccurancesOfString:@"(" withString:@""] 
				   //stringByReplacingOccurancesOfString:@")" withString:@""]
				   //stringByReplacingOccurancesOfString:@" " withString:@""];
				
				   //phoneNum = finalString;
	//NSLog(@" AFTER %@ ", phoneNum);
	
	NSLog(@"Send Invite buttonClicked phoneNum %@", phoneNum);
	NSLog(@"name %@, num %@, email <%@>", name, phoneNum, emailAddress);
	NSLog(@" POINTERRR AFTER %p ", phoneNum);
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


- (void)dealloc {
	NSLog(@"DEALLOC IS CALLED");
    [super dealloc];
	[userInput release];
	[sendButton release];
	[addButton release];
	
	[emailAddress release];
	[phoneNum release];
	
	[contactsController release];
}


@end
