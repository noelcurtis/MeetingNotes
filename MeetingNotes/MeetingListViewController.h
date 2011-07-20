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

@class SortRootViewController;
@class SortDetailViewController;
@class Category;
@interface MeetingListViewController : UITableViewController<UISearchBarDelegate> {
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SortDetailViewController *masterSortDetailView;
@property (nonatomic, retain) SortRootViewController *masterSortRootView;
@property (nonatomic, retain) IBOutlet MeetingCell *meetingCell;
@property (nonatomic, retain) NSMutableArray *meetingsForCategory;
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) Category *categoryForMeetings;

-(void) insertNewMeeting:(Meeting *)newMeeting;
-(void) insertNewMeetingWithEvent:(EKEvent*)event;
@end
