//
//  ActionItemCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/18/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "ActionItemCell.h"


@implementation ActionItemCell
@synthesize actionItemLabel;
@synthesize actionableAttendeesLabel;
@synthesize actionItemDetailButton;

-(void) dealloc{
    [actionItemLabel release];
    [actionableAttendeesLabel release];
    [actionItemDetailButton release];
    [super dealloc];
}

@end
