//
//  Attendee.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/10/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActionItem, Meeting;

@interface Attendee : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) ActionItem * ActionItem;
@property (nonatomic, retain) Meeting * Meeting;

@end
