//
//  EvernoteSettingsController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/25/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharingServiceAdapter.h"

@protocol EvernoteSettingsViewControllerDelegate;

@interface EvernoteSettingsController : UITableViewController<SharingServiceAdapterDelegate> {
    
}
@property (nonatomic, retain) IBOutlet UITableViewCell *usernameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *notebookCell;
@property (nonatomic, retain) IBOutlet UITextField *usernameTextView;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextView;
@property (nonatomic, retain) IBOutlet UITextField *notebookTextView;
@property (nonatomic, assign) id<EvernoteSettingsViewControllerDelegate> evernoteSettingsViewControllerDelegate;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@protocol EvernoteSettingsViewControllerDelegate
-(void) dismissEvernoteSettingsViewController;
@end