//
//  EventsViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/10/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "EventCell.h"

@protocol CalendarEventSelectedDelegate;

@interface EventsViewController : UITableViewController {
    
}

@property (nonatomic, assign) id<CalendarEventSelectedDelegate> calenderEventSelectedDelegate;

@end

@protocol CalendarEventSelectedDelegate
-(void) insertMeeting:(EKEvent*)event;
-(void) didDismissEventsViewController;
@end
