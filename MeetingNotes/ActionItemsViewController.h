//
//  ActionItemsViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/8/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class ActionItem;
@interface ActionItemsViewController : UITableViewController<ABPeoplePickerNavigationControllerDelegate> {
    
}

@property (nonatomic, retain) ActionItem *actionItem;
@property (nonatomic, retain) NSMutableArray *actionableAttendees;
@property (nonatomic, retain)IBOutlet UITableViewCell *actionItemNoteCell;

-(IBAction) addActionableAttendeesAction:(id)sender;


// Test with popover view controller
@end
