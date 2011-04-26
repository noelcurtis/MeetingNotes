//
//  SortDetailViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortRootViewController;
@interface SortDetailViewController : UIViewController<UISplitViewControllerDelegate> {
    
    UIViewController *activeViewController; // use to hold the current active detail view
    
}

@property(nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property(nonatomic, retain) IBOutlet SortRootViewController *rvController;
@property(nonatomic, retain) IBOutlet UIPopoverController *popoverController;

@property(nonatomic, retain) IBOutlet UIBarButtonItem *calendarButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *flexButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction) calenderButtonClick:(id)sender;
-(IBAction) addButtonPressed:(id) sender;
-(void) setupWithActiveViewController:(UIViewController*)controller;
@end
