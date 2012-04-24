//
//  BillViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillData;


@interface BillViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>
{
	
	UITextField *bill_title;
	UITextField *bill_due_date;
	UITextField *repeat_schedule;
	UITextField *bill_amount;
	UISwitch *bill_status;
	UITextField *bill_notes;
	UIImageView *icon_img;
	UIButton *icon_btn;
	UITextField *icon_fd;
	
	UILabel *amountLbl;
	UIButton *deleteButton;
	UIDatePicker *datePicker;
	UIPickerView *repeatPicker;
	UIPickerView *iconPicker;
	NSMutableArray *repeatData;
	NSMutableArray *iconsData;
	
	NSMutableArray *imageViewArray;
	
	NSInteger selectedRepeat;
	NSInteger selectedIcon;
	
@public
	
	bool isViewOnly;
	BillData *billData;
}

//@property (nonatomic, assign) NSInteger selectedIcon;
//@property (nonatomic, assign) NSInteger selectedRepeat;

@property (nonatomic, retain) NSMutableArray *imageViewArray;

@property (nonatomic, retain) NSMutableArray *iconsData;
@property (nonatomic, retain) NSMutableArray *repeatData;
@property (nonatomic) bool isViewOnly; // view or add mode
@property (nonatomic, retain) BillData *billData;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *repeatPicker;
@property (nonatomic, retain) UIPickerView *iconPicker;

@property (nonatomic, retain) IBOutlet UITextField *icon_fd;
@property (nonatomic, retain) IBOutlet UIImageView *icon_img;
@property (nonatomic, retain) IBOutlet UIButton *icon_btn;

@property (nonatomic, retain) IBOutlet UITextField *bill_title;
@property (nonatomic, retain) IBOutlet UITextField *bill_due_date;
@property (nonatomic, retain) IBOutlet UITextField *repeat_schedule;
@property (nonatomic, retain) IBOutlet UITextField *bill_amount;
@property (nonatomic, retain) IBOutlet UISwitch *bill_status;
@property (nonatomic, retain) IBOutlet UITextField *bill_notes;
@property (nonatomic, retain) IBOutlet UILabel *amountLbl;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;

- (IBAction) saveClicked:(id)sender;
- (IBAction) deleteClicked:(id)sender;
- (IBAction) didBeginDateEdit:(id)sender;
- (IBAction) didEndEdit:(id) sender;
- (IBAction) iconClicked:(id) sender;

//- (IBAction) didEndOnExit:(id)sender;
- (void) populate_bill_info;
- (void) setupAlarm:(NSDate *) alarmDate forRepeat:(NSNumber *)repeatSchedule forId:(NSNumber *) billId;

- (void) populateImagesArray;

@end
