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

@interface SharingServiceAdapter : NSObject{
    
}
- (void) uploadMeetingToDropbox:(Meeting*) meeting;
- (void) uploadMeetingToEvernote:(Meeting*)meeting;
+ (SharingServiceAdapter*) sharedSharingService;
- (void) setupDropboxSession;
@end
