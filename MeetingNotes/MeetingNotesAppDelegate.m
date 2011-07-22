//
//  MeetingNotesAppDelegate.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "MeetingNotesAppDelegate.h"
#import "SortRootViewController.h"
#import "SortDetailViewController.h"
#import "DropboxSDK.h"
#import "ENManager.h"
#import "PersistantCoordinator.h"
#import "SharingServiceAdapter.h"

@implementation MeetingNotesAppDelegate


@synthesize window=_window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize sortDVController, sortRVController, splitViewController;
//@synthesize dropboxNavigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [[SharingServiceAdapter sharedSharingService] setManagegObjectContext:self.managedObjectContext];
    [[SharingServiceAdapter sharedSharingService] setupDropboxSession];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	backgroundImageView.image = [UIImage imageNamed:@"dark_noise_bg"];
    
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.view.opaque = NO;
    [splitViewController.view setBackgroundColor:[UIColor clearColor]];
	sortDVController = [[SortDetailViewController alloc] init];
    sortDVController.managedObjectContext =  self.managedObjectContext;
    splitViewController.delegate = sortDVController;
	
	sortRVController = [[SortRootViewController alloc] initWithNibName:@"SortRootViewController" bundle:nil];
	sortRVController.dvController = sortDVController;
    sortRVController.managedObjectContext = self.managedObjectContext;
	sortDVController.rvController = sortRVController;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sortRVController];
    nav.view.backgroundColor = [UIColor clearColor];
    nav.view.opaque = NO;
    UIImageView *backgroundImageViewNav = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, 276, 705)];
	backgroundImageViewNav.image = [UIImage imageNamed:@"cat_view_bg"];
    [nav.view insertSubview:backgroundImageViewNav atIndex:0];
    [backgroundImageViewNav release];
    splitViewController.viewControllers = [NSArray arrayWithObjects:nav,sortDVController,nil];
	[self.window addSubview:splitViewController.view];
    [self.window insertSubview:backgroundImageView belowSubview:splitViewController.view];
	NSLog(@"Application has launched, managed object context has been set, main split view controllers have been displayed.");
    [nav release];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)awakeFromNib
{
    
     //Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     //self.<#View controller#>.managedObjectContext = self.managedObjectContext;
}

- (void)dealloc
{
    [sortDVController release];
    [sortRVController release];
    [splitViewController release];
    [operationQueue release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_window release];
    [super dealloc];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MeetingNotes" withExtension:@"momd"];
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
    
    /*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"SeedMeetingNotes" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}*/

    //NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MeetingNotes.sqlite"];
    
    NSError *error = nil;
    //NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
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
    
    NSString *storePath = [[self applicationDocumentsDirectoryAsString] stringByAppendingPathComponent: @"MeetingNotes.sqlite"];
    // setup data protection on the database
    if([self isRunningiOS4OrBetter])
    {
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:storePath error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
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

#pragma mark - Shared operation queue
- (NSOperationQueue *)operationQueue {
    if (operationQueue == nil) {
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return operationQueue;
}

#pragma mark - IOS 4 check
-(BOOL) isRunningiOS4OrBetter{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSInteger majorSystemVersion = 3;
    if (systemVersion != nil && [systemVersion length] > 0) { //Can't imagine it would be empty, but.
        NSString *firstCharacter = [systemVersion substringToIndex:1];
        majorSystemVersion = [firstCharacter integerValue];
    }
    if(majorSystemVersion >= 4)
        return YES;
    else
        return NO;
        
}

@end
