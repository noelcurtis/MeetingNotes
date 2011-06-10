//
//  StartsEndsViewController.h
//  Notes
//
//  Created by Scott Penrose on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateMinutesViewController;
@interface StartsEndsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UILabel *startsDateTimeLabel;
	UILabel *endsDateTimeLabel;
	
	UITableViewCell *startsCell;
	UITableViewCell *endsCell;
}

@property (nonatomic, retain) IBOutlet UILabel *startsDateTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *endsDateTimeLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *startsCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *endsCell;
@property (nonatomic, retain) IBOutlet NSDate *startsDate;
@property (nonatomic, retain) IBOutlet NSDate *endsDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) CreateMinutesViewController *createMinutesViewControllerRef;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)dateAction:(id)sender;	// when the user has changed the date picke values (m/d/y)

@end
