//
//  SharingServiceAdapter.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/21/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"
#import "DropboxSDK.h"
#import "ENManager.h"

@protocol SharingServiceAdapterDelegate;

@class EvernoteConfig;
@class DropboxConfig;

@interface SharingServiceAdapter : NSObject{
    
}
- (void) uploadMeetingToDropbox:(Meeting*) meeting;
- (void) uploadMeetingToEvernote:(Meeting*)meeting;
+ (SharingServiceAdapter*) sharedSharingService;
- (void) setupDropboxSession;
@property (nonatomic, retain) DropboxConfig *sharedDropboxConfig;


#pragma mark - Evernote
- (void) setManagegObjectContext:(NSManagedObjectContext*) managedObjectContext;
- (EvernoteConfig *) sharedEvernoteConfiguration;
- (BOOL) isEvernoteConfigured;
- (EvernoteConfig*) setupEvernoteWith:(NSString *)meetingNotebookName username:(NSString *)username password:(NSString*) password;
@property (nonatomic, assign) id<SharingServiceAdapterDelegate> sharingServiceAdapterDelegate;
@end


@protocol SharingServiceAdapterDelegate

-(void) didStartConfiguringEvernote;
-(void) didFinishConfiguringEvernote;
-(void) didFailConfiguringEvernoteWithError:(NSError*)error;

@end