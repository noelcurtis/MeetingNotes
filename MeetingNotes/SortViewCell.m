//
//  SortViewCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/11/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "SortViewCell.h"


@implementation SortViewCell
@synthesize categoryLabel;
@synthesize categoryCountLabel;


-(void) setupCellWithCategory:(Category *)category{
    self.categoryLabel.text = category.name;
    self.categoryCountLabel.text = [NSString stringWithFormat:@"%d", [category.Meetings count]];
}

-(void)dealloc{
    [categoryLabel release];
    [categoryCountLabel release];
    [super dealloc];
}

@end
