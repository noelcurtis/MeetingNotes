//
//  EvernoteConfig.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/22/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EvernoteConfig : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * notebookName;
@property (nonatomic, retain) NSString * notebookGuid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@end
