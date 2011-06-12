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


-(void)dealloc{
    [categoryLabel release];
    [categoryCountLabel release];
    [super dealloc];
}

@end
