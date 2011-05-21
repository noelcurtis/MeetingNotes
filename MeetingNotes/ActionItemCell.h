//
//  ActionItemCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/18/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ActionItemCell : UITableViewCell {
    
}
@property (nonatomic, retain)IBOutlet UILabel *actionItemLabel;
@property (nonatomic, retain)IBOutlet UILabel *actionableAttendeesLabel;
@property (nonatomic, retain)IBOutlet UIButton *actionItemDetailButton;

@end
