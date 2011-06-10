//
//  ActionItemCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/18/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "ActionItemCell.h"
#import "Attendee.h"

@implementation ActionItemCell
@synthesize actionItemLabel;
@synthesize actionableAttendeesLabel;

-(void) dealloc{
    [actionItemLabel release];
    [actionableAttendeesLabel release];
    [super dealloc];
}

-(void) setupAttendeesLabel:(NSSet *)Attendees{
    NSMutableArray *attendeesLabelText = [[[NSMutableArray alloc] init] autorelease];
    for (Attendee *attendee in Attendees) {
        [attendeesLabelText addObject:attendee.name];
    }
    self.actionableAttendeesLabel.text = [attendeesLabelText componentsJoinedByString:@", "];
}

@end
