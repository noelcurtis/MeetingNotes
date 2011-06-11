//
//  MeetingCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/7/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "MeetingCell.h"


@implementation MeetingCell
@synthesize meetingLabel;
@synthesize locationLabel;
@synthesize locationNameLabel;
@synthesize actionItemCountLabel;

-(void)dealloc{
    [meetingLabel release];
    [locationNameLabel release];
    [locationLabel release];
    [actionItemCountLabel release];
    [super dealloc];
}

@end
