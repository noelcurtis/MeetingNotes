//
//  MeetingCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/7/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"

@interface MeetingCell : UITableViewCell {
    
    UIImageView *actionNumberImage;
}

@property (nonatomic, retain) IBOutlet UILabel* meetingLabel;
@property (nonatomic, retain) IBOutlet UILabel* locationLabel;
@property (nonatomic, retain) IBOutlet UILabel* actionItemCountLabel;
@property (nonatomic, retain) IBOutlet UILabel* locationNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView* backgroundImage;
@property (nonatomic, retain) IBOutlet UIImageView* categoryImage;
@property (nonatomic, assign) BOOL isStarred;
@property (nonatomic, retain) IBOutlet UIButton *starButton;
@property (nonatomic, retain) IBOutlet UILabel* startDateValueLabel;
@property (nonatomic, retain) IBOutlet UIImageView *actionNumberImage;

-(IBAction) starClicked:(id)sender;
-(void) setupWithMeeting:(Meeting*) meeting;

@end
