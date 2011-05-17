//
//  Meeting.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/10/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AgendaItem, Attendee;

@interface Meeting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet* AgendaItems;
@property (nonatomic, retain) NSSet* Attendees;

@end
