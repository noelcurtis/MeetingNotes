//
//  ModelTests.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/20/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "Kiwi.h"
#import "ENManager.h"
#import "Meeting.h"
#import "PersistantCoordinator.h"
#import "SharingServiceAdapter.h"

SPEC_BEGIN(ModelTests)

describe(@"Should setup core data stack", ^{
    it(@"Should get all meetings in the store", ^{
        NSArray *meetings = [[PersistantCoordinator sharedCoordinator] getAllMeetings];
        SharingServiceAdapter *share = [[SharingServiceAdapter alloc] init];
        [share setupDropboxSession];
        for(Meeting *meeting in meetings){
            NSLog(@"meeting name=%@", meeting.name);
            [share uploadMeetingToDropbox:meeting];
        }
        [meetings shouldNotBeNil];
        [[PersistantCoordinator sharedCoordinator] teardown];
    });
});

SPEC_END