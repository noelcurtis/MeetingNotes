//
//  Meeting.h
//  MeetingNotes
//
//  Created by Noel Curtis on 5/2/11.
//  Copyright (c) 2011 Noel Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AgendaItem;

@interface Meeting : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet* AgendaItems;

- (void)addAgendaItemsObject:(AgendaItem *)value;

@end
