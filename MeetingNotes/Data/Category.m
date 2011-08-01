//
//  Category.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/15/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "Category.h"
#import "Meeting.h"
#import "MeetingNotesAppDelegate.h"

#define MAXLABEL_COUNT  20

@implementation Category
@dynamic name;
@dynamic Meetings;
@dynamic labelId;

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


+ (NSNumber*)findNextAvailableLabelId{
    // get all the categories
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category"
                                              inManagedObjectContext:((MeetingNotesAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *allCategories = [((MeetingNotesAppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        // get the already take label ids
        NSMutableArray *takenLabelIds = [[NSMutableArray alloc] init];
        for (Category *category in allCategories) {
            [takenLabelIds addObject:category.labelId];
        }
        // find the label that is taken the least and return that one
        if([takenLabelIds count]>0){
            NSNumber *labelTakenTheLeastCount = nil;
            NSNumber *labelTakenTheLeast = nil;
            for (int currentLabel=1; currentLabel<=MAXLABEL_COUNT; currentLabel++) {
                NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF == %@",[NSNumber numberWithInt:currentLabel]];
                NSArray *foundLabelIds = [takenLabelIds filteredArrayUsingPredicate:sPredicate];
                if(labelTakenTheLeast && [[NSNumber numberWithUnsignedInteger:[foundLabelIds count]] compare:labelTakenTheLeastCount] == NSOrderedAscending ){
                    labelTakenTheLeast = [NSNumber numberWithInt:currentLabel];
                    labelTakenTheLeastCount = [NSNumber numberWithInt:[foundLabelIds count]];
                }else if(!labelTakenTheLeast){
                    labelTakenTheLeast = [NSNumber numberWithInt:currentLabel];
                    labelTakenTheLeastCount = [NSNumber numberWithInt:[foundLabelIds count]];
                }
            }
            return labelTakenTheLeast;
        }else{
            // no label ids are taken so return 1
            [takenLabelIds release];
            return [NSNumber numberWithInt:1];
        }
        [takenLabelIds release];
        NSException *exception = [NSException exceptionWithName:@"CategoriesException" reason:@"No more labels exist you have tried to create to many categories." userInfo:nil];
        @throw exception;
    }else{
        NSException *exception = [NSException exceptionWithName:@"CategoriesException" reason:@"Error fetching Categories." userInfo:nil];
        @throw exception;
    }
}


@end
