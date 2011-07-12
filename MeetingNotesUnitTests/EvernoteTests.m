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
#import "Meeting.h"

#if KW_TESTS_ENABLED

@interface EvernoteTests : SenTestCase

@end

@implementation EvernoteTests
/*
-(void) testShouldSetupEvernoteSuccesfully{
    NSManagedObjectContext *moContext = [[PersistantCoordinator sharedCoordinator] managedObjectContext];
    [[SharingServiceAdapter sharedSharingService] setManagegObjectContext:moContext];
    [[SharingServiceAdapter sharedSharingService] setupEvernoteWith:@"Meeting Notes" username:EVERNOTE_USER password:EVERNOTE_PASSWORD];
    [[PersistantCoordinator sharedCoordinator] teardown];
}*/

-(void) testShouldSendMeetingToEvernote{
    NSManagedObjectContext *moContext = [[PersistantCoordinator sharedCoordinator] managedObjectContext];
    [[SharingServiceAdapter sharedSharingService] setManagegObjectContext:moContext];
    //[[SharingServiceAdapter sharedSharingService] setupEvernoteWith:@"Meeting Notes Test" username:EVERNOTE_USER password:EVERNOTE_PASSWORD];
    NSArray *meetings = [[PersistantCoordinator sharedCoordinator] getAllMeetings];
    NSLog(@"Sharing meeting %@", [meetings objectAtIndex:0]);
    [[SharingServiceAdapter sharedSharingService] uploadMeetingToEvernote:[meetings objectAtIndex:0]];
    NSLog(@"Meeting uploaded to Evernote");
    [[PersistantCoordinator sharedCoordinator] teardown];
}

@end

#endif // #if KW_TESTS_ENABLED
