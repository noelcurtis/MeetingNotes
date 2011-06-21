//
//  EvernoteTests.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/19/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "Kiwi.h"
#import "ENManager.h"
#import "Meeting.h"
#import "PersistantCoordinator.h"

SPEC_BEGIN(EvernoteTests)

describe(@"Creates a connection to evernote", ^{
    it(@"it gets notebooks", ^{
        // Try changing should to shouldNot, and vice-versa to see
        // failures in action.
        [[ENManager sharedInstance] setUsername:EVERNOTE_USER];
        [[ENManager sharedInstance] setPassword:EVERNOTE_PASSWORD];
        id notebooks = [[ENManager sharedInstance] notebooks];
        [notebooks shouldNotBeNil];
    });
    
    it(@"it gets default notebook", ^{
        // Try changing should to shouldNot, and vice-versa to see
        // failures in action.
        [[ENManager sharedInstance] setUsername:EVERNOTE_USER];
        [[ENManager sharedInstance] setPassword:EVERNOTE_PASSWORD];
        EDAMNotebook *defaultNoteBook = [[ENManager sharedInstance] defaultNotebook];
        [defaultNoteBook shouldNotBeNil];    
    });
});

SPEC_END