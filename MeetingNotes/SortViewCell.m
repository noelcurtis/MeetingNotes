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
    if ([category.Meetings count] > 0) {
        [self.categoryCountLabel setHidden:NO];
        self.categoryCountLabel.text = [NSString stringWithFormat:@"%d", [category.Meetings count]];
    }else{
        [self.categoryCountLabel setHidden:YES];
    }
    
}

-(void) setupCellWithString:(NSString *)string{
    [self.categoryCountLabel setHidden:YES];
    self.categoryLabel.text = string;
}

-(void)dealloc{
    [categoryLabel release];
    [categoryCountLabel release];
    [super dealloc];
}

@end
