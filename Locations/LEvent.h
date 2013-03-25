//
//  LEvent.h
//  Locations
//
//  Created by Администратор on 3/23/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LEvent : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
