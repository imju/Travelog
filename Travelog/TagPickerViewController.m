//
//  TagPickerViewController.m
//  Travelog
//
//  Created by Edo/Imju on 10/28/13.
//  Copyright (c) 2013 Edo/Imju. All rights reserved.
//

#import "TagPickerViewController.h"
#import "TagPickerCell.h"

@implementation TagPickerViewController
{
    NSArray *tags;
    
    //when screen opens, show checkmark next to currently selected tag
    NSIndexPath *selectedIndexPath;
}

@synthesize delegate, selectedTagName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //array that contans all the tags
    tags = [NSArray arrayWithObjects:
            @"Other",
            @"House",
            @"Restaurant",
            @"Travel",
            @"Office",
            @"People",
            @"Nature",
            @"Shopping",
            @"Events",
            nil];
    
    //register custom cell
    UINib *tagPickerCell = [UINib nibWithNibName:@"TagPickerCell" bundle:nil];
    [self.tableView registerNib:tagPickerCell forCellReuseIdentifier:@"TagPickerCell"];

}


- (BOOL)shouldAutorotate
{
    //no lanscape mode
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //compare the name of row to selectedTagName, if they match, we store the
    //row index path in the SelectedIndexPath variable
    static NSString *CellIdentifier = @"TagPickerCell";
    
    TagPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *tagName = [tags objectAtIndex:indexPath.row];
    cell.tagName.text = tagName;
    cell.tagImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[tagName lowercaseString]]];
   
    
    if ([tagName isEqualToString:self.selectedTagName])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedIndexPath = indexPath;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - UITableViewDeleate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != selectedIndexPath.row) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        selectedIndexPath = indexPath;
    }
    
    NSString *tagName = [tags objectAtIndex:indexPath.row];
    [self.delegate tagPicker:self didPickTag:tagName];
}


@end
