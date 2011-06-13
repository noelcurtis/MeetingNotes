//
//  ActionItemCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/18/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActionItem.h"

@interface ActionItemCell : UITableViewCell {
    
}
@property (nonatomic, retain)IBOutlet UILabel *actionItemLabel;
@property (nonatomic, retain)IBOutlet UILabel *actionableAttendeesLabel;
@property (nonatomic, retain)IBOutlet UIImageView *runningMan;
@property (nonatomic, retain)IBOutlet UIButton *checkbox;
@property (nonatomic, assign) BOOL isChecked;

-(void) setupAttendeesLabel:(NSSet*) Attendees;
-(void) setupWithActionItem:(ActionItem*) actionItem;
-(IBAction) checkboxClicked:(id)sender;
@end
