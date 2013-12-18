//
//  TagsViewController.h
//  Travelog
//
//  Created by Edo/Imju on 10/29/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Travelog;

@interface TravelLogsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UITableView* feedTableView;


@end
