//
//  MasterViewController.h
//  MaskedOut
//
//  Created by nizar cherkaoui on 12/9/13.
//  Copyright (c) 2013 nizar cherkaoui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface RootViewController : UITableViewController <UINavigationControllerDelegate> {
	NSMutableArray *menuItems;
	NSManagedObjectContext *managedObjectContext;
	EditViewController *editViewCtrl;
	Item *selItem;
}

@property(nonatomic, strong) NSMutableArray *menuItems;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) EditViewController *editViewCtrl;

- (void) addItem;

@end

