//
//  Attendee.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/2/11.
//  Copyright (c) 2011 Noel Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActionItem;

@interface Attendee : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) ActionItem * ActionItem;

@end
