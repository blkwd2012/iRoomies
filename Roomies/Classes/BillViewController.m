    //
//  BillViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BillViewController.h"
#import "BillsViewController.h"
#import "User.h"
#import "BillData.h"
#import "RoomiesAppDelegate.h"


@implementation BillViewController

@synthesize datePicker;
@synthesize repeatPicker;
//@synthesize selectedRepeat;
@synthesize icon_img;
@synthesize icon_btn;

@synthesize isViewOnly;
@synthesize amountLbl;

@synthesize bill_title;
@synthesize bill_due_date;
@synthesize repeat_schedule;
@synthesize bill_amount;
@synthesize bill_status;
@synthesize bill_notes;
@synthesize deleteButton;
@synthesize repeatData;
@synthesize iconsData;
@synthesize icon_fd;

//@synthesize iconsArray;
@synthesize iconPicker;
@synthesize imageViewArray;

@synthesize billData;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	NSLog(@" BILL viewDidLoad ");
	//User *user = [User instance];
    [super viewDidLoad];
	selectedRepeat = 0;
	selectedIcon = 0;
	icon_fd.enabled = FALSE;
	
	//[(UILabel *)[[[[[[bill_status subviews] lastObject] subviews]
				   //objectAtIndex:2] subviews] objectAtIndex:0] setText:@"Hi"]; 
	//[(UILabel *)[[[[[[bill_status subviews] lastObject] subviews]
					//objectAtIndex:2] subviews] objectAtIndex:1] setText:@"Hello"];
	
	NSLog(@" BILL viewDidLoad after 1 ");
	self.iconsData= [[NSMutableArray alloc] initWithObjects: @"house.png", @"TV.png", @"Internet.png", @"Phone.png", @"Light.png", @"dollar.png", nil];
	[self populateImagesArray];
	
	NSLog(@" BILL viewDidLoad 2 ");
	
	self.repeatData = 
	[[NSMutableArray alloc] initWithObjects: @"None", @"Every Day", @"Every Week", @"Every Month", nil];
	
	NSLog(@" BILL viewDidLoad 3 ");
	[self.bill_status setAlternateColors:YES];
	((UILabel *)[[[[[[bill_status subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:0]).text = @"YES";
	((UILabel *)[[[[[[bill_status subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:1]).text = @"NO";
	
	NSLog(@" BILL viewDidLoad 4 ");
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
		NSLog(@" created image for %@  ", [iconsData objectAtIndex:i] );
		
		[imageViewArray addObject:imageView];
		NSString *fieldName = [[NSString alloc] initWithFormat:@"column%d", i];
		// CRASH [self setValue:imageViewArray forKey:fieldName];
		[fieldName release];
		[imageView release];
		//[imageViewArray release];
		[tmp release];
	}
}

-(void) populate_bill_info
{
	NSLog(@"populate_bill_info %p", billData);
	
	if(isViewOnly == TRUE)
	{
		NSLog(@"VIEW BILL ");
		bill_title.enabled = FALSE;		
		amountLbl.hidden = FALSE;
		deleteButton.hidden = FALSE;
	}
	else
	{
		NSLog(@"ADD BILL ");
		bill_title.enabled = TRUE;
		amountLbl.hidden = TRUE;
		deleteButton.hidden = TRUE;
	}
	
	if(billData != nil)
	{
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"YYYY-MM-dd"];
		
		NSLog(@" title %@", billData.bill_title);
		bill_title.text = billData.bill_title;

		NSString *dateString = [df stringFromDate:billData.bill_end_date];
		
		NSLog(@" end date %@ ", dateString);
		
		bill_due_date.text= dateString;
		//[dateString release];
		
		selectedIcon = [billData.icon_id intValue];
		NSLog(@" ICON %d IMAGE %p ", [billData.icon_id intValue], icon_img.image);
		//if(icon_img.image != nil)
			//[icon_img.image release];
		
		NSInteger xx = [billData.icon_id intValue];
		UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:xx]]; 
		icon_img.image = img;
		//[img release];
		NSLog(@" ICON SET ");
		
		NSInteger repeatInt = [billData.repeat_schedule intValue];
		repeat_schedule.text = [repeatData objectAtIndex:repeatInt];
		bill_amount.text = billData.bill_amount;
		
		if([billData.bill_status intValue] == 0)
		  bill_status.on = FALSE;
		else
		  bill_status.on = TRUE;
		
		bill_notes.text = billData.bill_note;
		NSInteger numRoomies = [User instance].accountData.active_roomies_number;
		float amnt = [billData.bill_amount floatValue] / numRoomies ;
		NSString *temp = [[NSString alloc] initWithFormat:@"Amount per person: $%.2f", amnt];
		amountLbl.text = temp;
		[temp release];
	}
	else 
	{
		bill_title.text =@"";
		bill_notes.text =@"";
		repeat_schedule.text=@"None";
		bill_amount.text = @"";
		bill_status.on = FALSE;
		
		//pre-populate due date as today's date
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"YYYY-MM-dd"];
		bill_due_date.text = [NSString stringWithFormat:@"%@",
							  [df stringFromDate:[NSDate date]]];	
		
		
	}

}

- (IBAction) deleteClicked:(id)sender
{
	NSLog(@"deleteClicked %p", billData);
	
	if(isViewOnly == TRUE)
	{
		NSString *idStr = [NSString stringWithFormat:@"%d", [billData.bill_id intValue]];
		
		NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&bill_id="];
		[query appendString:(@"%@",idStr)];
		[query appendString:@"&request_type=bill_delete"];
		
		@try
		{
			RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
			NSString *response  = [del remoteRequest:query] ;
			NSLog(@" DELETE RESPONSE FROM SERVER %@  isViewOnly %d", response, isViewOnly);
			
			// delete it from the list:
			[del.billsViewController deleteItem:billData];
			billData = nil;
			///////////////
			/*[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:1.0];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:del.billsNavController cache:YES];*/
			[del.billsNavController popViewControllerAnimated:YES];
			//[del.billsNavController altAnimatePopViewControllerAnimated:YES];
			
			//[UIView commitAnimations];
		}
		@catch (NSException * e) 
		{
			NSLog(@"delete bill exception caught");
			//display the reason why server cannot send back correct XML file
			NSLog(@"exception: %@", [e reason]);
		}
		//[query release];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	NSLog(@"textFieldShouldReturn");
	[textField resignFirstResponder];
	return NO;
}

- (IBAction) saveClicked:(id)sender
{
	NSLog(@"Save button clicked %p", billData);
	NSInteger bill_stat = 0;
	
	if (bill_status.on) bill_stat=1;  
	else bill_stat=0;
	
	[bill_title resignFirstResponder];
	[bill_amount resignFirstResponder];
	[bill_notes resignFirstResponder];
	
	NSLog(@" bill_title %@", bill_title.text);
	NSLog(@" bill_end_date %@ ", bill_due_date.text);
	NSLog(@" bill_amout  %@ ", bill_amount.text);
	NSLog(@" bill_status  %d ", bill_stat);
	NSLog(@" bill_notes  %@ ", bill_notes.text);
	
	//NSString *string = bill_due_date.text;
	//NSArray *chunks = [string componentsSeparatedByString: @"-"];
	
	//NSLog(@" %@ %@ %@ ", [chunks objectAtIndex: 0], 
		 // [chunks objectAtIndex: 1], 
		 // [chunks objectAtIndex: 2]);
	
	if(bill_title.text.length == 0 ||
	   bill_due_date.text.length == 0 ||
	   bill_amount.text.length == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Error Adding Bill "
							  message: @"Please enter all required fields !"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	
	/* due date */
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
	
	NSDate *dueDate = [[NSDate alloc] init];
	dueDate = [dateFormatter dateFromString:bill_due_date.text];
	NSString *dateString = [dateFormatter stringFromDate:dueDate];
	NSLog(@" date from string %@", dateString);
	
	/* start date */
	//NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormat setDateFormat:@"YYYY-MM-dd"];
	NSDate *todayDate = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *todayString = [dateFormatter stringFromDate:todayDate];

	NSLog(@"today is date: %@", todayString);
	
	NSString *billStatStr = [NSString stringWithFormat:@"%d", bill_stat];
	NSString *repeatStr = [NSString stringWithFormat:@"%d", selectedRepeat];
	NSMutableString * query = nil;
	NSLog(@"Save button clicked isViewOnly %d ", isViewOnly);
	
	NSString *iconStr = [NSString stringWithFormat:@"%d ", selectedIcon];

	// ADD bill
	if(isViewOnly == FALSE)
	{
		billData = [[BillData alloc] init];
		NSLog(@"ADDING BILL %p", billData);
		
		billData.bill_title = bill_title.text;
		billData.bill_amount = bill_amount.text;
		billData.bill_start_date = todayDate;
		billData.bill_end_date = dueDate;
		billData.bill_status = [NSNumber numberWithInt:bill_stat];
		billData.bill_note = bill_notes.text;
		billData.repeat_schedule = [NSNumber numberWithInt:selectedRepeat];
		billData.icon_id = [NSNumber numberWithInt:selectedIcon];
		
		// Creation of the query string containing all the variables including UDID
		query = [[NSMutableString alloc ]initWithFormat:@"bill_title="] ;
		[query appendString:(@"%@", billData.bill_title)];
		[query appendString:@"&bill_amount="];
		[query appendString:(@"%@", billData.bill_amount)];
		[query appendString:@"&bill_end_date="];
		[query appendString:(@"%@", dateString)];
		[query appendString:@"&bill_status="];
		[query appendString:(@"%@", billStatStr)];
		[query appendString:@"&bill_note="];
		[query appendString:(@"%@", billData.bill_note)];
		[query appendString:@"&bill_start_date="];
		[query appendString:(@"%@", todayString)];
		[query appendString:@"&bill_repeat_schedule="];
		[query appendString:(@"%@", repeatStr)];
		[query appendString:@"&icon_id="];
		[query appendString:(@"%@", iconStr)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=bill_creation"];
	}
	else
	{
		NSLog(@"UPDATE BILL %p", billData);
		NSLog(@"UPDATE BILL id %d ", [billData.bill_id intValue]);
											
		//if(billData.bill_title) [billData.bill_title release];
		billData.bill_title = bill_title.text;
		billData.bill_amount = bill_amount.text;
		billData.bill_end_date = dueDate;
	
		billData.bill_status = [NSNumber numberWithInt:bill_stat];
		billData.bill_note = bill_notes.text;
		billData.repeat_schedule = [NSNumber numberWithInt:selectedRepeat];
		billData.icon_id = [NSNumber numberWithInt:selectedIcon];
		NSDate *t = billData.bill_start_date;
						
		NSString *startStr = [dateFormatter stringFromDate:t];

		// Creation of the query string containing all the variables including UDID
		query = [[NSMutableString alloc ]initWithFormat:@"bill_title="] ;
		
		[query appendString:(@"%@", billData.bill_title )];
		[query appendString:@"&bill_amount="];
		[query appendString:(@"%@", billData.bill_amount )];
		[query appendString:@"&bill_id="];
		[query appendString :(@"%@", [billData.bill_id stringValue])];
		[query appendString:@"&bill_start_date="];
		[query appendString:(@"%@", startStr)];
		[query appendString:@"&bill_end_date="];
		[query appendString:(@"%@", dateString)];
		[query appendString:@"&bill_status="];
		[query appendString:(@"%@", billStatStr)];
		[query appendString:@"&bill_note="];
		if(billData.bill_note == nil)
			[query appendString:(@"%@", @"")];
		else
			[query appendString:(@"%@", billData.bill_note)];
		[query appendString:@"&bill_repeat_schedule="];
		[query appendString:(@"%@", repeatStr)];
		[query appendString:@"&icon_id="];
		[query appendString:(@"%@", iconStr)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		
		[query appendString:@"&request_type=bill_update"];
	}
	
	@try
	{
		RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
		NSString *response  = [del remoteRequest:query] ;
		
		if(isViewOnly == FALSE) // add
		{
			[billData setBill_id:[NSNumber numberWithInt:[response integerValue]]];
			
			NSLog(@" bill id created %d", [billData.bill_id intValue]);
			amountLbl.hidden = FALSE;
			deleteButton.hidden = FALSE;
			// add to the list:
			BillsViewController *tmp = del.billsViewController;
			[tmp addItem:billData];
			
			
		}
		else // update
		{	
			// update the list:
			[del.billsViewController updateItem:billData];
			
		}
						
		NSInteger numRoomies = [User instance].accountData.active_roomies_number;
		float amnt = [billData.bill_amount floatValue] / numRoomies ;
		NSString *temp = [[NSString alloc] initWithFormat:@"Amount per person: $%.2f", amnt];
		amountLbl.text = temp;
		[temp release];
		
		isViewOnly = TRUE;
		bill_title.enabled = FALSE;
		NSLog(@" RESPONSE FROM SERVER <%@> ", response);
	}
	@catch (NSException * e) 
	{
		NSLog(@"adding/updating bill exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
	}
	[query release];
	NSLog(@"save BILL %p", billData);					 
	//self.navigationItem.rightBarButtonItem.enabled = FALSE;
	NSLog(@"bill id: %@",billData.bill_id);
	[self setupAlarm:dueDate forRepeat:billData.repeat_schedule forId:billData.bill_id];
	NSLog(@"after alarm in saveClicked");
}
						 
- (IBAction) didEndEdit:(id) sender
{
	NSLog(@"didEndEdit");
	if(sender == bill_title)
	{
		NSLog(@"title");
		//bill_title. = self.view;
		[bill_title resignFirstResponder];
	}
	if(sender == bill_amount)
		[bill_amount resignFirstResponder];
	if(sender == bill_notes)
		[bill_notes resignFirstResponder];
}

- (IBAction) iconClicked:(id) sender
{
	NSLog(@"iconClicked");
	
	if(sender == icon_btn)
	{
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
	    
		//[icon_fd resignFirstResponder];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Bill Icon", @"")]
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
	
	if(sender == bill_due_date)
	{
		[bill_due_date resignFirstResponder];
				
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Bill's Due Date", @"")]
									  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
		// IMPORTANT for CXL button
		[actionSheet showInView:self.parentViewController.tabBarController.view];
		
		self.datePicker = [[[UIDatePicker alloc] init] autorelease];
		self.datePicker.datePickerMode = UIDatePickerModeDate;
		[actionSheet addSubview:self.datePicker];
		[actionSheet release];
	}
	if(sender == repeat_schedule)
	{
		NSLog(@"didBeginDateEdit repeat_schedule repeatPicker");
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
	    
		[repeat_schedule resignFirstResponder];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Reminder Frequency", @"")]
									  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
		// IMPORTANT for CXL button
		[actionSheet showInView:self.parentViewController.tabBarController.view];
		
		//UITableView *table = [[[UITableView alloc] init] autorelease];
		//[actionSheet addSubview:table];

		
		self.repeatPicker = [[[UIPickerView alloc] init] autorelease];
		self.repeatPicker.showsSelectionIndicator = YES;
		[actionSheet addSubview:self.repeatPicker];
		self.repeatPicker.delegate = self;
		[actionSheet release];
		
	}
}

- (void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent: (NSInteger)component
{
    NSLog(@"Selected %d ", row);// The label is simply setup to show where the picker selector is at
    if(repeatPicker != nil)
		selectedRepeat = row;
	if(iconPicker != nil)
		selectedIcon = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSLog(@"forComponent ++++ repeatPicker %p iconPicker %p ", repeatPicker, iconPicker);
	if(iconPicker != nil)
	{
		//UIView* row0view = [[UIView alloc] initWithFrame...];
		//[row0view addSubview: iconsArray objectAtIndex:row];
		return [imageViewArray objectAtIndex:row];  
		//return [row0view autorelease];
	}
	if(repeatPicker != nil)
	{
		/* UIView *viewForRow = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 280)] autorelease]; 
		UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myimage.png"]];  
		img.frame = CGRectMake(0, 0, 102,280); 
		img.opaque = YES; 
		[viewForRow addSubview:img]; 
		[img release]; UILabel *label;  
		UIFont *font = [ UIFont fontWithName:@"Helvetica"  size:20];  
		label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 270, 100)] autorelease];  
		label.text = @"I am a label"; 
		label.textAlignment = UITextAlignmentCenter; 
		label.textColor = [UIColor blackColor]; 
		label.font = font; 
		label.backgroundColor = [UIColor clearColor]; 
		label.opaque = NO;     
		[viewForRow addSubview:label];  
		CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57);       
		[viewForRow setTransform:rotate];  return viewForRow; */
		
		UILabel *pickerLabel = (UILabel *)view;		
		if (pickerLabel == nil) 
		{
			CGRect frame = CGRectMake(0.0, 0.0, 150, 32);
			pickerLabel = [[UILabel alloc] initWithFrame:frame];
			[pickerLabel setTextAlignment:UITextAlignmentCenter];
			[pickerLabel setBackgroundColor:[UIColor clearColor]];
			[pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
		}
		
		[pickerLabel setText:[repeatData objectAtIndex:row]];
		
		return pickerLabel;
		
		
		//return [repeatData objectAtIndex:row];
	}
	return nil;
} 

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent: (NSInteger)component;
{
	NSLog(@"+++ titleForRow repeatPicker %p iconPicker %p ", repeatPicker, iconPicker);
	if(repeatPicker != nil)
	{
		return [repeatData objectAtIndex:row];
	}
	if(iconPicker != nil)
	{
		return [iconsData objectAtIndex:row];
		//return [imageViewArray objectAtIndex:row];
	}
	return nil;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
	NSLog(@"numberOfRowsInComponent repeatPicker %d iconsData %d ", 
		  [repeatData count],
		  [iconsData count]);
	
	if(repeatPicker != nil)
	{
		return [repeatData count];
	}
	if(iconPicker != nil)
	{
		return [iconsData count];
	}
	return 0;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	NSLog(@"clickedButtonAtIndex %d datePicker %p repeatPicker %p", buttonIndex, datePicker, repeatPicker);
	
	if (buttonIndex == 0 && self.datePicker != nil) 
	{
		//NSDate *dueDate = datePicker.date; //[datePicker.date copy];
		
		NSDateFormatter * df = [[NSDateFormatter alloc] init];
        //[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        //[df setDateStyle:NSDateFormatterMediumStyle];
		[df setDateFormat:@"YYYY-MM-dd"];
		bill_due_date.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
		self.datePicker = nil;
	} 
	if(buttonIndex == 0 && self.repeatPicker != nil)
	{
		NSLog(@" get data from picker %@", [repeatData objectAtIndex:selectedRepeat]);
		
		repeat_schedule.text = [repeatData objectAtIndex:selectedRepeat];
		self.repeatPicker = nil;
	}
	if(buttonIndex == 0 && self.iconPicker != nil)
	{
		NSLog(@" get data from picker %@ NEED TO SET ICON", [iconsData objectAtIndex:selectedIcon]);
		
		UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:selectedIcon]]; 
		icon_img.image = img;
		[img release];
		self.iconPicker = nil; 
		
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES forsupported orientations
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


- (void) setupAlarm:(NSDate *) alarmDate forRepeat:(NSNumber *)repeatSchedule forId:(NSNumber *) billId
{
	BOOL exist = FALSE;
	NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	NSLog(@"BILL notif array before update: %d", [notificationArray count]);
	NSLog(@"setup alarm called, we get the bill id: %@", billId);
	for (UILocalNotification *localNotif in notificationArray) 
	{
		NSLog(@"in for loop");
		NSLog(@"%@ ", localNotif.alertBody);
		//NSDictionary *billDict = [localNotif userInfo];
		
		//use userinfo dict to search bill id
		NSNumber *currentId = [localNotif.userInfo objectForKey:@"bill id"];
		if ([currentId isEqualToNumber:billId]) 
		{
			NSLog(@"BILL we found the right notif: %@", currentId);
			//and cancel the notif before reschedule it
			[[UIApplication sharedApplication] cancelLocalNotification:localNotif];
			NSLog(@"cancelled");
			exist = TRUE;
		}
	}
	
	NSDate *currentDate = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *datestr = [formatter stringFromDate:alarmDate];
	NSLog(@"end date: %@", datestr);
	//compare the current date with 24 hrs before due date
	NSDate *temp = [currentDate earlierDate:[alarmDate addTimeInterval:(-1.0*24*60*60)]];
	//true means current date is earlier and we should schedule the notification
	if ([temp isEqualToDate:currentDate]) {
		NSLog(@"current date is earlier");
		UILocalNotification *localNotif = [[UILocalNotification alloc] init];
		if (localNotif == nil)
		{
			NSLog(@"cannot alloc local notif");
			return;
		}
		//for demonstration purpose
		localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
		
		//SET THE REMINDER 24 HOURS BEFORE DUE DATE
		//localNotif.fireDate = [alarmDate addTimeInterval:(-1.0*24*60*60)];
		datestr = [formatter stringFromDate:[localNotif fireDate]];
		localNotif.alertBody = billData.bill_title;
		NSLog(@"fire date set in local notif: %@", datestr);
		localNotif.timeZone = [NSTimeZone defaultTimeZone];
		localNotif.alertAction = @"View";			
		localNotif.soundName = UILocalNotificationDefaultSoundName;
		//increase the badge number by 1
		localNotif.applicationIconBadgeNumber = 1;
		//set up repeat interval
		switch ([repeatSchedule intValue]) {
			case 1:
				localNotif.repeatInterval = kCFCalendarUnitDay;
				localNotif.repeatCalendar = [NSCalendar currentCalendar];
				break;
			case 2:
				localNotif.repeatInterval = kCFCalendarUnitWeek;
				localNotif.repeatCalendar = [NSCalendar currentCalendar];
				break;
			case 3:
				localNotif.repeatInterval = kCFCalendarUnitMonth;
				localNotif.repeatCalendar = [NSCalendar currentCalendar];
				break;
			default:
				break;
		}
		NSLog(@"repeat interval: %d", localNotif.repeatInterval);
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
		NSLog(@"alert body: %@", localNotif.alertBody);
		[localNotif release];
	}
	
	notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
	NSLog(@"BILL notif array after update: %d", [notificationArray count]);
}

- (void)dealloc 
{
	
	[bill_title release];
	[bill_due_date release];
	[repeat_schedule release];
	[bill_amount release];
	[bill_status release];
	[bill_notes release];	
	[billData release];
	[amountLbl release];
	[deleteButton release];
	[datePicker release];
	[repeatPicker release];	
	[repeatData release];

	[icon_img release];
	[icon_fd release];
	[icon_btn release];
	[iconPicker release];
	[imageViewArray release];
	
    [super dealloc];
}


@end
