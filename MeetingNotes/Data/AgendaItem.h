//
//  AgendaItem.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/3/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActionItem, Meeting;

@interface AgendaItem : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Meeting * Meeting;
@property (nonatomic, retain) NSSet* ActionItems;

- (void)addActionItemsObject:(ActionItem *)value;
- (void)removeActionItemsObject:(ActionItem *)value;
@end
