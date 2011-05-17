//
//  ActionItemsViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/8/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionItem;
@class Meeting;
@class AgendaItem;
@interface ActionItemsViewController : UITableViewController {
    
}

@property (nonatomic, retain) Meeting *meetingBeingEdited;
@property (nonatomic, retain) ActionItem *actionItem;
@property (nonatomic, retain) AgendaItem *agendaItem;
// attendees that are actionable because they are related to this action item.
@property (nonatomic, retain) NSMutableArray *actionableAttendeesToAdd;
@property (nonatomic, retain) NSMutableArray *actionableAttendeesToRemove;
// all attendees in the meeting
@property (nonatomic, retain) NSMutableArray *allAttendees;
@property (nonatomic, retain) IBOutlet UITableViewCell *actionItemNoteCell;
@property (nonatomic, retain) IBOutlet UITextField *actionItemNote;
// Test with popover view controller
@end
