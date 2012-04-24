    //
//  ResponsibilityViewController.m
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResponsibilityViewController.h"
#import "RoomiesAppDelegate.h"
#import "User.h"
#import "ResponTableViewController.h"



@implementation ResponsibilityViewController

@synthesize preselectedRow;
@synthesize selectedRow;
@synthesize event_id;

@synthesize rommiesSelection;
@synthesize isEvent;
@synthesize isViewOnly; // view or add mode
@synthesize respData;
@synthesize datePicker;
@synthesize iconPicker;
@synthesize repeatPicker;
@synthesize roomiesList;
@synthesize icon_fd;
@synthesize icon_img;
@synthesize icon_btn;
@synthesize resp_title;
@synthesize resp_end_date;
@synthesize repeat_schedule;
@synthesize resp_alert;
@synthesize resp_user;
@synthesize resp_status;
@synthesize resp_notes;

@synthesize deleteButton;
@synthesize repeatData;
@synthesize iconsData;
@synthesize tableView;

@synthesize imageViewArray;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	NSLog(@"viewDidLoad responsibility:  isEvent = %d", isEvent);
	
	self.iconsData= [[NSMutableArray alloc] initWithObjects: @"DefaultResponsibility.png", @"Shopping.png", @"Bake.png", @"CleanHouse.png", @"Cook.png", @"Food.png", nil];
	[self populateImagesArray];
	
	selectedRepeat = 0;
	selectedRow = -1;
	preselectedRow = -1;
	selectedIcon = 0;
	icon_fd.enabled = FALSE;
	
	//load active roomies
	if([[User instance].accountData.roomiesData count] > 0)
	{
		roomiesList = [[NSMutableArray alloc] init];
		for(RoomieData *data in [User instance].accountData.roomiesData)
		{
			if([data.user_status intValue] == 1)
		    {
				RoomieData *tmp = [[RoomieData alloc] init];
				tmp = data;
				[roomiesList addObject:tmp];
			}
		} 
		if([roomiesList count] == 0)
			[roomiesList release];
	}
	
	repeatData = 
	[[NSMutableArray alloc] initWithObjects: @"None", @"Every Day", @"Every Week", @"Every Month", nil];
		
	[self.resp_status setAlternateColors:NO];
	self.resp_status.on = TRUE;
	((UILabel *)[[[[[[resp_status subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:0]).text = @"YES";
	((UILabel *)[[[[[[resp_status subviews] lastObject] subviews] objectAtIndex:2] subviews] objectAtIndex:1]).text = @"NO";
	
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

-(void) populate_resp_info
{
	NSLog(@"populate_resp_info %p", respData);
	
	if(isViewOnly == TRUE)
	{
		NSLog(@"VIEW RESPONSIBILITY ");
		resp_title.enabled = FALSE;		
		deleteButton.hidden = FALSE;
	}
	else
	{
		NSLog(@"ADD RESPONSIBILITY ");
		resp_title.enabled = TRUE;
		deleteButton.hidden = TRUE;
	}
	
	if(respData != nil)
	{
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"YYYY-MM-dd"];
		
		NSLog(@" title %@", respData.resp_title);
		resp_title.text = respData.resp_title;
		
		NSString *dateString = [df stringFromDate:respData.resp_end_date];		
		NSLog(@" end date %@ ", dateString);		
		resp_end_date.text= dateString;		

		NSInteger repeatInt = [respData.repeat_schedule intValue];
		NSLog(@" repeat value = %d, size = %d", repeatInt, [repeatData count]);
		repeat_schedule.text = [repeatData objectAtIndex:repeatInt];
		
		selectedIcon = [respData.icon_id intValue];
		NSLog(@" ICON %d IMAGE %p ", [respData.icon_id intValue], icon_img.image);
		//if(icon_img.image != nil)
		//[icon_img.image release];
		
		NSInteger xx = [respData.icon_id intValue];
		UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:xx]]; 
		icon_img.image = img;
		//[img release];
		NSLog(@" ICON SET ");
		
		resp_user.text = @"";
		if([respData.respon_user_id intValue] != 0)
		{
			for(RoomieData *temp in [User instance].accountData.roomiesData)
			{
				NSLog(@" user id %d :: %d ",
					  [temp.user_id intValue], [respData.respon_user_id intValue]);
					  
				if([temp.user_id intValue] == [respData.respon_user_id intValue])
				{
					resp_user.text = temp.user_name;
					break;
				}
			}
		}
		
		if([respData.resp_status intValue] == 0)
			resp_status.on = FALSE;
		else
			resp_status.on = TRUE;
		
		if([respData.alert_on intValue] == 0)
			resp_alert.on = FALSE;
		else
			resp_alert.on = TRUE;
		
		resp_notes.text = respData.resp_note;
	}
	else 
	{
		resp_title.text =@"";
		resp_notes.text =@"";
		repeat_schedule.text=@"None";
		resp_user.text = @"";
		resp_status.on = FALSE;
		resp_alert.on = FALSE;
		
		//prepopulate due date as today's date
		NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
		[df setDateFormat:@"YYYY-MM-dd"];
		resp_end_date.text = [NSString stringWithFormat:@"%@",
							  [df stringFromDate:[NSDate date]]];	
		
	}
}

- (IBAction) deleteClicked:(id)sender
{
	NSLog(@"RESP deleteClicked %p", respData);
	
	if(isViewOnly == TRUE)
	{
		NSString *idStr = [NSString stringWithFormat:@"%d", [respData.resp_id intValue]];
		
		NSMutableString *query = [[NSMutableString alloc ]initWithFormat:@"&UDID="] ;
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&resp_id="];
		[query appendString:(@"%@",idStr)];
		[query appendString:@"&request_type=resp_delete"];
		
		RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
		@try
		{
			NSString *response  = [del remoteRequest:query] ;
			NSLog(@" DELETE RESPONSE FROM SERVER %@  isViewOnly %d", response, isViewOnly);
			
			// delete it from the list:
			NSNumber *tmp = [NSNumber numberWithInteger:isEvent];

			respData = nil;
			if(isEvent == 1) //responEventTableViewController
			{
				del.responEventTableViewController.isEvent = tmp;
				[del.responEventTableViewController deleteItem:respData];
				[del.eventsNavController popViewControllerAnimated:YES];
			}
			else
			{
				del.responTableViewController.isEvent = tmp;
				[del.responTableViewController deleteItem:respData];
				[del.responNavController popViewControllerAnimated:YES];
			}
		}
		@catch (NSException * e) 
		{
			NSLog(@"delete respon exception caught");
			//display the reason why server cannot send back correct XML file
			NSLog(@"exception: %@", [e reason]);
			
			NSDictionary *userInfo =
			[NSDictionary dictionaryWithObject:
			 NSLocalizedString(@"Error delete reponsibility",
							   @"Error message displayed when have issues to delete reponsibility.")
										forKey:NSLocalizedDescriptionKey];
			
			NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
												 code:kCFURLErrorNotConnectedToInternet
											 userInfo:userInfo];
			[del handleError:error];
		}
		//[query release];
	}
}

- (IBAction) saveClicked:(id)sender
{
	NSLog(@"Save button clicked %p selectedRow %d preselectedRow %d rommiesSelection %d ", 
		  respData, selectedRow, preselectedRow, rommiesSelection);
	
	NSInteger resp_stat = 0;
	NSInteger alertInt = 0;
	
	[resp_title resignFirstResponder];
	[resp_end_date resignFirstResponder];
	[resp_notes resignFirstResponder];
	[resp_user resignFirstResponder];
	
	RoomieData *owner = nil;
	// Save user from roomies table
	if(rommiesSelection == TRUE)
	{
		if(preselectedRow != -1)
		{
			selectedRow = preselectedRow;
			owner = [roomiesList objectAtIndex:selectedRow];
			NSLog(@"table view selected %d User %@ id %d ", selectedRow, owner.user_name, [owner.user_id intValue]);
			resp_user.text = owner.user_name;
		}
		rommiesSelection = FALSE;
		tableView.hidden = TRUE;
		NSLog(@"table view selected DONE");
		return;
	}
	else if(selectedRow != -1)
	{
		owner = [roomiesList objectAtIndex:selectedRow];
	}
	
	if (resp_status.on) resp_stat=1;  
	else resp_stat=0;
	
	if (resp_alert.on) alertInt=1;  
	else alertInt=0;
	
	NSLog(@" resp_title %@", resp_title.text);
	NSLog(@" resp_end_date %@ ", resp_end_date.text);
	NSLog(@" resp_alert  %d ", alertInt);
	NSLog(@" resp_status  %d ", resp_stat);
	NSLog(@" resp_notes  %@ ", resp_notes.text);
	NSLog(@" resp_repeat  %@ ", repeat_schedule.text);
	NSLog(@" resp_owner  %@ ", resp_user.text);
	NSLog(@" selectedIcon %d", selectedIcon);
	
	if(owner != nil)
	{
		NSLog(@" resp_owner_id %@", [owner.user_id stringValue]);
	}
	else 
	{
		NSLog(@" resp_owner_id nil");
	}

	
	if(resp_title.text.length == 0 ||
	   resp_end_date.text.length == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Error Adding Responsibility."
							  message: @"Please enter all required fields !"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}	
	
	/* end date */
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
	
	NSDate *dueDate = [[NSDate alloc] init];
	dueDate = [dateFormatter dateFromString:resp_end_date.text];
	NSString *dateString = [dateFormatter stringFromDate:dueDate];
	NSLog(@" date from string %@", dateString);
	
	/* start date */
	NSDate *todayDate = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *todayString = [dateFormatter stringFromDate:todayDate];
	
	NSLog(@"today is date: %@ selectedRepeat %d ", todayString, selectedRepeat);
	
	[resp_title resignFirstResponder];
	[resp_user resignFirstResponder];
	[resp_notes resignFirstResponder];
	
	NSString *respStatStr = [NSString stringWithFormat:@"%d", resp_stat];
	NSString *respAlertStr = [NSString stringWithFormat:@"%d", alertInt];
	NSString *repeatStr = [NSString stringWithFormat:@"%d", selectedRepeat];
	NSMutableString * query = nil;
	NSLog(@"Save button clicked isViewOnly %d ", isViewOnly);

	NSString *iconStr = [NSString stringWithFormat:@"%d ", selectedIcon];
	
	// ADD respons
	if(isViewOnly == FALSE)
	{
		respData = [[RespData alloc] init];
		NSLog(@"ADDING RESPONS %p selectedIcon %d", respData, selectedIcon);
		
		respData.resp_title =resp_title.text;
		respData.alert_on = [NSNumber numberWithInt:alertInt];
		respData.resp_start_date = todayDate;
		respData.resp_end_date = dueDate;
		respData.resp_status = [NSNumber numberWithInt:resp_stat];
		respData.resp_note = resp_notes.text;
		respData.repeat_schedule = [NSNumber numberWithInt:selectedRepeat];
		respData.respon_user_name = resp_user.text;
		respData.icon_id = [NSNumber numberWithInt:selectedIcon];
		
		int xx = 0;
		if(isEvent)
			respData.event_id = event_id;
		else
			respData.event_id = [NSNumber numberWithInt:xx];
		
		NSDate *t = respData.resp_start_date;
		NSString *startStr = [dateFormatter stringFromDate:t];
		
		// Creation of the query string containing all the variables including UDID
		query = [[NSMutableString alloc ]initWithFormat:@"resp_title="] ;
		[query appendString:(@"%@", respData.resp_title)];
		[query appendString:@"&resp_alert_on="];
		[query appendString:(@"%@", respAlertStr)];
		[query appendString:@"&resp_end_date="];
		[query appendString:(@"%@", dateString)];
		[query appendString:@"&resp_status="];
		[query appendString:(@"%@", respStatStr)];
		[query appendString:@"&resp_note="];
		[query appendString:(@"%@", respData.resp_note)];
		[query appendString:@"&resp_start_date="];
		[query appendString:(@"%@", startStr)];
		[query appendString:@"&resp_repeat_schedule="];
		[query appendString:(@"%@", repeatStr)];
		[query appendString:@"&resp_user="];
		[query appendString:(@"%@", respData.respon_user_name)];
		if(owner != nil)
		{
			[query appendString:@"&user_id="];
			[query appendString:(@"%@", [owner.user_id stringValue])];
		}
		else
		{
			[query appendString:@"&user_id="];
			[query appendString:@"0"];
		}
		if(isEvent)
		{
			[query appendString:@"&event_id="];
			[query appendString:(@"%@", [event_id stringValue])];
		}
		else 
		{
			[query appendString:@"&event_id="];
			[query appendString:(@"0")];
		}
		[query appendString:@"&icon_id="];
		[query appendString:(@"%@", iconStr)];
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		[query appendString:@"&request_type=resp_creation"];
	}
	else
	{
		NSLog(@"trying to update respons");
		
		NSLog(@"UPDATE RESP %p", respData);
		NSLog(@"UPDATE RESP id %d ", [respData.resp_id intValue]);
		
		respData.resp_title = resp_title.text;
		respData.alert_on = [NSNumber numberWithInt:alertInt];
		respData.resp_start_date = todayDate;
		respData.resp_end_date = dueDate;
		respData.resp_status = [NSNumber numberWithInt:resp_stat];
		respData.resp_note = resp_notes.text;
		respData.repeat_schedule = [NSNumber numberWithInt:selectedRepeat];
		respData.respon_user_name = resp_user.text;
		respData.icon_id = [NSNumber numberWithInt:selectedIcon];
		
		NSDate *t = respData.resp_start_date;
		NSString *startStr = [dateFormatter stringFromDate:t];
		
		// Creation of the query string containing all the variables including UDID
		query = [[NSMutableString alloc ]initWithFormat:@"resp_title="] ;
		[query appendString:(@"%@", respData.resp_title)];
		[query appendString:@"&resp_id="];		
		[query appendString:(@"%@", [respData.resp_id stringValue])];
		[query appendString:@"&resp_alert_on="];		
		[query appendString:(@"%@", respAlertStr)];
		[query appendString:@"&resp_end_date="];
		[query appendString:(@"%@", dateString)];
		[query appendString:@"&resp_status="];
		[query appendString:(@"%@", respStatStr)];
		if(respData.resp_note.length != 0)
		{
			[query appendString:@"&resp_note="];
			[query appendString:(@"%@", respData.resp_note)];
		}
		else {
			[query appendString:@"&resp_note="];
			[query appendString:(@"%@", @"")];
		}
		if(isEvent)
		{
			[query appendString:@"&event_id="];
			[query appendString:(@"%@", [event_id stringValue])];
		}
		else 
		{
			[query appendString:@"&event_id="];
			[query appendString:(@"0")];
		}
		[query appendString:@"&icon_id="];
		[query appendString:(@"%@", iconStr)];
		[query appendString:@"&resp_start_date="];
		[query appendString:(@"%@", startStr)];
		[query appendString:@"&resp_repeat_schedule="];
		[query appendString:(@"%@", repeatStr)];
		[query appendString:@"&resp_user="];
		if(respData.respon_user_name != nil)
			[query appendString:(@"%@", respData.respon_user_name)];
		else 
			[query appendString:(@"%@", @"")];
		if(owner != nil)
		{
			[query appendString:@"&user_id="];
			[query appendString:(@"%@", [owner.user_id stringValue])];
		}
		else
		{
			[query appendString:@"&user_id="];
			[query appendString:@"0"];
		}
		
		[query appendString:@"&UDID="];
		[query appendString:(@"%@",[User instance].UDID)];
		
		[query appendString:@"&request_type=resp_update"];
	}
	
	@try
	{
		RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
		NSString *response  = [del remoteRequest:query] ;
		NSLog(@"RESPONS isEvent %d ", isEvent);
		if(response != nil)
		{
			if(isViewOnly == FALSE) // add
			{
				[respData setResp_id:[NSNumber numberWithInt:[response integerValue]]];
				//NSNumber *respon_user_id;  // owner of responsibilities
				//NSString *respon_user_phone;
				
				
				NSLog(@" responsibility,,,, id created %d isEvent %d ", 
					  [respData.resp_id intValue], isEvent);
				
				deleteButton.hidden = FALSE;
				// add to the list:
				
				NSNumber *tmp = [NSNumber numberWithInteger:isEvent];
				if(isEvent == 1) //responEventTableViewController
				{
					del.responEventTableViewController.isEvent = tmp;
					[del.responEventTableViewController addItem:respData];

				}
				else 
				{
					del.responTableViewController.isEvent = tmp;
					[del.responTableViewController addItem:respData];
				}

				// if(isEvent == 1)
					// [del.eventsNavController popViewControllerAnimated:YES];

			}
			else // update
			{
				// update the list:
				NSNumber *tmp = [NSNumber numberWithInteger:isEvent];
				if(isEvent == 0)
				{
					del.responTableViewController.isEvent = tmp;
					[del.responTableViewController updateItem:respData];
				}
				else //responEventTableViewController
				{
					del.responEventTableViewController.isEvent = tmp;
					[del.responEventTableViewController updateItem:respData];
				}

			}
			isViewOnly = TRUE;
			resp_title.enabled = FALSE;
		}
		NSLog(@" RESPONSE FROM SERVER <%@> ", response);
	}
	@catch (NSException * e) 
	{
		NSLog(@"adding/updating bill exception caught");
		//display the reason why server cannot send back correct XML file
		NSLog(@"exception: %@", [e reason]);
		
		RoomiesAppDelegate *del = (RoomiesAppDelegate *) [[UIApplication sharedApplication] delegate];
		NSDictionary *userInfo =
		[NSDictionary dictionaryWithObject:
		 NSLocalizedString(@"Error save reponsibility",
						   @"Error message displayed when have issues to save reponsibility.")
									forKey:NSLocalizedDescriptionKey];
		
		NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
											 code:kCFURLErrorNotConnectedToInternet
										 userInfo:userInfo];
		[del handleError:error];
		
	}
	NSLog(@"save RESP %p", respData);					 
	
	//[self setupAlarm:dueDate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	NSLog(@"textFieldShouldReturn");
	[textField resignFirstResponder];
	return NO;
}


