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
@synthesize categoryImageView;


-(void) setupCellWithCategory:(Category *)category{
    self.categoryLabel.text = category.name;
    if ([category.Meetings count] > 0) {
        [self.categoryImageView setHidden:NO];
        [self.categoryCountLabel setHidden:NO];
        NSString *categoryLabelImage = [NSString stringWithFormat:@"cat_num_%@", category.labelId];
        [self.categoryImageView setImage:[UIImage imageNamed:categoryLabelImage]];
        self.categoryCountLabel.text = [NSString stringWithFormat:@"%d", [category.Meetings count]];
    }else{
        [self.categoryImageView setHidden:YES];
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
