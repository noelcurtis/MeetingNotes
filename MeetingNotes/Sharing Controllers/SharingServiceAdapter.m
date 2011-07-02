//
//  SharingServiceAdapter.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/21/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "SharingServiceAdapter.h"
#import "EvernoteConfig.h"
#import "DropboxConfig.h"


@interface SharingServiceAdapter()<DBSessionDelegate, DBRestClientDelegate>
@property (nonatomic, retain) UINavigationController *dropboxNavigationController;
@property (nonatomic, retain) NSString *newMeetingFilePath;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
-(NSArray *) getAllEvernoteConfigurations;
@end

@implementation SharingServiceAdapter

static SharingServiceAdapter *_sharedSharingService;
@synthesize restClient;
@synthesize dropboxNavigationController = _dropboxNavigationController;
@synthesize newMeetingFilePath = _newMeetingFilePath;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize sharedDropboxConfig = _sharedDropboxConfig;
@synthesize sharingServiceAdapterDelegate;


-(void) setManagegObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
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

#pragma Mark- Dropbox delegate and upload functions.

- (DBRestClient*)restClient {
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    	restClient.delegate = self;
    }
    return restClient;
}

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
	_newMeetingFilePath = [docDir stringByAppendingString:[meeting fileName]];
    NSString *meetingAsString = [meeting asString];
    // Create a temp file with the meetings contents
    [meetingAsString writeToFile:_newMeetingFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self.restClient createFolder:@"Meeting Notes"];
    [self.restClient uploadFile:[meeting fileName] toPath:@"/Meeting Notes" fromPath:_newMeetingFilePath];
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

-(void) restClient:(DBRestClient *)client createdFolder:(DBMetadata *)folder{
    NSLog(@"Finished creating folder!");
}

-(void) restClient:(DBRestClient *)client createFolderFailedWithError:(NSError *)error{
    NSLog(@"Error creating folder: %@", [error userInfo]);
    NSString *errorAsString = [[error userInfo] objectForKey:@"error"];
    NSRange textRange;
    textRange =[[errorAsString lowercaseString] rangeOfString:[@"already exists" lowercaseString]];
    if(textRange.location != NSNotFound){
        //Does contain the substring
        NSLog((@"The Meeting Notes folder already exsits."));
    }else{
        [self.sharingServiceAdapterDelegate didFailUploadingToDropbox:error];
    }
}

-(void) restClient:(DBRestClient *)client uploadedFile:(NSString *)srcPath{
    NSLog(@"Finished uploading file!");
    [self removeTempMeetingFile];
    _newMeetingFilePath = nil;
    [self.sharingServiceAdapterDelegate didFinishUploadingToDropbox];
}


