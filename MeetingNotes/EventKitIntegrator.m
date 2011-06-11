//
//  EventKitIntegrator.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/10/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "EventKitIntegrator.h"

@interface EventKitIntegrator()
@property (nonatomic, retain) EKEventStore *eventStore;
-(NSArray *)fetchEventsForToday;
@end

@implementation EventKitIntegrator

@synthesize eventStore;

- (id)init {
    self = [super init];
    if (self) {
        // Initialize an event store object with the init method. Initilize the array for events.
        self.eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

-(NSMutableArray*)eventList{
    NSMutableArray *eventList = [[NSMutableArray alloc] initWithArray:[self fetchEventsForToday]];
    //[eventList arrayByAddingObjectsFromArray:[self fetchEventsForToday]];
    return eventList;
}

// Fetching events happening in the next 24 hours with a predicate, from all the calenders 
- (NSArray *)fetchEventsForToday {
	
	NSDate *startDate = [[NSDate alloc] init];
	
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400];
	
	// Create the predicate. Pass it the default calendar.
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate 
                                                                    calendars:[self.eventStore calendars]]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
	return events;
}


// dealloc everything
-(void)dealloc{
    [eventStore release];
    [super dealloc];
}

@end
