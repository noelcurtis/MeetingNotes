//
//  MeetingCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/7/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TapkuLibrary/TapkuLibrary.h>


@interface MeetingCell : UITableViewCell {
    
}

@property(nonatomic, retain) IBOutlet UILabel* meetingLabel;
@property(nonatomic, retain) IBOutlet UILabel* locationLabel;
@property(nonatomic, retain) IBOutlet UILabel* actionItemCountLabel;
@property(nonatomic, retain) IBOutlet UILabel* locationNameLabel;

@end
