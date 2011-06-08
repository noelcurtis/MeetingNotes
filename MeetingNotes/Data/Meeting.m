//
//  Meeting.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/26/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "Meeting.h"
#import "AgendaItem.h"
#import "Attendee.h"


@implementation Meeting
@dynamic location;
@dynamic startDate;
@dynamic endDate;
@dynamic name;
@dynamic Attendees;
@dynamic AgendaItems;

- (void)addAttendeesObject:(Attendee *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Attendees"] addObject:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAttendeesObject:(Attendee *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Attendees"] removeObject:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAttendees:(NSSet *)value {    
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Attendees"] unionSet:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAttendees:(NSSet *)value {
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Attendees"] minusSet:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAgendaItemsObject:(AgendaItem *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"AgendaItems"] addObject:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAgendaItemsObject:(AgendaItem *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"AgendaItems"] removeObject:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAgendaItems:(NSSet *)value {    
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"AgendaItems"] unionSet:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAgendaItems:(NSSet *)value {
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"AgendaItems"] minusSet:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (int)getActionItemCount{
    int actionItemCount = 0;
    for (AgendaItem *agendaItem in [self AgendaItems]) {
        actionItemCount += [agendaItem.ActionItems count];
    }
    return actionItemCount;
}


@end
