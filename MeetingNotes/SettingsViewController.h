//
//  SettingsViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/5/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSettingsController.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UITableViewController<EvernoteSettingsViewControllerDelegate> {
    
}

// SettingsViewControllerDelegate
@property (nonatomic, assign) id<SettingsViewControllerDelegate> settingsViewControllerDelegate;
@end


@protocol SettingsViewControllerDelegate
-(void) dismissSettingsViewController;
@end

