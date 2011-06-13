//
//  AgendaItemCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/12/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgendaItem.h"


@interface AgendaItemCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UILabel *agendaItemLabel;
@property (nonatomic, retain) IBOutlet UIImageView *redArrow;
-(void) setupWithAgendaItem:(AgendaItem*) agendaItem;

@end
