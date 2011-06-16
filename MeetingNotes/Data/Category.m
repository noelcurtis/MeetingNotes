//
//  Category.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/15/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "Category.h"
#import "Meeting.h"


@implementation Category
@dynamic name;
@dynamic Meetings;

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
