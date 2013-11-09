//
//  TagPickerViewController.m
//  Travelog
//
//  Created by Edo williams on 10/28/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "TagPickerViewController.h"

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *tagName = [tags objectAtIndex:indexPath.row];
    cell.textLabel.text = tagName;
    
    
    if ([tagName  isEqual: @"Events"]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"events.png"];
        cell.imageView.image = imgView.image;
    }
    else if ([tagName  isEqual: @"House"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"house.png"];
        cell.imageView.image = imgView.image;
    }
    
    else if ([tagName  isEqual: @"Restaurant"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"restaurant.png"];
        cell.imageView.image = imgView.image;

    }
    
    else if ([tagName  isEqual: @"Travel"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"travel.png"];
        cell.imageView.image = imgView.image;

    }
    
    else if ([tagName  isEqual: @"Office"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"office.png"];
        cell.imageView.image = imgView.image;

    }
    
    else if ([tagName  isEqual: @"People"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"people.png"];
        cell.imageView.image = imgView.image;

    }
    
    else if ([tagName  isEqual: @"Nature"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"nature.png"];
        cell.imageView.image = imgView.image;

    }
    
    else if ([tagName  isEqual: @"Shopping"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"shopping.png"];
        cell.imageView.image = imgView.image;

    }
    
    else
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"other.png"];
        cell.imageView.image = imgView.image;

    }
    
   
    
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
