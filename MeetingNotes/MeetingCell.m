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
@synthesize categoryImage;
@synthesize backgroundImage;
@synthesize isStarred;
@synthesize starButton;


-(IBAction) starClicked:(id)sender{
    if(isStarred){
        isStarred = NO;
        [self.starButton setImage:[UIImage imageNamed:@"favstar_off"] forState:UIControlStateNormal];
    }else{
        isStarred = YES;
        [self.starButton setImage:[UIImage imageNamed:@"favstar_on"] forState:UIControlStateNormal];
    }
}

-(void)dealloc{
    [starButton release];
    [backgroundImage release];
    [categoryImage release];
    [meetingLabel release];
    [locationNameLabel release];
    [locationLabel release];
    [actionItemCountLabel release];
    [super dealloc];
}

@end