-(void) restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error{
    NSLog(@"Error uploading file");
    [self removeTempMeetingFile];
    _newMeetingFilePath = nil;
    [self.sharingServiceAdapterDelegate didFailUploadingToDropbox:error];
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

// write -(EvernoteConfig*) setupEvernoteWith:(NSString *)MeetingFolder username:(NSString *)username password:(NSString*) password

-(EvernoteConfig*) setupEvernoteWith:(NSString *)meetingNotebookName 
                            username:(NSString *)username password:(NSString *)password{
    
    [self.sharingServiceAdapterDelegate didStartConfiguringEvernote];
    // release any configured ENManager
    [[ENManager sharedInstance] releaseAuthorization];
    [[ENManager sharedInstance] setUsername:username];
    [[ENManager sharedInstance] setPassword:password];
    EDAMAuthenticationResult *authResult = [[ENManager sharedInstance] auth];
    NSLog(@"Token: %@", [authResult.authenticationToken description]);
    if(![authResult authenticationTokenIsSet]){
        //An error occurred
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Failed to sign in to Evernote, bad username or password." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"EvernoteAuthError" code:100 userInfo:errorDetail];
        [self.sharingServiceAdapterDelegate didFailConfiguringEvernoteWithError:error];
        return nil;
    }
    if(![self isEvernoteConfigured]){
        EvernoteConfig *newEvernoteConfig;
        // create the Default Folder if one does not exist
        if([meetingNotebookName isEqualToString:@""]){
            meetingNotebookName = @"Meeting Notes";
        }
        
        EDAMNotebook *newNotebook = [[ENManager sharedInstance] notebookWithName:meetingNotebookName];
        if(!newNotebook){
            newNotebook = [[ENManager sharedInstance] createNewNotebookWithTitle:meetingNotebookName];
        }
        if(newNotebook){
            newEvernoteConfig = [NSEntityDescription insertNewObjectForEntityForName:@"EvernoteConfig" inManagedObjectContext:self.managedObjectContext];
            [newEvernoteConfig setNotebookGuid:[newNotebook guid]];
            [newEvernoteConfig setNotebookName:[newNotebook name]];
            [newEvernoteConfig setPassword:password];
            [newEvernoteConfig setUsername:username];
        }else{
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Failed to create notebook." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"EvernoteNotebookError" code:100 userInfo:errorDetail];
            [self.sharingServiceAdapterDelegate didFailConfiguringEvernoteWithError:error];
            return nil;
        }
        NSError *savingError;
        if (![self.managedObjectContext save:&savingError]) {
            NSException *exception = [NSException exceptionWithName:@"EvernoteConfigException" reason:@"Error saving default evernote configuration." userInfo:nil];
            @throw exception;
        }
        [self.sharingServiceAdapterDelegate didFinishConfiguringEvernote];
        return newEvernoteConfig;
    }else{
        EvernoteConfig *existingEvernoteConfig = [self sharedEvernoteConfiguration];
        [existingEvernoteConfig setPassword:password];
        [existingEvernoteConfig setUsername:username];
        EDAMNotebook *newNotebook = [[ENManager sharedInstance] notebookWithName:meetingNotebookName];
        if(!newNotebook){
            newNotebook = [[ENManager sharedInstance] createNewNotebookWithTitle:meetingNotebookName];
        }
        if(newNotebook){
            [existingEvernoteConfig setNotebookGuid:[newNotebook guid]];
            [existingEvernoteConfig setNotebookName:[newNotebook name]];
            
        }else{
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Failed to create notebook." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"EvernoteNotebookError" code:100 userInfo:errorDetail];
            [self.sharingServiceAdapterDelegate didFailConfiguringEvernoteWithError:error];
            return nil;
        }
        NSError *savingError;
        if (![self.managedObjectContext save:&savingError]) {
            NSException *exception = [NSException exceptionWithName:@"EvernoteConfigException" reason:@"Error saving default evernote configuration." userInfo:nil];
            @throw exception;
        }
        [self.sharingServiceAdapterDelegate didFinishConfiguringEvernote];
        return [self sharedEvernoteConfiguration];
    }
}

-(EvernoteConfig*) sharedEvernoteConfiguration{
    NSArray *allConfigs = [self getAllEvernoteConfigurations];
    if([allConfigs count] == 0){
        return nil;
    }else if([allConfigs count]>1){
        NSException *exception = [NSException exceptionWithName:@"EvernoteConfigException" reason:@"More than 1 evernote configuration exists??" userInfo:nil];
        @throw exception;
    }
    else{
        return [allConfigs objectAtIndex:0];
    }
}

-(BOOL) isEvernoteConfigured{
    if([self sharedEvernoteConfiguration]){
        return YES;
    }else{
        return NO;
    }
}

-(NSArray *) getAllEvernoteConfigurations{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EvernoteConfig"
                                              inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *allEvernoteConfigs = [_managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        return allEvernoteConfigs;
    }else{
        NSException *exception = [NSException exceptionWithName:@"EvernoteConfigException" reason:@"Error fetching Evernote configuration." userInfo:nil];
        @throw exception;
    }
}


-(void) uploadMeetingToEvernote:(id)meeting{
    if([self isEvernoteConfigured]){
        [[ENManager sharedInstance] setUsername:((EvernoteConfig*)[self sharedEvernoteConfiguration]).username];
        [[ENManager sharedInstance] setPassword:((EvernoteConfig*)[self sharedEvernoteConfiguration]).password];
        NSMutableString *contentString = [NSMutableString string];
        [contentString setString:	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
        [contentString appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
        [contentString appendString:@"<en-note>"];
        [contentString appendString:[meeting asString]];
        [contentString appendString:@"</en-note>"];
        EDAMNote* newNote = [[ENManager sharedInstance] createNote2Notebook:(EDAMGuid)[self sharedEvernoteConfiguration].notebookGuid title:((Meeting*)meeting).name content:contentString];
        if(newNote){
            [self.sharingServiceAdapterDelegate didFinishUploadingToEvernote];
        }else{
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"Failed to upload meeting to evernote." forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"EvernoteUploadError" code:100 userInfo:errorDetail];
            [self.sharingServiceAdapterDelegate didFailUploadingToEvernote:error];
        }
        [[ENManager sharedInstance] releaseAuthorization];
    }else{
        NSLog(@"The evernote configuration is null please init it before trying to upload.");
        NSException *exception = [NSException exceptionWithName:@"EvernoteConfigException" reason:@"The evernote configuration is null please initialize it before trying to upload." userInfo:nil];
        @throw exception;
    }
}


#pragma mark - Evernot Async

- (NSOperation*)uploadMeetingAsync:(Meeting*)meeting {
    NSInvocationOperation* evernoteOperation = [[[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(uploadMeetingToEvernote:) object:meeting] autorelease];
    
    return evernoteOperation;
}


@end
