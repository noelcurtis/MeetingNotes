//
//  ActionItemCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/18/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "ActionItemCell.h"
#import "Attendee.h"

@class ActionItem;
@interface ActionItemCell()
@property (nonatomic, retain) ActionItem *actionItem;
@end

@implementation ActionItemCell
@synthesize actionItemLabel;
@synthesize actionableAttendeesLabel;
@synthesize actionItem = _actionItem;
@synthesize runningMan;
@synthesize isChecked;
@synthesize checkbox;

-(void) dealloc{
    [checkbox release];
    [runningMan release];
    [actionItemLabel release];
    [actionableAttendeesLabel release];
    [super dealloc];
}

-(IBAction) checkboxClicked:(id)sender{
    if(isChecked){
        _actionItem.isComplete = [NSNumber numberWithInt:0] ;
        isChecked = NO;
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];
    }else{
        _actionItem.isComplete = [NSNumber numberWithInt:1] ;
        isChecked = YES;
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];
    }
    // Save the context.
    NSError *error = nil;
    if (![[_actionItem managedObjectContext] save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

-(void) setupAttendeesLabel:(NSSet *)Attendees{
    NSMutableArray *attendeesLabelText = [[[NSMutableArray alloc] init] autorelease];
    for (Attendee *attendee in Attendees) {
        [attendeesLabelText addObject:attendee.name];
    }
    self.actionableAttendeesLabel.text = [attendeesLabelText componentsJoinedByString:@", "];
    if([_actionItem.isComplete isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        self.isChecked = YES;
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];   
    }
    if([_actionItem.isComplete isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        self.isChecked = NO;
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];   
    }
}


-(void) setupWithActionItem:(ActionItem *)actionItem{
    _actionItem = actionItem;
    self.actionItemLabel.text = actionItem.notes;
    [self setupAttendeesLabel:actionItem.Attendees];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
