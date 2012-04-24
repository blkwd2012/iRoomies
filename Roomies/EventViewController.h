//
//  EventNavController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventData.h"
#import "ResponTableViewController.h"
#import "RoomiesAppDelegate.h"

@interface EventViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>
{

	UIButton *respButton;
	UIButton *deleteButton;
	
	UITextField *event_title;
	UITextField *event_start_date;
	UITextField *event_end_date;
	UISwitch    *event_alert;
	UITextField *event_notes;
	UITextField *icon_fd;
	UIImageView *icon_img;
	UIButton *icon_btn;
	
	UIPickerView *iconPicker;
	
	UIDatePicker *datePicker;
	NSMutableArray *iconsData;
	NSMutableArray *imageViewArray;
	NSInteger selectedIcon;
	
	//ResponTableViewController *responTableViewController;
	
@public
	
	bool isViewOnly;
	EventData *eventData;
}

@property (nonatomic, retain) NSMutableArray *imageViewArray;
@property (nonatomic, retain) NSMutableArray *iconsData;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *iconPicker;

@property (nonatomic) bool isViewOnly; // view or add mode
@property (nonatomic, retain) EventData *eventData;

@property (nonatomic, retain) IBOutlet UIButton *respButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UITextField *icon_fd;
@property (nonatomic, retain) IBOutlet UIImageView *icon_img;
@property (nonatomic, retain) IBOutlet UIButton *icon_btn;


@property (nonatomic, retain) IBOutlet UITextField *event_title;
@property (nonatomic, retain) IBOutlet UITextField *event_start_date;
@property (nonatomic, retain) IBOutlet UITextField *event_end_date;
@property (nonatomic, retain) IBOutlet UISwitch *event_alert;
@property (nonatomic, retain) IBOutlet UITextField *event_notes;

//@property (nonatomic, retain) IBOutlet ResponTableViewController *responTableViewController;

-(void) populate_event_info;
-(void) populateImagesArray;
-(void) viewEventResponsibilities;
-(void) deleteEvent;

- (IBAction) didBeginDateEdit:(id)sender;
- (IBAction) buttonClicked:(id)sender;
- (IBAction) saveClicked:(id)sender;
- (IBAction) iconClicked:(id)sender;

@end
