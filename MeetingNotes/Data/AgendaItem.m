//
//  AgendaItem.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/8/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "AgendaItem.h"
#import "ActionItem.h"
#import "Meeting.h"
#import "Attendee.h"

@implementation AgendaItem
@dynamic title;
@dynamic note;
@dynamic ActionItems;
@dynamic Meeting;

- (void)addActionItemsObject:(ActionItem *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ActionItems"] addObject:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeActionItemsObject:(ActionItem *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ActionItems"] removeObject:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addActionItems:(NSSet *)value {    
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ActionItems"] unionSet:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeActionItems:(NSSet *)value {
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ActionItems"] minusSet:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (NSString*)asString{
    NSString *agendaContents = [NSString stringWithFormat:@"Agenda Item: %@\r\n", self.title];
    
    agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"Notes: %@\r\n\r\n", self.note]];
    // print each agenda item
    for (ActionItem* actionItem in self.ActionItems) {
        // print each action item
        agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"Action Item: %@\r\n", actionItem.notes]];
        for (Attendee* attendee in actionItem.Attendees) {
            agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"%@ ",attendee.name]];
        }
        agendaContents = [agendaContents stringByAppendingString:@"\r\n"];
    }
    return agendaContents;
}


@end
