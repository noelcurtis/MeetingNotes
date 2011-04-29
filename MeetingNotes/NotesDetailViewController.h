//
//  NotesDetailViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NotesDetailViewController : UITableViewController {
    
}

@property(nonatomic, retain) NSManagedObject* agendaItem;
@property(nonatomic, retain)IBOutlet UITableViewCell* actionItemCell;
@property(nonatomic, retain)IBOutlet UITableViewCell* attendeeCell;
@property(nonatomic, retain)IBOutlet UITableViewCell* agendaItemNotesCell;

-(UITableViewCell *) configureCellAtIndexPath:(NSIndexPath *)indexPath;
@end
