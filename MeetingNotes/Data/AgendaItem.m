//
//  AgendaItem.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/3/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "AgendaItem.h"
#import "ActionItem.h"
#import "Meeting.h"


@implementation AgendaItem
@dynamic note;
@dynamic title;
@dynamic Meeting;
@dynamic ActionItems;


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


@end
