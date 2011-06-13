//
//  MeetingCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/7/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "MeetingCell.h"
#import "Meeting.h"

@interface MeetingCell() 
@property (nonatomic, retain) Meeting *meeting;
@end

@implementation MeetingCell
@synthesize meetingLabel;
@synthesize locationLabel;
@synthesize locationNameLabel;
@synthesize actionItemCountLabel;
@synthesize categoryImage;
@synthesize backgroundImage;
@synthesize isStarred;
@synthesize starButton;
@synthesize meeting = _meeting;

-(IBAction) starClicked:(id)sender{
    if(isStarred){
        _meeting.isStarred = [NSNumber numberWithInt:0] ;
        isStarred = NO;
        [self.starButton setImage:[UIImage imageNamed:@"favstar_off"] forState:UIControlStateNormal];
    }else{
        _meeting.isStarred = [NSNumber numberWithInt:1];
        isStarred = YES;
        [self.starButton setImage:[UIImage imageNamed:@"favstar_on"] forState:UIControlStateNormal];
    }
    // Save the context.
    NSError *error = nil;
    if (![[_meeting managedObjectContext] save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

// Use to setup the cell with a Meeting
-(void) setupWithMeeting:(Meeting *)meeting{
    _meeting = meeting;
    self.meetingLabel.text = [[meeting valueForKey:@"name"] description];
    if ([[meeting valueForKey:@"location"] description]) {
        self.locationLabel.text = [[meeting valueForKey:@"location"] description];
    }else{
        self.locationLabel.hidden = YES;
        self.locationNameLabel.hidden = YES;
    }
    if([meeting getActionItemCount] > 0)
    {
        self.actionItemCountLabel.text = [NSString stringWithFormat:@"%d",[meeting getActionItemCount]];
    }
    else
    {
        [self.actionItemCountLabel setHidden:YES];
    }
    if([meeting.isStarred isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        isStarred = YES;
        [self.starButton setImage:[UIImage imageNamed:@"favstar_on"] forState:UIControlStateNormal];   
    }
    if([meeting.isStarred isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        isStarred = NO;
        [self.starButton setImage:[UIImage imageNamed:@"favstar_off"] forState:UIControlStateNormal];   
    }
}

-(void)dealloc{
    //[_meeting release];
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
