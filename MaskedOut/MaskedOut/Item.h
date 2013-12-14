//
//  Item.h
//  MaskedOut
//
//  Created by nizar cherkaoui on 12/12/13.
//  Copyright (c) 2013 nizar cherkaoui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * dateTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSURL * outputFileURL;
@property (nonatomic, retain) NSNumber * selectedMask;

@end
