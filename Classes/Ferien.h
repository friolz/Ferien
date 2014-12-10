//
//  Ferien.h
//  FerienCountdown
//
//  Created by Tobias Frischholz on 19.04.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ferien : NSObject <NSFetchedResultsControllerDelegate> {

@private
 	NSManagedObjectContext *managedObjectContext;
    NSUserDefaults *defaultBundesland;
    NSInteger currentBundesland;
    NSArray *bundeslandListWithManagedObjects;
    NSArray *bundeslandListFormatted;
    NSString *holidayName;
    BOOL holidayFlag;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSUserDefaults *defaultBundesland;
@property (nonatomic) NSInteger currentBundesland;
@property (nonatomic, retain) NSArray *bundeslandListWithManagedObjects;
@property (nonatomic, retain) NSArray *bundeslandListFormatted;
@property (nonatomic, copy) NSString *holidayName;
@property (nonatomic) BOOL holidayFlag;

- (NSInteger)calculateDaysToNextHolidays;
- (NSString *)bundeslandFromArray;
- (NSString *)formattedBundeslandFromArray;
- (NSEntityDescription *)getEntity;
- (NSMutableArray *)getNumberOfHolidays;

@end
