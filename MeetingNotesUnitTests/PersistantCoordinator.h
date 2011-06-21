//
//  PersistantCoordinator.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/20/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersistantCoordinator : NSObject {
    
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void) teardown;

+(PersistantCoordinator*)sharedCoordinator;
-(NSArray*) getAllMeetings;

@end
