//
//  Attendee.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/8/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "Attendee.h"
#import "ActionItem.h"
#import "Meeting.h"


@implementation Attendee
@dynamic email;
@dynamic name;
@dynamic ActionItems;
@dynamic Meetings;

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


- (void)addMeetingsObject:(Meeting *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Meetings"] addObject:value];
    [self didChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMeetingsObject:(Meeting *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Meetings"] removeObject:value];
    [self didChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMeetings:(NSSet *)value {    
    [self willChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Meetings"] unionSet:value];
    [self didChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMeetings:(NSSet *)value {
    [self willChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Meetings"] minusSet:value];
    [self didChangeValueForKey:@"Meetings" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
