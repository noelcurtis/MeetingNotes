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
    NSString *meetingContents = [NSString stringWithFormat:@"Meeting Name:%@\nLocation:%@\n\n", self.name, self.location];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"Start Date:%@\nEnd Date:%@\n\n", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]]];
    
    NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:[self.Attendees count]];
    for (Attendee* attendee in self.Attendees) {
        [attendeeNames addObject:attendee.name];
    }
    // create a string for the attendees
    NSString *attendeesString = [[NSArray arrayWithArray:attendeeNames] componentsJoinedByString:@", "];

    if(attendeesString && ![attendeesString isEqualToString:@""]){
        meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"Attendees: "]];
        meetingContents = [meetingContents stringByAppendingString:attendeesString];
        meetingContents = [meetingContents stringByAppendingString:@"\n\n"];
    }
	
    for (AgendaItem* agendaItem in self.AgendaItems) {
        meetingContents = [meetingContents stringByAppendingString:[NSString stringWithFormat:@"%@",[agendaItem asString]]];
    }
    return meetingContents;
}

-(NSString*) fileName{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *startDateForMeeting = [[dateFormatter stringFromDate:self.startDate] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.txt",self.name, startDateForMeeting];
    return fileName;
}
/*
-(NSString*) asXhtml{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MeetingNotes" ofType:@"html"];
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    return contents;
}
*/

-(NSString*) asEvernote{
    NSMutableString *meetingAsEvernote = [[[NSMutableString alloc] init] autorelease];
    // header
    [meetingAsEvernote setString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [meetingAsEvernote appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">"];
    [meetingAsEvernote appendString:@"<en-note style=\"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;\">"];
    [meetingAsEvernote appendString:@"<table border=\"0\" cellpadding=\"4\" width=\"600\">"];
    [meetingAsEvernote appendString:@"<tbody>"];
    
    [meetingAsEvernote appendString:[self asHtmlTable]];
    
    // close everything
    [meetingAsEvernote appendString:@"</tbody>"];
    [meetingAsEvernote appendString:@"</table>"];
    [meetingAsEvernote appendString:@"</en-note>"];
    [meetingAsEvernote appendString:@""];
    
    NSLog(@"%@",meetingAsEvernote);
    return meetingAsEvernote;
}


-(NSString *)asHtmlTable{
    // get a date formatter ready
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:[self.Attendees count]];
    for (Attendee* attendee in self.Attendees) {
        [attendeeNames addObject:attendee.name];
    }
    // create a string for the attendees
    NSString *attendeesString = [[NSArray arrayWithArray:attendeeNames] componentsJoinedByString:@", "];
    
    NSMutableString *meetingAsHtmlTable = [[[NSMutableString alloc] init] autorelease];
    // start the table
    [meetingAsHtmlTable appendString:@"<table border=\"0\" cellpadding=\"4\" width=\"600\">"];
    [meetingAsHtmlTable appendString:@"<tbody>"];
    
    // meeting title
    [meetingAsHtmlTable appendString:@"<tr>"];
    [meetingAsHtmlTable appendString:@"<td height=\"30\" align=\"center\" bgcolor=\"#101D17\">"];
    [meetingAsHtmlTable appendString:[NSString stringWithFormat:@"<strong><font face=\"Arial,Helvetica,sans-serif\" size=\"6\" color=\"white\">%@</font></strong>", self.name]];
    [meetingAsHtmlTable appendString:@"</td>"];
    [meetingAsHtmlTable appendString:@"</tr>"];
    // date section
    [meetingAsHtmlTable appendString:@"<tr>"];
    [meetingAsHtmlTable appendString:@"<td height=\"25\" align=\"center\" bgcolor=\"#101D17\">"];
    [meetingAsHtmlTable appendString:@"<font face=\"Arial,Helvetica,sans-serif\" size=\"2\" color=\"white\">"];
    [meetingAsHtmlTable appendString:[NSString stringWithFormat:@"<strong>Start Date:</strong> %@ <strong>End Date:</strong> %@", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]]];
    [meetingAsHtmlTable appendString:@"</font>"];
    [meetingAsHtmlTable appendString:@"</td>"];
    [meetingAsHtmlTable appendString:@"</tr>"];
    
    // attendees section
    if (attendeesString && ![attendeesString isEqualToString:@""]) {
        [meetingAsHtmlTable appendString:@"<tr>"];
        [meetingAsHtmlTable appendString:@"<td height=\"50\" align=\"center\">"];
        [meetingAsHtmlTable appendString:@"<font face=\"Arial,Helvetica,sans-serif\" size=\"2\">"];
        [meetingAsHtmlTable appendString:[NSString stringWithFormat:@"<strong>Attendees:</strong> %@",attendeesString]];
        [meetingAsHtmlTable appendString:@"</font>"];
        [meetingAsHtmlTable appendString:@"</td>"];
        [meetingAsHtmlTable appendString:@"</tr>"];
    }
    // agenda items section
    for (AgendaItem *agendaItem in self.AgendaItems) {
        [meetingAsHtmlTable appendString:[agendaItem asXhtml]];
    }
    // close everything
    [meetingAsHtmlTable appendString:@"</tbody>"];
    [meetingAsHtmlTable appendString:@"</table>"];
    [meetingAsHtmlTable appendString:@""];
    
    NSLog(@"%@",meetingAsHtmlTable);
    return meetingAsHtmlTable;

}

//TODO: handle errors for reading files
-(NSString*) asHtmlEmail{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HtmlEmailBoilerplateHeader" ofType:@"html"];
    NSString *htmlBoilerplateHeader = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    path = [[NSBundle mainBundle] pathForResource:@"HtmlEmailBoilerplateFooter" ofType:@"html"];
    NSString *htmlBoilerplateFooter = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    
    NSString *meetingAsHtmlEmail = [NSString stringWithFormat:@"%@ %@ %@", htmlBoilerplateHeader, [self asHtmlTable], htmlBoilerplateFooter];
    NSLog(@"%@", meetingAsHtmlEmail);
    return meetingAsHtmlEmail;
}

@end
