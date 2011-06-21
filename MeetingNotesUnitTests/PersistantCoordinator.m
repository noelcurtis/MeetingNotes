//
//  PersistantCoordinator.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/20/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "PersistantCoordinator.h"

@interface PersistantCoordinator()
- (NSURL *)applicationDocumentsDirectory;
- (NSString *)applicationDocumentsDirectoryAsString;
@end

@implementation PersistantCoordinator
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

static PersistantCoordinator *_sharedCoordinator;


- (id)init {
    self = [super init];
    return self;
}

+(id)alloc
{
	@synchronized([PersistantCoordinator class]){
		NSAssert(_sharedCoordinator == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedCoordinator = [super alloc];
		return _sharedCoordinator;
	}
    
	return nil;
}

+ (PersistantCoordinator*) sharedCoordinator{
    @synchronized([PersistantCoordinator class]){
        if(!_sharedCoordinator){
            [[self alloc] init];
            return _sharedCoordinator;
        }else{
            return _sharedCoordinator;
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    //NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MeetingNotes" withExtension:@"momd"];
    //NSURL *modelURL = [NSURL URLWithString:@"/Users/noelcurtis/Library/Application Support/iPhone Simulator/User/Documents/MeetingNotes.momd/"];
    NSURL *modelURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/MeetingNotesUnitTests/Sandbox/MeetingNotes.momd/",[[NSFileManager defaultManager] currentDirectoryPath]]];    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
     //Set up the store.
	 //For the sake of illustration, provide a pre-populated default store.
	 NSString *storePath = [NSString stringWithFormat:@"%@/MeetingNotesUnitTests/Sandbox/MeetingNotes.sqlite",[[NSFileManager defaultManager] currentDirectoryPath]];
     // If the expected store doesn't exist, copy the default store.
     if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
         NSString *defaultStorePath = [NSString stringWithFormat:@"%@/MeetingNotes/SeedMeetingNotes.sqlite",[[NSFileManager defaultManager] currentDirectoryPath]];  
         //@"/Users/noelcurtis/Workspace/iPad/MeetingNotes/MeetingNotes/SeedMeetingNotes.sqlite";
         NSLog(@"%@ current dir",[[NSFileManager defaultManager] currentDirectoryPath]);
         if (defaultStorePath) {
             [[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
         }
     }
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectoryAsString {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


-(void) teardown{
    NSString *storePath = [NSString stringWithFormat:@"%@/MeetingNotesUnitTests/Sandbox/MeetingNotes.sqlite",[[NSFileManager defaultManager] currentDirectoryPath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if ([fileManager fileExistsAtPath:storePath]) {
        NSError **error;
        [fileManager removeItemAtPath:storePath error:error];
        if(!error){
            NSLog(@"Error removing .sqlite %@", error);
        }
    }
}

-(NSArray*) getAllMeetings{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meeting"
                                              inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSError *error;
    NSArray *meetings = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if(!error){
        NSLog(@"Error getting meetings %@", [error userInfo]);
    }
    return meetings;
}

@end