- (IBAction) didEndEdit:(id) sender
{
	NSLog(@"didEndEdit");
	if(sender == resp_title)
	{
		NSLog(@"title");
		[self.view resignFirstResponder];
	}
}

- (IBAction) iconClicked:(id) sender
{
	if(sender == icon_btn)
	{
		NSLog(@"didBeginDateEdit iconPicker");
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
	    
		[icon_fd resignFirstResponder];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Task Icon", @"")]
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
	
	if(sender == resp_end_date)
	{
		NSLog(@"didBeginDateEdit sender resp_end_date");
		
		[resp_end_date resignFirstResponder];
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Responsibility's Due Date", @"")]
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
		NSLog(@"didBeginDateEdit repeatPicker");
		
		NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
	    
		[repeat_schedule resignFirstResponder];
		UIActionSheet *actionSheet = [[UIActionSheet alloc] 
									  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"Select Reminder Frequency", @"")]
									  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
		// IMPORTANT for CXL button
		[actionSheet showInView:self.parentViewController.tabBarController.view];
		
		self.repeatPicker = [[[UIPickerView alloc] init] autorelease];
		self.repeatPicker.showsSelectionIndicator = YES;
		[actionSheet addSubview:self.repeatPicker];
		self.repeatPicker.delegate = self;
		[actionSheet release];
	}
	if(sender == resp_user)
	{
		[resp_user resignFirstResponder];
		rommiesSelection =TRUE;
		[self.view addSubview:tableView];
		tableView.hidden = FALSE;
		
		NSLog(@"EDIT RESP USER  %d", rommiesSelection);
	}
	NSLog(@"didBeginDateEdit DONE");
}

