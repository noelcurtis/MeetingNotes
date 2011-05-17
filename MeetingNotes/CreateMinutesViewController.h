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

@protocol CreateMinutesModalViewControllerDelegate;

@interface CreateMinutesViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, 
UITableViewDelegate, UITableViewDataSource> {
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

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
// options segment action
- (IBAction)optionsSegmentAction:(id)sender;
-(void) addActionableAttendeesAction;

@end

@protocol CreateMinutesModalViewControllerDelegate
-(void)didDismissModalView;
-(void)insertMinuteWithTitle:(NSString *)title place:(NSString *)place;
-(void)insertNewMeetingWithName:(NSString *)name location:(NSString *)location 
                      startDate:(NSDate *)startDate endDate:(NSDate *)endDate 
                      attendees:(NSSet *)attendees;
-(void)insertNewMeeting:(Meeting *)newMeeting;
@end