//
//  MeetingListViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/25/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "MeetingCell.h"
#import <Eventkit/EventKit.h>

@class SortDetailViewController;
@interface MeetingListViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SortDetailViewController *masterSortDetailView;
@property (nonatomic, retain) IBOutlet MeetingCell *meetingCell;


-(void) insertNewMeeting:(Meeting *)newMeeting;
-(void) insertNewMeetingWithEvent:(EKEvent*)event;
@end
