//
//  SelectCategorieViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/16/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@protocol  SelectCategoryViewControllerDelegate;
@interface SelectCategorieViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
// SelectCategoryViewControllerDelegate
@property (nonatomic, assign) id<SelectCategoryViewControllerDelegate> selectCategoryViewControllerDelegate;

@end


@protocol SelectCategoryViewControllerDelegate
    -(void) didSelectCategory:(Category*) category;
@end

