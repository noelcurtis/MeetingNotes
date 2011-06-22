//
//  SharingServiceAdapter.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/21/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "SharingServiceAdapter.h"

@interface SharingServiceAdapter()<DBRestClientDelegate, DBSessionDelegate>
@property (nonatomic, retain) UINavigationController *dropboxNavigationController;
@property (nonatomic, retain) DBRestClient* restClient;
@property (nonatomic, retain) NSString *newMeetingFilePath;
@end

@implementation SharingServiceAdapter

static SharingServiceAdapter *_sharedSharingService;
@synthesize restClient;
@synthesize dropboxNavigationController = _dropboxNavigationController;
@synthesize newMeetingFilePath = _newMeetingFilePath;

- (DBRestClient*)restClient {
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    	restClient.delegate = self;
    }
    return restClient;
}


- (id)init {
    self = [super init];
    return self;
}

+(id)alloc
{
	@synchronized([SharingServiceAdapter class]){
		NSAssert(_sharedSharingService == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedSharingService = [super alloc];
		return _sharedSharingService;
	}
    
	return nil;
}

+ (SharingServiceAdapter*) sharedSharingService{
    @synchronized([SharingServiceAdapter class]){
        if(!_sharedSharingService){
            [[self alloc] init];
            return _sharedSharingService;
        }else{
            return _sharedSharingService;
        }
    }
}

#pragma Mark- Dropbox delegates and upload functions.
/*
-(void)uploadToDropbox{
    [self.restClient uploadFile:@"MeetingNotes.txt" toPath:@"/Photos" fromPath:@"/Users/noelcurtis/Library/Application Support/iPhone Simulator/4.3/Applications/C8EF4916-A241-4BD1-B6B1-052A66B29842/Documents/MeetingNotes.txt"];
}*/



-(void)setupDropboxSession{
    // Set these variables before launching the app
    NSString* consumerKey = @"v7wv9j7ra5xni86";
	NSString* consumerSecret = @"rfqnzls0x48adv7";
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([consumerKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the consumer key correctly in AppDelegate.m";
	} else if ([consumerSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the consumer secret correctly in AppDelegate.m";
	}
	
	DBSession* session = 
    [[DBSession alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    //[session release];
	
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
    
}


-(void) uploadMeetingToDropbox:(Meeting *)meeting{
    NSArray *arrayPaths = 
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
	NSString *docDir = [arrayPaths objectAtIndex:0];
    // Create pathname to Documents directory
	_newMeetingFilePath = [docDir stringByAppendingString:@"/MeetingNotes.txt"];
    NSString *meetingAsString = [meeting asString];
    // Create a temp file with the meetings contents
    [meetingAsString writeToFile:_newMeetingFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.restClient uploadFile:@"MeetingNotes.txt" toPath:@"/Photos" fromPath:_newMeetingFilePath];
    // Remove the temp file after the upload to dropbox is finished.
    //[newFilePath release];
    //[meetingAsString release];
}

-(void) removeTempMeetingFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if ([fileManager fileExistsAtPath:_newMeetingFilePath]) {
        NSError **error;
        [fileManager removeItemAtPath:_newMeetingFilePath error:error];
        if(!error){
            NSLog(@"Error removing %@", _newMeetingFilePath);
        }
    }

}

-(void) restClient:(DBRestClient *)client uploadedFile:(NSString *)srcPath{
    NSLog(@"Finished uploading file!");
    [self removeTempMeetingFile];
    _newMeetingFilePath = nil;
}


-(void) restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error{
    NSLog(@"Error uploading file");
    [self removeTempMeetingFile];
    _newMeetingFilePath = nil;
}

-(void) restClient:(DBRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)srcPath{
    NSLog(@"Uploading file...");
}

#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	DBLoginController* loginController = [[DBLoginController new] autorelease];
	[loginController presentFromController:_dropboxNavigationController];
}

#pragma mark - Evernote integration
/*
-(void) testEvernote{
    [[ENManager sharedInstance] setUsername:EVERNOTE_USER];
    [[ENManager sharedInstance] setPassword:EVERNOTE_PASSWORD];
    EDAMNotebook *defaultNoteBook = [[ENManager sharedInstance] defaultNotebook];
    EDAMNoteList *notesForDefaultNoteBook  = [[ENManager sharedInstance] notesWithNotebookGUID:[defaultNoteBook guid]];
    for ( EDAMNote *note in [notesForDefaultNoteBook notes]) {
        NSString *contents = [[[ENManager sharedInstance] noteWithNoteGUID:note.guid] content];
        NSLog(@"%@", contents);
    }
    NSLog(@"Success!");
    
}
*/

-(void) uploadMeetingToEvernote:(Meeting*)meeting{
    [[ENManager sharedInstance] setUsername:EVERNOTE_USER];
    [[ENManager sharedInstance] setPassword:EVERNOTE_PASSWORD];
    EDAMNotebook *newNotebook = [[ENManager sharedInstance] createNewNotebookWithTitle:@"Meeting Notes"];
    EDAMNotebook *defaultNoteBook = [[ENManager sharedInstance] defaultNotebook];
    NSLog(@"%@",newNotebook.guid);
    NSMutableString *contentString = [NSMutableString string];
	[contentString setString:	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
	[contentString appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
	[contentString appendString:@"<en-note>"];
	[contentString appendString:[meeting asString]];
	[contentString appendString:@"</en-note>"];
    [[ENManager sharedInstance] createNote2Notebook:[defaultNoteBook guid] title:@"NewMeeting" content:contentString];
}


@end
