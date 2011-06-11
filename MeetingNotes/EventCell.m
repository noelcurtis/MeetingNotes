//
//  EventCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/10/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "EventCell.h"

@interface EventCell()
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@end

@implementation EventCell

@synthesize eventTime;
@synthesize eventName;
@synthesize eventDetails;
@synthesize dateFormatter;

-(void) setupWithEvent:(EKEvent *)event{
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.eventName.text = event.title;
    self.eventTime.text = [self.dateFormatter stringFromDate:event.startDate];
    if (event.location && event.location != @"") {
        self.eventDetails.text = event.location;
    }else if(event.notes && event.notes != @""){
        self.eventDetails.text = event.notes;
    }else{
        self.eventDetails.text = @"";
    }
}

-(void)dealloc{
    [eventTime release];
    [eventName release];
    [eventDetails release];
    [super dealloc];
}

@end
