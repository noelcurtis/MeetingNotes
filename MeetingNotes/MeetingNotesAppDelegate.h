//
//  MeetingNotesAppDelegate.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortRootViewController;
@class SortDetailViewController;

@interface MeetingNotesAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) SortRootViewController *sortRVController;
@property (nonatomic, retain) SortDetailViewController *sortDVController;
@property (nonatomic, retain) UISplitViewController *splitViewController;

@end
