//
//  Ferien.h
//  FerienCountdown
//
//  Created by Tobias Frischholz on 19.04.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Ferien : NSObject <NSFetchedResultsControllerDelegate> {
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSUserDefaults *defaultBundesland;
@property (nonatomic) NSInteger currentBundesland;
@property (nonatomic, strong) NSArray *bundeslandListWithManagedObjects;
@property (nonatomic, strong) NSArray *bundeslandListFormatted;
@property (nonatomic, copy) NSString *holidayName;
@property (nonatomic) BOOL holidayFlag;

- (NSDate *)getDate;
- (NSString *)bundeslandFromArray;
- (NSString *)formattedBundeslandFromArray;
- (NSEntityDescription *)getEntity;
- (NSMutableArray *)getNumberOfHolidays;
- (NSInteger)daysBetweenDate:(NSDate*)dt1 andDate:(NSDate*)dt1;
- (NSInteger)getTotalDays;
- (NSMutableArray *)getToplist;
- (NSString *)getDateAsString;

@end
