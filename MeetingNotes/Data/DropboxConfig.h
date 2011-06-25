//
//  DropboxConfig.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/22/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DropboxConfig : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * folderName;

@end
