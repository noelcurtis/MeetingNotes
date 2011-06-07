//
//  FileHandlerController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/4/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meeting.h"
#import "DropboxSDK.h"

@interface FileHandlerController : NSObject {
    
}

@property(nonatomic, retain) DBRestClient* restClient;
-(void)exportMeetingToFile:(Meeting*) meeting;
@end
