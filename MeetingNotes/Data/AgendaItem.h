//
//  AgendaItem.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/8/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActionItem, Meeting;

@interface AgendaItem : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSSet* ActionItems;
@property (nonatomic, retain) Meeting * Meeting;

- (void)addActionItemsObject:(ActionItem *)value;
- (void)removeActionItemsObject:(ActionItem *)value;
- (void)addActionItems:(NSSet *)value;
- (void)removeActionItems:(NSSet *)value;
- (NSString*)asString;
@end
