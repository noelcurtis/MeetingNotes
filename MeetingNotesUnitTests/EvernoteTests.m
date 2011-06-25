//
//  EvernoteTests.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/19/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.m"
#import "PersistantCoordinator.h"
#import "SharingServiceAdapter.h"

#if KW_TESTS_ENABLED

@interface EvernoteTests : SenTestCase

@end

@implementation EvernoteTests

-(void) testShouldSetupEvernoteSuccesfully{
    NSManagedObjectContext *moContext = [[PersistantCoordinator sharedCoordinator] managedObjectContext];
    [[SharingServiceAdapter sharedSharingService] setManagegObjectContext:moContext];
    EvernoteConfig* evernoteConfig = [[SharingServiceAdapter sharedSharingService] setupEvernoteWith:@"Meeting Notes" username:EVERNOTE_USER password:EVERNOTE_PASSWORD];
    [[PersistantCoordinator sharedCoordinator] teardown];
}
@end

#endif // #if KW_TESTS_ENABLED
