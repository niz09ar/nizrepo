//
//  MasterViewController.m
//  MaskedOut
//
//  Created by nizar cherkaoui on 12/9/13.
//  Copyright (c) 2013 nizar cherkaoui. All rights reserved.
//

#import "RootViewController.h"
#import "Item.h"

@implementation RootViewController
@synthesize menuItems;
@synthesize managedObjectContext;
@synthesize editViewCtrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MASKED OUT";
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Item" inManagedObjectContext: managedObjectContext];
    request.entity = entity;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"name" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects: sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    NSError *error = nil;
    menuItems = [[managedObjectContext executeFetchRequest: request error: &error] mutableCopy];
    
    editViewCtrl = [[EditViewController alloc] init];
}


- (void) addItem
{
	Item *menuItem = [NSEntityDescription insertNewObjectForEntityForName: @"Item" inManagedObjectContext: managedObjectContext];
	
	NSError *error = nil;
	[managedObjectContext save: &error];
	
	[menuItems insertObject: menuItem atIndex: 0];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
	[self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];
}



- (void) viewWillAppear: (BOOL) animated
{
	[super viewWillAppear: animated];
	if(editViewCtrl.item)
    {
		NSIndexPath *path = [NSIndexPath indexPathForRow: [menuItems indexOfObject: editViewCtrl.item] inSection: 0];
		NSArray *paths = [NSArray arrayWithObjects: path, nil];
		[self.tableView reloadRowsAtIndexPaths: paths withRowAnimation: NO];
		editViewCtrl.item = nil;
	}
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}


- (UITableViewCell *)tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
	Item *menuItem = [menuItems objectAtIndex: indexPath.row];
    
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM-dd-yy";
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    
    if (menuItem.dateTime == nil){
        menuItem.dateTime = [NSString stringWithFormat:@"%@ at %@", [dateFormatter stringFromDate: localDate], [timeFormatter stringFromDate: localDate]];
        cell.textLabel.text = menuItem.dateTime;
    }
    else if (menuItem.name == nil || [menuItem.name  isEqual: @""])
        cell.textLabel.text = [NSString stringWithFormat:@"%@", menuItem.dateTime];
    else if (![menuItem.name  isEqual: @""])
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", menuItem.name, menuItem.dateTime];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"%@.caf", menuItem.dateTime], nil];
    
    menuItem.outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
	cell.textLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size: 14];
	cell.textLabel.textColor = [UIColor blueColor];
	cell.textLabel.highlightedTextColor = [UIColor yellowColor];
    
    if (menuItem.selectedMask == nil)
    {
        menuItem.selectedMask = [NSNumber numberWithInteger:0];
    }
    
    dateFormatter = nil;
    timeFormatter = nil;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	editViewCtrl.item = [menuItems objectAtIndex: indexPath.row];
	[self.navigationController pushViewController: editViewCtrl animated:YES];
}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [managedObjectContext deleteObject: [menuItems objectAtIndex: indexPath.row]];
        NSError *error = nil;
        [managedObjectContext save: &error];
        [menuItems removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: YES];
    }
    
}


@end
