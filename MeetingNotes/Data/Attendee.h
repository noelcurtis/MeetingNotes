//
//  Attendee.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/8/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActionItem, Meeting;

@interface Attendee : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* ActionItems;
@property (nonatomic, retain) NSSet* Meetings;

- (void)addActionItemsObject:(ActionItem *)value;
- (void)removeActionItemsObject:(ActionItem *)value;
- (void)addActionItems:(NSSet *)value;
- (void)removeActionItems:(NSSet *)value;
- (void)addMeetingsObject:(Meeting *)value;
- (void)removeMeetingsObject:(Meeting *)value;
- (void)addMeetings:(NSSet *)value;
- (void)removeMeetings:(NSSet *)value;

@end
