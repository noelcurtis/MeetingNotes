//
//  Category.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/15/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meeting;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* Meetings;

@end
