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
#import "KeychainItemWrapper.h"

@protocol SharingServiceAdapterDelegate;

@class EvernoteConfig;
@class DropboxConfig;

@interface SharingServiceAdapter : NSObject{
    
}
@property (nonatomic, retain) DBRestClient* restClient;
- (void) uploadMeetingToDropbox:(Meeting*) meeting;
+ (SharingServiceAdapter*) sharedSharingService;
- (void) setupDropboxSession;
@property (nonatomic, retain) DropboxConfig *sharedDropboxConfig;

#pragma mark - Keychain for evernote credentials
@property (nonatomic, retain) KeychainItemWrapper *evernoteKeychain;

#pragma mark - Evernote
- (void) setManagegObjectContext:(NSManagedObjectContext*) managedObjectContext;
- (EvernoteConfig *) sharedEvernoteConfiguration;
- (BOOL) isEvernoteConfigured;
- (EvernoteConfig*) setupEvernoteWith:(NSDictionary*) evernoteSetupParameters;
- (NSOperation*) setupEvernoteAsyncWith:(NSDictionary*) evernoteSetupParameters;
@property (nonatomic, assign) id<SharingServiceAdapterDelegate> sharingServiceAdapterDelegate;
- (void) uploadMeetingToEvernote:(id)meeting;
- (NSOperation*)uploadMeetingAsync:(Meeting*)meeting;
@end


@protocol SharingServiceAdapterDelegate
@optional
#pragma mark - evernote delegate methods
-(void) didFinishConfiguringEvernote;
-(void) didFailConfiguringEvernoteWithError:(NSError*)error;
-(void) didFinishUploadingToEvernote;
-(void) didFailUploadingToEvernote:(NSError*)error;
#pragma mark -dropbox delegate methods
-(void) didFinishUploadingToDropbox;
-(void) didFailUploadingToDropbox:(NSError*)error;
@end