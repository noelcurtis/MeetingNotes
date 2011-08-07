//
//  AgendaItem.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/8/11.
//  Copyright (c) 2011 EMC Corporation. All rights reserved.
//

#import "AgendaItem.h"
#import "ActionItem.h"
#import "Meeting.h"
#import "Attendee.h"

@implementation AgendaItem
@dynamic title;
@dynamic note;
@dynamic ActionItems;
@dynamic Meeting;

- (void)addActionItemsObject:(ActionItem *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ActionItems"] addObject:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeActionItemsObject:(ActionItem *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ActionItems"] removeObject:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addActionItems:(NSSet *)value {    
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ActionItems"] unionSet:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeActionItems:(NSSet *)value {
    [self willChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ActionItems"] minusSet:value];
    [self didChangeValueForKey:@"ActionItems" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (NSString*)asString{
    NSString *agendaContents = [NSString stringWithFormat:@"Agenda Item: %@\n", self.title];
    
    agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"Notes: %@\n\n", self.note]];
    // print each agenda item
    for (ActionItem* actionItem in self.ActionItems) {
        // print each action item
        agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"Action Item: %@\n", actionItem.notes]];
        
        NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:[actionItem.Attendees count]];
        for (Attendee* attendee in actionItem.Attendees) {
            [attendeeNames addObject:attendee.name];
        }
        // create a string for the attendees
        NSString *attendeesString = [[NSArray arrayWithArray:attendeeNames] componentsJoinedByString:@", "];
        if(attendeesString && ![attendeesString isEqualToString:@""]){
            agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"(%@)",attendeesString]];
        }
        agendaContents = [agendaContents stringByAppendingString:@"\n"];
    }
    agendaContents = [agendaContents stringByAppendingString:@"\n"];
    return agendaContents;
}

-(NSString*) asXhtml{
    NSMutableString *agendaItem = [[NSMutableString alloc] init];
    [agendaItem appendString:@"<tr>"];
    [agendaItem appendString:@"<td align=\"left\" bgcolor=\"#5BAA99\">"];
    [agendaItem appendString:@"<font face=\"Arial,Helvetica,sans-serif\">"];
    [agendaItem appendString:[NSString stringWithFormat:@"<b><font color=\"#252525\" size = \"3\">%@:</font></b>",self.title]];
    [agendaItem appendString:@"</font>"];
    [agendaItem appendString:@"</td>"];
    [agendaItem appendString:@"</tr>"];
    // notes section
    [agendaItem appendString:@"<tr>"];
    [agendaItem appendString:@"<td align=\"left\">"];
    [agendaItem appendString:@"<font face=\"Arial,Helvetica,sans-serif\" size=\"2\">"];
    [agendaItem appendString:[NSString stringWithFormat:@"<strong>Notes: </strong>%@",self.note]];
    [agendaItem appendString:@"</font>"];
    [agendaItem appendString:@"</td>"];
    [agendaItem appendString:@"</tr>"];
    
    // agenda items
    [agendaItem appendString:@"<tr>"];
    [agendaItem appendString:@"<td align=\"left\">"];
    [agendaItem appendString:@"<font face=\"Arial,Helvetica,sans-serif\" size=\"2\">"];
    // start a list
    [agendaItem appendString:@"<dl>"];
    for (ActionItem *actionItem in self.ActionItems) {
        [agendaItem appendString:@"<dt>"];
        [agendaItem appendString:[NSString stringWithFormat:@"<strong>%@:</strong>", actionItem.notes]];
        
        // attendees for the action item
        // create a string for the attendees
        NSMutableArray *attendeeNames = [NSMutableArray arrayWithCapacity:[actionItem.Attendees count]];
        for (Attendee* attendee in actionItem.Attendees) {
            [attendeeNames addObject:attendee.name];
        }
        // create a string for the attendees
        NSString *attendeesString = [[NSArray arrayWithArray:attendeeNames] componentsJoinedByString:@", "];
        if(attendeesString && ![attendeesString isEqualToString:@""]){
            [agendaItem appendString:[NSString stringWithFormat:@"<dd>%@</dd>", attendeesString]];
        }
        [agendaItem appendString:@"</dt>"];
    }
    [agendaItem appendString:@"</dl>"];
    [agendaItem appendString:@"</font>"];
    [agendaItem appendString:@"</td>"];
    [agendaItem appendString:@"</tr>"];
    return agendaItem;
}


@end
