//
//  SortDetailViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateMinutesViewController.h"
#import "Meeting.h"
@class SortRootViewController;
@interface SortDetailViewController : UIViewController<UISplitViewControllerDelegate, CreateMinutesModalViewControllerDelegate, UIPopoverControllerDelegate> {
    
    UIViewController *activeViewController; // use to hold the current active detail view
        
}

@property(nonatomic, retain)UIViewController *activeViewController;
@property(nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property(nonatomic, retain) IBOutlet SortRootViewController *rvController;
@property(nonatomic, retain) IBOutlet UIPopoverController *rootViewPopover;

@property(nonatomic, retain) IBOutlet UIBarButtonItem *calendarButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *addnewMeetingButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *flexButton;
@property(nonatomic, retain) IBOutlet UIPopoverController *createMinutePopoverController;
@property(nonatomic, retain) IBOutlet UIPopoverController *calenderCreatePopover;
@property(nonatomic, assign) BOOL isActiveViewControllerHidden;

// set when the application starts up
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction) calenderButtonClick:(id)sender;
-(IBAction) addButtonPressed:(id) sender;
-(void) setupWithActiveViewController:(UIViewController*)controller;
-(void) hideActiveViewController;
-(void) showActiveViewController;
-(void) setupWithMeetingListViewController;
//Methods to satisfy the CreateMinutesModalViewControllerDelegate protocol
-(void)didDismissModalView;
-(void)insertNewMeeting:(Meeting *)newMeeting;

//Method to push Notes View Controllers
-(void) pushMeetingNotesViewControllers;
-(void) pushMeetingNotesViewControllers:(Meeting *)meetingToEdit;

@end
