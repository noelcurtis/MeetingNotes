//
//  CreateMinutesViewController.h
//  Notes
//
//  Created by Scott Penrose on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Meeting.h"
#import "Category.h"
#import "SelectCategorieViewController.h"

@protocol CreateMinutesModalViewControllerDelegate;

@interface CreateMinutesViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, 
UITableViewDelegate, UITableViewDataSource, SelectCategoryViewControllerDelegate> {
	id<CreateMinutesModalViewControllerDelegate> delegate;
	
	UITextField *titleTextField;
	UITextField *locationTextField;
	
	UITableViewCell *titleCell;
	UITableViewCell *locationCell;
	UITableViewCell *startsEndsCell;
}

@property (nonatomic, assign) id<CreateMinutesModalViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *locationTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *titleCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *locationCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *startsEndsCell;
@property (nonatomic, retain) NSMutableArray *attendees;
// setup when the view is loaded
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSDate *startsDate;
@property (nonatomic, retain) NSDate *endsDate;
@property (nonatomic, retain) IBOutlet UILabel *startsDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endsDateLabel;

// new attendees cell
@property (nonatomic, retain) IBOutlet UITextField *newAttendeeTextField;
@property (nonatomic, retain) IBOutlet UIButton *addCustomAttendeeButton;
@property (nonatomic, retain) IBOutlet UITableViewCell  *addAttendeeCell;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
// options segment action
- (IBAction)optionsSegmentAction:(id)sender;
-(void) addActionableAttendeesAction;

@end

@protocol CreateMinutesModalViewControllerDelegate
-(void)didDismissModalView;
-(void)insertNewMeeting:(Meeting *)newMeeting;
@end