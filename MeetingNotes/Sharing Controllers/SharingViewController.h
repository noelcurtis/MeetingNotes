//
//  SharingViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/27/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "SharingServiceAdapter.h"
#import "DropboxConfig.h"

@interface SharingViewController : UITableViewController<SharingServiceAdapterDelegate> {

}
@property (nonatomic, retain) IBOutlet UITableViewCell* dropboxCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* evernoteCell;
@property (nonatomic, retain) Meeting *meetingToShare;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *dropboxActivityIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *evernoteActivityIndicator;

@end