- (void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent: (NSInteger)component
{
    NSLog(@"didSelectRow %d ", row);// The label is simply setup to show where the picker selector is at

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
		 img.opaque = YES; [viewForRow addSubview:img]; 
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
    return [repeatData objectAtIndex:row];
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
		return [self.repeatData count];
	}
	if(iconPicker != nil)
	{
		return [self.iconsData count];
	}
	return 0;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	NSLog(@"clickedButtonAtIndex %d datePicker %p repeatPicker %p", buttonIndex, datePicker, repeatPicker);
	
	if (buttonIndex == 0 && self.datePicker != nil) 
	{		
		NSDateFormatter * df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"YYYY-MM-dd"];
		resp_end_date.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
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
		//icon_fd.background = 
		UIImage *img = [UIImage imageNamed:[iconsData objectAtIndex:selectedIcon]]; 
		icon_img.image = img;
		[img release];
		self.iconPicker = nil;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [roomiesList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"inside of cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		//cell.font = [UIFont fontWithName:@"Georgia" size:22.0];
		[cell.textLabel setFont:[UIFont fontWithName:@"Georgia" size:22]];
	}
    
    // setup cell
	NSInteger row  = [indexPath row];
	NSLog(@" cellForRowAtIndexPath row %d", row);
	RoomieData *data = [roomiesList objectAtIndex:row];
	NSString *name = data.user_name;
	[cell.textLabel setText:name];
	[name release];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"RESP inside of didSelectRowAtIndexPath selectedRow %d ", selectedRow);
	
	preselectedRow = [indexPath row];
	NSLog(@"finish of didSelectRowAtIndexPath preselectedRow %d ", preselectedRow);
}



- (void)didReceiveMemoryWarning 
{
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
	[resp_title release];
	[resp_end_date release];
	[repeat_schedule release];
	[resp_status release];
	[resp_notes release];
	[resp_alert release];
	[resp_user release];
	
	[deleteButton release];
	[datePicker release];
	[repeatPicker release];
	[repeatData release];
	[roomiesList release];
	[event_id release];
	[imageViewArray release];
	[iconPicker release];
	[iconsData release];
	[tableView release];
	[icon_fd release];
	[icon_img release];
	[icon_btn release];
	
    [super dealloc];
}


@end
