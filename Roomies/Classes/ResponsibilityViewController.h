//
//  ResponsibilityViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RespData.h"
#import "RoomieData.h"


@interface ResponsibilityViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
	
	UITextField *resp_title;
	UITextField *resp_end_date;
	UITextField *repeat_schedule;
	UISwitch *resp_status;
	UITextField *resp_notes;
	UISwitch *resp_alert;
	UITextField *resp_user;
	UITextField *icon_fd;
	UIImageView *icon_img;
	UIButton *icon_btn;
	
	UIButton *deleteButton;
	UIDatePicker *datePicker;
	UIPickerView *repeatPicker;
	NSMutableArray *repeatData;
	UITableView *tableView;
	
	NSInteger selectedRepeat;
	
	bool rommiesSelection;
	NSInteger selectedRow;
	NSInteger preselectedRow;
	NSInteger selectedIcon;
	
	NSMutableArray *roomiesList;
	NSMutableArray *imageViewArray;
	NSMutableArray *iconsData;
	UIPickerView *iconPicker;
	
@public
	NSNumber *event_id;
	bool isEvent;
    bool isViewOnly;
	RespData *respData;
}

@property (nonatomic, retain) NSNumber *event_id;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) NSInteger preselectedRow;
@property (nonatomic, assign) NSInteger selectedUserId;

@property (nonatomic) bool rommiesSelection;
@property (nonatomic) bool isEvent;
@property (nonatomic) bool isViewOnly; // view or add mode
@property (nonatomic, retain) RespData *respData;
@property (nonatomic, retain) NSMutableArray *repeatData;
@property (nonatomic, retain) NSMutableArray *roomiesList;
@property (nonatomic, retain) NSMutableArray *imageViewArray;
@property (nonatomic, retain) NSMutableArray *iconsData;

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *repeatPicker;
@property (nonatomic, retain) UIPickerView *iconPicker;

@property (nonatomic, retain) IBOutlet UISwitch *resp_alert;
@property (nonatomic, retain) IBOutlet UITextField *resp_user;
@property (nonatomic, retain) IBOutlet UITextField *resp_title;
@property (nonatomic, retain) IBOutlet UITextField *resp_end_date;
@property (nonatomic, retain) IBOutlet UITextField *repeat_schedule;
@property (nonatomic, retain) IBOutlet UISwitch *resp_status;
@property (nonatomic, retain) IBOutlet UITextField *resp_notes;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UITextField *icon_fd;
@property (nonatomic, retain) IBOutlet UIImageView *icon_img;
@property (nonatomic, retain) IBOutlet UIButton *icon_btn;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction) saveClicked:(id)sender;
- (IBAction) deleteClicked:(id)sender;
- (IBAction) didBeginDateEdit:(id)sender;
- (IBAction) didEndEdit:(id) sender;
- (IBAction) iconClicked:(id) sender;

- (void) populate_resp_info;
- (void) populateImagesArray;

@end
