//
//  AgendaItemCell.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/12/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "AgendaItemCell.h"


@implementation AgendaItemCell
@synthesize agendaItemLabel;
@synthesize redArrow;

-(void) setupWithAgendaItem:(AgendaItem *)agendaItem{
    self.agendaItemLabel.text = agendaItem.title;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(void)dealloc{
    [agendaItemLabel release];
    [redArrow release];
    [super dealloc];
}

@end
