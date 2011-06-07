//
//  FileHandlerController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/4/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "FileHandlerController.h"
#import "Meeting.h"
#import "ActionItem.h"
#import "Attendee.h"
#import "AgendaItem.h"
#import "DropboxSDK.h"


@interface FileHandlerController() <DBRestClientDelegate>
-(void)writeToFile:(Meeting*)meeting atPath:(NSString*) newFilePath;
-(void)writeAgendaItem:(AgendaItem*)agendaItem toFilePath:(NSString*)filePath;
-(void)uploadToDropbox;
@end

@implementation FileHandlerController

@synthesize restClient;

-(void) exportMeetingToFile:(Meeting *)meeting{
    
    // Get home directory
	//NSString *homeDir = NSHomeDirectory();
    
	// Get temporary directory
	//NSString *tempDir = NSTemporaryDirectory();
    
	// Get documents directory
	NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
	NSString *docDir = [arrayPaths objectAtIndex:0];
    // Create pathname to Documents directory
	NSString *newFilePath = [docDir stringByAppendingString:@"/MeetingNotes.txt"];
    
    [self writeToFile:meeting atPath:newFilePath];
}


-(void)writeToFile:(Meeting*)meeting atPath:(NSString*) newFilePath{
        
    NSString *fileContents = [NSString stringWithFormat:@"Meeting Name:%@\r\nLocation:%@\r\n\r\n", meeting.name, meeting.location];
    fileContents = [fileContents stringByAppendingString:[NSString stringWithFormat:@"Start Date:%@\r\nEnd Date:%@\r\n\r\n", [meeting.startDate description], [meeting.endDate description]]];
    
    fileContents = [fileContents stringByAppendingString:[NSString stringWithFormat:@"Attendees:"]];
    
	for (Attendee* attendee in meeting.Attendees) {
        fileContents = [fileContents stringByAppendingString:[NSString stringWithFormat:@"%@ ",attendee.name]];
    }
    
    [fileContents stringByAppendingString:[NSString stringWithFormat:@"\r\n\r\n"]];
    NSLog(@"Writing contents out to file %@: \r\n%@", newFilePath,fileContents);
    // Write string to file
	[fileContents writeToFile:newFilePath
        atomically:YES
          encoding:NSUTF8StringEncoding
             error:nil];
    
    for (AgendaItem* agendaItem in meeting.AgendaItems) {
        [self writeAgendaItem:agendaItem toFilePath:newFilePath];
    }
    
    // upload file to Dropbox
    [self uploadToDropbox];
}

-(void)writeAgendaItem:(AgendaItem*)agendaItem toFilePath:(NSString*)filePath{
    
    NSString *agendaContents = [NSString stringWithFormat:@"Agenda Item: %@\r\n", agendaItem.title];
    
    agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"Notes: %@\r\n\r\n", agendaItem.note]];
    // print each agenda item
    for (ActionItem* actionItem in agendaItem.ActionItems) {
        // print each action item
        agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"Action Item: %@\r\n", actionItem.notes]];
        for (Attendee* attendee in actionItem.Attendees) {
            agendaContents = [agendaContents stringByAppendingString:[NSString stringWithFormat:@"%@ ",attendee.name]];
        }
        agendaContents = [agendaContents stringByAppendingString:@"\r\n"];
    }
    
    NSLog(@"Writing contents out to file: \r\n%@", agendaContents);
    // Write string to file
	[agendaContents writeToFile:filePath
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:nil];
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    	restClient.delegate = self;
    }
    return restClient;
}

#pragma Mark- Dropbox delegates and upload functions.

-(void)uploadToDropbox{
    [self.restClient uploadFile:@"MeetingNotes.txt" toPath:@"/Photos" fromPath:@"/Users/noelcurtis/Library/Application Support/iPhone Simulator/4.3/Applications/C8EF4916-A241-4BD1-B6B1-052A66B29842/Documents/MeetingNotes.txt"];
}

-(void) restClient:(DBRestClient *)client uploadedFile:(NSString *)srcPath{
    NSLog(@"Finished uploading file!");
}


-(void) restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error{
    NSLog(@"Error uploading file");
}

-(void) restClient:(DBRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)srcPath{
    NSLog(@"Uploading file...");
}



@end
