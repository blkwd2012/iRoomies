//
//  ApplicationInfoViewController.h
//  Roomies
//
//  Created by Anna Zakharova on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ApplicationInfoViewController : UIViewController 
{
	UITextView *textView;
}

@property (nonatomic,retain) IBOutlet UITextView *textView;

@end
