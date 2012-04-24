    //
//  AddressBookViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddressBookViewController.h"
#import "InviteViewController.h"

@implementation AddressBookViewController

@synthesize picker;
@synthesize inviteViewController;

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
- (void)loadView 
 {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
		
	picker = [[ABPeoplePickerNavigationController alloc] init];
	picker.peoplePickerDelegate = self;
	picker.navigationBarHidden = YES;
	picker.title = @"Contacts";
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
							   
							       [NSNumber numberWithInt:kABPersonEmailProperty],
							   
								nil];
	NSLog(@">>>>>>>>>>>>>>>ADDRESS parentViewController111 %p", inviteViewController);
	/*NSMutableString *fullName = [[NSMutableString alloc] initWithString:@"firstName"];
	[fullName appendString:@" "];
	[fullName appendString:(@"%@", @"petya")];
	NSLog(@"full name: %@", fullName);*/
	
	
	picker.displayedProperties = displayedItems;
	self.view = picker.view;
	
}

- (BOOL) personViewController:(ABPersonViewController*)personView shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	NSString *firstName = [[NSString alloc] init];
	firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	if(firstName == nil)
		firstName = @"";
	NSString *lastName = [[NSString alloc] init];
	lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	if(lastName == nil)
		lastName = @"";
	
	
	NSMutableString *fullName = [[NSMutableString alloc] initWithFormat:@"%@ %@",firstName,lastName];
	/*if(firstName != @"");
		[fullName appendString:@" "];
	[fullName appendString:(@" %@", lastName)];*/
	
	NSLog(@"full name: %@", fullName);
	
	ABMultiValueRef multi_name = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSLog(@"MULTI %d ", ABMultiValueGetCount(multi_name));	
	NSLog(@"phone num: %@", (NSString *) ABMultiValueCopyValueAtIndex(multi_name, 0));
	
	ABMultiValueRef multi_email = ABRecordCopyValue(person, kABPersonEmailProperty);
	NSLog(@"MULTI %d ", ABMultiValueGetCount(multi_email));	
	NSString *emailTemp;
	if(ABMultiValueGetCount(multi_email) != 0)
	{
		emailTemp = (NSString *) ABMultiValueCopyValueAtIndex(multi_email, 0);
	}
	else
	{
		emailTemp = [[NSString alloc] initWithString:@""];
	}
	NSLog(@"email: %@", emailTemp);
	
	NSLog(@">>>>>>>>>>>>>>ADDRESS parentViewController222 %p", inviteViewController);
	[inviteViewController setChoice:fullName: (NSString *) ABMultiValueCopyValueAtIndex(multi_name, 0): emailTemp];
		
	[firstName release];
	[lastName release];
	//[fullName release];
	
	//int count = ABMultiValueGetCount(multiValue);
	//int j;
	//for(j = 0; j < count; j++) 
	//{
	//	emailField.text = (NSString *)ABMultiValueCopyValueAtIndex(multiValue, j);
	//}
	
	// remove the controller
    //[self dismissModalViewControllerAnimated:YES];
	
    return NO;
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
	
	[picker release];
	[inviteViewController release];
    [super dealloc];
}


@end
