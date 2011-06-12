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

-(void) setupWithAgendaItem:(AgendaItem *)agendaItem{
    
}

-(void)dealloc{
    [agendaItemLabel release];
    [super dealloc];
}

@end
