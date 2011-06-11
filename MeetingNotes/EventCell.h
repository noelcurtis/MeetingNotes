//
//  EventCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/10/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UILabel *eventTime;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDetails;
-(void) setupWithEvent:(EKEvent *)event;

@end
