//
//  ActionItem.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/2/11.
//  Copyright (c) 2011 Noel Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AgendaItem, Attendee;

@interface ActionItem : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) AgendaItem * AgendaItem;
@property (nonatomic, retain) NSSet* Attendees;

- (void)addAttendeesObject:(Attendee *)value;
- (void)removeAttendeesObject:(Attendee *)value;
- (void)addAttendees:(NSSet *)value;
- (void)removeAttendees:(NSSet *)value;

@end
