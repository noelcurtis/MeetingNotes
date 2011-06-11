//
//  EventKitIntegrator.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/10/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface EventKitIntegrator : NSObject {
    
}
// use to get the event list of all the events in the users calender.
-(NSMutableArray*)eventList;

@end
