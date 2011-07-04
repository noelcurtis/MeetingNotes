//
//  Meeting.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/15/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "Meeting.h"
#import "AgendaItem.h"
#import "Attendee.h"
#import "Category.h"
#import "ActionItem.h"


@implementation Meeting
@dynamic location;
@dynamic endDate;
@dynamic startDate;
@dynamic isStarred;
@dynamic name;
@dynamic Attendees;
@dynamic AgendaItems;
@dynamic Category;

- (void)addAttendeesObject:(Attendee *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Attendees"] addObject:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAttendeesObject:(Attendee *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Attendees"] removeObject:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAttendees:(NSSet *)value {    
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Attendees"] unionSet:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAttendees:(NSSet *)value {
    [self willChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Attendees"] minusSet:value];
    [self didChangeValueForKey:@"Attendees" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAgendaItemsObject:(AgendaItem *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"AgendaItems"] addObject:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAgendaItemsObject:(AgendaItem *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"AgendaItems"] removeObject:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAgendaItems:(NSSet *)value {    
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"AgendaItems"] unionSet:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAgendaItems:(NSSet *)value {
    [self willChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"AgendaItems"] minusSet:value];
    [self didChangeValueForKey:@"AgendaItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (int)getActionItemCount{
    int actionItemCount = 0;
    for (AgendaItem *agendaItem in [self AgendaItems]) {
        actionItemCount += [agendaItem.ActionItems count];
    }
    return actionItemCount;
}

- (NSString*)asString{
    
    NSString *meetingContents = [NSString stringWithFormat:@"Meeting Name:%@\r\nLocation:%@\r\n\r\n", self.name, self.location];
    meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"Start Date:%@\r\nEnd Date:%@\r\n\r\n", [self.startDate description], [self.endDate description]]];
    
    meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"Attendees:"]];
    
	for (Attendee* attendee in self.Attendees) {
        meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"%@ ",attendee.name]];
    }
    
    [meetingContents stringByAppendingString:[NSString stringWithFormat:@"\r\n\r\n"]];
    for (AgendaItem* agendaItem in self.AgendaItems) {
        meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"%@ ",[agendaItem asString]]];
    }
    return meetingContents;
}

-(NSString*) fileName{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.txt",self.name, [dateFormatter  stringFromDate:self.startDate]];
    return fileName;
}
/*
-(NSString*) asXhtml{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MeetingNotes" ofType:@"html"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    return contents;
}
*/
-(NSString*) asXhtml{
    // get a date formatter ready
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // create a string for the attendees
    NSString *attendeesString = [[NSString alloc] init];
	for (Attendee* attendee in self.Attendees) {
        attendeesString = [attendeesString stringByAppendingString:[NSString stringWithFormat:@"%@ ",attendee.name]];
    }
    
    
    NSMutableString *meetingAsEvernote = [[NSMutableString alloc] init];
    // header
    [meetingAsEvernote setString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [meetingAsEvernote appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"];
    [meetingAsEvernote appendString:@"<en-note style=\"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;\">"];
    [meetingAsEvernote appendString:@"<table border=\"0\" cellpadding=\"4\" width=\"600\">"];
    [meetingAsEvernote appendString:@"<tbody>"];
    
    // meeting title
    [meetingAsEvernote appendString:@"<tr>"];
    [meetingAsEvernote appendString:@"<td height=\"40\" align=\"center\" bgcolor=\"#101D17\">"];
    [meetingAsEvernote appendString:@"<h1>"];
    [meetingAsEvernote appendString:[NSString stringWithFormat:@"<strong><font face=\"Arial,Helvetica,sans-serif\" size=\"6\" color=\"white\">%@</font></strong>", self.name]];
    [meetingAsEvernote appendString:@"</h1>"];
    [meetingAsEvernote appendString:@"</td>"];
    [meetingAsEvernote appendString:@"</tr>"];
    // date section
    [meetingAsEvernote appendString:@"<tr>"];
    [meetingAsEvernote appendString:@"<td height=\"25\" align=\"center\" bgcolor=\"#101D17\">"];
    [meetingAsEvernote appendString:@"<font face=\"Arial,Helvetica,sans-serif\" size=\"2\" color=\"white\">"];
    [meetingAsEvernote appendString:[NSString stringWithFormat:@"<strong>Start Date:</strong> %@ <strong>End Date:</strong> %@", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]]];
    [meetingAsEvernote appendString:@"</font>"];
    [meetingAsEvernote appendString:@"</td>"];
    [meetingAsEvernote appendString:@"</tr>"];
    
    // attendees section
    if (attendeesString && ![attendeesString isEqualToString:@""]) {
        [meetingAsEvernote appendString:@"<tr>"];
        [meetingAsEvernote appendString:@"<td height=\"50\" align=\"center\">"];
        [meetingAsEvernote appendString:@"<font face=\"Arial,Helvetica,sans-serif\" size=\"2\">"];
        [meetingAsEvernote appendString:[NSString stringWithFormat:@"<strong>Attendees:</strong> %@",attendeesString]];
        [meetingAsEvernote appendString:@"</font>"];
        [meetingAsEvernote appendString:@"</td>"];
        [meetingAsEvernote appendString:@"</tr>"];
    }
    // agenda items section
    for (AgendaItem *agendaItem in self.AgendaItems) {
        [meetingAsEvernote appendString:[agendaItem asXhtml]];
    }
    // close everything
    [meetingAsEvernote appendString:@"</tbody>"];
    [meetingAsEvernote appendString:@"</table>"];
    [meetingAsEvernote appendString:@"</en-note>"];
    [meetingAsEvernote appendString:@""];
      
    NSLog(@"%@",meetingAsEvernote);
    return meetingAsEvernote;
}

@end
