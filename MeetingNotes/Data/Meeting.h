//
//  Meeting.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/12/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AgendaItem, Attendee;

@interface Meeting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isStarred;
@property (nonatomic, retain) NSSet* Attendees;
@property (nonatomic, retain) NSSet* AgendaItems;

- (void)addAttendeesObject:(Attendee *)value;
- (void)removeAttendeesObject:(Attendee *)value;
- (void)addAttendees:(NSSet *)value;
- (void)removeAttendees:(NSSet *)value;
- (void)addAgendaItemsObject:(AgendaItem *)value;
- (void)removeAgendaItemsObject:(AgendaItem *)value;
- (void)addAgendaItems:(NSSet *)value;
- (void)removeAgendaItems:(NSSet *)value;
- (int)getActionItemCount;

@end
