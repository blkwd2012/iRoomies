    //
//  EventNavController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"
#import "EventsViewController.h"
#import "User.h"


@implementation EventViewController

@synthesize respButton;
@synthesize deleteButton;
//@synthesize responTableViewController;
@synthesize imageViewArray;

@synthesize event_title;
@synthesize event_start_date;
@synthesize event_end_date;
@synthesize event_alert;
@synthesize event_notes;
@synthesize datePicker;
@synthesize icon_fd;
@synthesize iconPicker;
@synthesize iconsData;
@synthesize icon_img;
@synthesize icon_btn;

@synthesize isViewOnly;
@synthesize eventData;

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
	
	NSLog(@"viewDidLoad ");
	
    [super viewDidLoad];
	selectedIcon = 0;
	icon_fd.enabled = FALSE;
	
	[self.event_alert setAlternateColors:YES];
	((UILabel *)[[[[[[event_alert subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:0]).text = @"YES";
	((UILabel *)[[[[[[event_alert subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:1]).text = @"NO";
	
	self.iconsData= [[NSMutableArray alloc] initWithObjects: @"house.png", @"Cake.png", 
					 @"Martini.png", @"PartyHat.png", @"Pineapple.png", @"Umbrella.png",@"BBQ.png", nil];
	[self populateImagesArray];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] init];
	saveButton.title = @"Save";
	saveButton.target = self;
	saveButton.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = saveButton;
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
	self.navigationItem.rightBarButtonItem.action = @selector(saveClicked:);
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
	[saveButton release];
	
}

- (void) populateImagesArray
{
	NSLog(@"populateImagesArray imageViewArray iconsArray");
	self.imageViewArray = [[NSMutableArray alloc] init];	
	
	for (int i = 0; i < [iconsData count]; i++)
	{
		UIImage *tmp = [UIImage imageNamed:[iconsData objectAtIndex:i] ];		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:tmp];
		
		[imageViewArray addObject:imageView];
		NSString *fieldName = [[NSString alloc] initWithFormat:@"column%d", i];
		// CRASH [self setValue:imageViewArray forKey:fieldName];
		[fieldName release];
		[imageView release];
		//[imageViewArray release];
		[tmp release];
	}	
}

-(void) populate_event_info
{
	NSLog(@"populate_event_info %p", eventData);
	
	if(isViewOnly == TRUE)
	{
		NSLog(@"VIEW EVENT ");
		event_title.enabled = FALSE;		
		respButton.hidden = FALSE;
		deleteButton.hidden = FALSE;
	}
	else
	{
		NSLog(@"ADD EVENT ");
		event_title.enabled = TRUE;
		respButton.hidden = TRUE;
		deleteButton.hidden = TRUE;
	}
	
	if(eventData != nil)
	{
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
		
		NSLog(@" title %@", eventData.event_title);
		event_title.text = eventData.event_title;
		
		NSString *dateString = [df stringFromDate:eventData.event_end_date];
		
		NSLog(@" end date %@ ", dateString);
		
		selectedIcon = [eventData.icon_id intValue];
		
		NSInteger xx = [eventData.icon_id intValue];
		UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:xx]]; 
		icon_img.image = img;
		//[img release];
		NSLog(@" ICON SET ");
		
		
		event_end_date.text= dateString;
		//[dateString release];
		
		if([eventData.alert_on intValue] == 0)
			event_alert.on = FALSE;
		else
			event_alert.on = TRUE;
		
		event_notes.text = eventData.event_note;
	}
	else 
	{
		event_title.text =@"";
		event_notes.text =@"";
		event_alert.on = FALSE;
		
		//prepopulate due date as today's date
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
		event_end_date.text = [NSString stringWithFormat:@"%@",
							  [df stringFromDate:[NSDate date]]];	
		
	}
	
}

- (IBAction) buttonClicked:(id)sender
{
	NSLog(@"EVENT buttonClicked ");
	
	if(sender == deleteButton)
	{
		NSLog(@"deleteButton ");
		[self deleteEvent];
	}
	if(sender == respButton)
	{
		NSLog(@"respButton ");
		[self viewEventResponsibilities];
	}
}

- (void) deleteEvent
{
	NSLog(@"EVENT deleteEvent ");
	
	if(isViewOnly == TRUE)
	{
		NSString *idStr = [NSString stringWithFormat:@"%d", [eventData.event_id intValue]];
		
		NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&event_id="];
		[query appendString:(@"%@",idStr)];
		[query appendString:@"&request_type=event_delete"];
		
		@try
		{
			RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
			NSString *response  = [del remoteRequest:query] ;
			NSLog(@" DELETE RESPONSE FROM SERVER %@  isViewOnly %d", response, isViewOnly);
			
			[del.eventsViewController deleteItem:eventData];
			eventData = nil;
			[del.eventsNavController popViewControllerAnimated:YES];
		}
		@catch (NSException * e) 
		{
			NSLog(@"delete event exception caught");
			NSLog(@"exception: %@", [e reason]);
		}
	}
} 

- (IBAction) saveClicked:(id)sender
{
	NSLog(@"EVENT saveClicked ");
	NSInteger eventAlertInt = 0;

	if (event_alert.on) eventAlertInt = 1;  
	else eventAlertInt = 0;
	
	[event_title resignFirstResponder];
	[event_notes resignFirstResponder];
	[event_end_date resignFirstResponder];

	NSLog(@" event_title %@", event_title.text);
	NSLog(@" event_end_date %@ ", event_end_date.text);
	NSLog(@" event_alert  %d ", eventAlertInt);
	NSLog(@" event_notes  %@ ", event_notes.text);
	
	if(event_title.text.length == 0 ||
	   event_end_date.text.length == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Error Adding Event "
							  message: @"Please enter all required fields !"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	NSDate *dueDate = [[NSDate alloc] init];
	NSLog(@"date from field %@", event_end_date.text);
	dueDate = [dateFormatter dateFromString:event_end_date.text];
	NSString *dateString = [dateFormatter stringFromDate:dueDate];
	NSLog(@" DUE date from string %@", dateString);
	
	NSDate *todayDate = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *todayString = [dateFormatter stringFromDate:todayDate];
	
	NSLog(@"TODAY is date: %@", todayString);
	
	[event_title resignFirstResponder];
	[event_notes resignFirstResponder];
	
	NSString *eventAlertStr = [NSString stringWithFormat:@"%d", eventAlertInt];
	NSMutableString * query = nil;
	NSLog(@"Save button clicked isViewOnly %d ", isViewOnly);
	
	NSString *iconStr = [NSString stringWithFormat:@"%d ", selectedIcon];
	
	if(isViewOnly == FALSE)
	{
		eventData = [[EventData alloc] init];
		NSLog(@"ADDING EVENT %p", eventData);
		
		eventData.event_title = event_title.text;
		eventData.event_start_date = todayDate;
		eventData.event_end_date = dueDate;
		eventData.alert_on = [NSNumber numberWithInt:eventAlertInt];
		eventData.event_note = event_notes.text;
		eventData.icon_id = [NSNumber numberWithInt:selectedIcon];
		
		query = [[NSMutableString alloc ]initWithFormat:@"event_title="] ;
		[query appendString:(@"%@", eventData.event_title)];
		[query appendString:@"&event_end_date="];
		[query appendString:(@"%@", dateString)];
		[query appendString:@"&event_note="];
		[query appendString:(@"%@", eventData.event_note)];
		[query appendString:@"&event_start_date="];
		[query appendString:(@"%@", todayString)];
		[query appendString:@"&event_alert_on="];
		[query appendString:(@"%@", eventAlertStr)];
		[query appendString:@"&icon_id="];
		[query appendString:(@"%@", iconStr)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=event_creation"];
	}
	else
	{
		NSLog(@"UPDATE EVENT %p", eventData);
		NSLog(@"UPDATE EVENT id %d ", [eventData.event_id intValue]);
		
		eventData.event_title = event_title.text;
		eventData.event_end_date = dueDate;
		eventData.alert_on = [NSNumber numberWithInt:eventAlertInt];
		eventData.event_note = event_notes.text;
		eventData.icon_id = [NSNumber numberWithInt:selectedIcon];
		
		NSDate *t = eventData.event_start_date;
		NSString *startStr = [dateFormatter stringFromDate:t];
		
		query = [[NSMutableString alloc ]initWithFormat:@"event_title="] ;
		[query appendString:(@"%@", eventData.event_title)];
		[query appendString:@"&event_end_date="];
		[query appendString:(@"%@", dateString)];
		
		[query appendString:@"&event_note="];
		if(eventData.event_note != nil)
			[query appendString:(@"%@", eventData.event_note)];
		else 
			[query appendString:(@"%@", @"")];
		[query appendString:@"&event_start_date="];
		[query appendString:(@"%@", startStr)];
		[query appendString:@"&event_alert_on="];
		[query appendString:(@"%@", eventAlertStr)];
		[query appendString:@"&event_id="];
		[query appendString :(@"%@", [eventData.event_id stringValue])];
		[query appendString:@"&icon_id="];
		[query appendString:(@"%@", iconStr)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=event_update"];
	}
	
	@try
	{
		RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
		NSString *response  = [del remoteRequest:query] ;
		
		if(isViewOnly == FALSE)
		{
			[eventData setEvent_id:[NSNumber numberWithInt:[response integerValue]]];
			
			NSLog(@" EVENT id created %d", [eventData.event_id intValue]);
			deleteButton.hidden = FALSE;
			respButton.hidden = FALSE;

			[del.eventsViewController addItem:eventData];
		}
		else
		{
			[del.eventsViewController updateItem:eventData];
		}
				
		isViewOnly = TRUE;
		event_title.enabled = FALSE;
		NSLog(@" RESPONSE FROM SERVER <%@> ", response);
	}
	@catch (NSException * e) 
	{
		NSLog(@"adding/updating event exception caught");
		NSLog(@"exception: %@", [e reason]);
	}
	NSLog(@"save EVENT %p", eventData);					 	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	NSLog(@"textFieldShouldReturn");
	[textField resignFirstResponder];
	return NO;
}

- (void) viewEventResponsibilities
{
	RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
	NSLog(@"EVENT viewResponsibility del.responTableViewController %p ", 
		  
		  del.responEventTableViewController);
	
	if(del.responEventTableViewController == nil)
	{
		ResponTableViewController *details = [[ResponTableViewController alloc] initWithNibName:@"ResponsibilitiesView" bundle:nil];
		del.responEventTableViewController = details;
		[details release];
	}
	NSLog(@"EVENT setting isEvent to 1 AND EVENTID %d ++++++++", [eventData.event_id intValue]);
	del.responEventTableViewController.isEvent = [NSNumber numberWithInteger:1];
	del.responEventTableViewController.event_id = eventData.event_id;
	del.responEventTableViewController.title = [NSString stringWithFormat:@"%@", eventData.event_title];
	
	//[responTableViewController loadResponsibilities];
	 
	//RoomiesAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del.eventsNavController pushViewController:del.responEventTableViewController animated:YES];
	
	[del.responEventTableViewController loadResponsibilities];
}

- (IBAction) iconClicked:(id)sender
{
	if(sender == icon_btn)
	{
		NSLog(@"didBeginDateEdit iconPicker");
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
	    
		//[icon_fd resignFirstResponder];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Event Icon", @"")]
									  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
		// IMPORTANT for CXL button
		[actionSheet showInView:self.parentViewController.tabBarController.view];
		self.iconPicker = [[[UIPickerView alloc] init] autorelease];
		self.iconPicker.showsSelectionIndicator = YES;
		[actionSheet addSubview:self.iconPicker];
		self.iconPicker.delegate = self;
		[actionSheet release];
	}
}

- (IBAction) didBeginDateEdit:(id)sender
{
	NSLog(@"didBeginDateEdit");
	
	if(sender == event_end_date)
	{
		NSLog(@"didBeginDateEdit sender event_end_date");
		
		[event_end_date resignFirstResponder];
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Event's Date", @"")]
									  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
		// IMPORTANT for CXL button
		[actionSheet showInView:self.parentViewController.tabBarController.view];
		
		self.datePicker = [[[UIDatePicker alloc] init] autorelease];
		//self.datePicker.datePickerMode = UIDatePickerModeD
		[actionSheet addSubview:self.datePicker];
		[actionSheet release];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	NSLog(@"clickedButtonAtIndex %d datePicker %p ", buttonIndex, datePicker);
	
	if (buttonIndex == 0 && self.datePicker != nil) 
	{		
		NSDateFormatter * df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
		event_end_date.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
		self.datePicker = nil;
	}
	if(buttonIndex == 0 && self.iconPicker != nil)
	{
		NSLog(@" get data from picker %@ NEED TO SET ICON", [iconsData objectAtIndex:selectedIcon]);
		UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:selectedIcon]]; 
		icon_img.image = img;
		//[img release];
		self.iconPicker = nil;
	}

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
	NSLog(@"numberOfRowsInComponent iconsData %d ", 
		  [iconsData count]);

	if(iconPicker != nil)
	{
		return [iconsData count];
	}
	return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSLog(@"forComponent ++++ iconPicker %p ", iconPicker);
	if(iconPicker != nil)
	{
		return [imageViewArray objectAtIndex:row];  
	}
	return nil;
}

- (void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent: (NSInteger)component
{
    NSLog(@"Selected %d ", row);// The label is simply setup to show where the picker selector is at
	if(iconPicker != nil)
		selectedIcon = row;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	
	[respButton release];
	[deleteButton release];
	[eventData release];
	//[responTableViewController release];
	[icon_fd release];
	[icon_img release];
	[icon_btn release];
	[iconPicker release];
	
	[event_title release];
	[event_start_date release];
	[event_end_date release];
	[event_alert release];
	[event_notes release];
	[datePicker release];
	[iconsData release];
	[imageViewArray release];
	
    [super dealloc];
}
@end
