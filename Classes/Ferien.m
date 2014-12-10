//
//  Ferien.m
//  FerienCountdown
//
//  Created by Tobias Frischholz on 19.04.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import "Ferien.h"
#import "FerienCountdownAppDelegate.h"

@implementation Ferien

@synthesize managedObjectContext;
@synthesize defaultBundesland;
@synthesize currentBundesland;
@synthesize bundeslandListWithManagedObjects;
@synthesize bundeslandListFormatted;
@synthesize holidayName;
@synthesize holidayFlag;

- (id)init {
    if ((self = [super init])) {
        if (managedObjectContext == nil) { 
            managedObjectContext = [(FerienCountdownAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];    
        }
        bundeslandListWithManagedObjects = [[NSArray alloc] initWithObjects:@"BW", @"BY", @"BE", @"BB", @"HB", @"HH", @"HE", @"MV", @"NI", @"NW", @"RP", @"SL", @"SN", @"ST", @"SH", @"TH", nil];
        bundeslandListFormatted = [[NSArray alloc] initWithObjects:@"Baden-Württemberg", @"Bayern", @"Berlin", @"Brandenburg", @"Bremen", @"Hamburg", @"Hessen", @"Mecklenburg-Vorpommern", @"Niedersachsen", @"Nordrhein-Westfalen", @"Rheinland-Pfalz", @"Saarland", @"Sachsen", @"Sachsen-Anhalt", @"Schleswig-Holstein", @"Thüringen", nil];
        defaultBundesland = [NSUserDefaults standardUserDefaults];
        currentBundesland = [defaultBundesland integerForKey:@"bundesland"];
    }
    return self;
}

- (NSString *)bundeslandFromArray {
    return [bundeslandListWithManagedObjects objectAtIndex:currentBundesland];
}

- (NSString *)formattedBundeslandFromArray {
    return [bundeslandListFormatted objectAtIndex:currentBundesland];
}

- (NSEntityDescription *)getEntity {
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self bundeslandFromArray] inManagedObjectContext:managedObjectContext];
    return (entity);
}

- (NSArray *)getNumberOfHolidays {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self getEntity]];
    NSError *error;
    NSArray *numberOfHolidays = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    return numberOfHolidays;
}

- (NSInteger)calculateDaysToNextHolidays {
    Ferien *ferien = [[Ferien alloc] init];
    NSInteger maxDaysBetweenHolidays = 90;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self getEntity]];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
	if (mutableFetchResults == nil) {
		// Handle the error
		NSLog(@"calculateDaysToNextHolidays - error: %@", error);
	}
    
    // Calculate days to next holidays
	else {
        for (NSManagedObject *info in mutableFetchResults) {
            NSDate *startDate = [info valueForKey:@"beginn"];
            NSTimeInterval intervalToStart = [startDate timeIntervalSinceNow];
            
            NSDate *endDate = [info valueForKey:@"ende"];
            NSTimeInterval intervalToEnd = [endDate timeIntervalSinceNow];
            
            intervalToStart = ceil(intervalToStart/86400);
            intervalToEnd = ceil(intervalToEnd/86400);
            
            if (intervalToStart > 0 && intervalToStart < maxDaysBetweenHolidays) {
                maxDaysBetweenHolidays = intervalToStart;
                holidayName = [info valueForKey:@"ferienName"];
                holidayFlag = NO;
            }
            
            if (intervalToEnd > 0 && intervalToEnd < maxDaysBetweenHolidays) {
                maxDaysBetweenHolidays = intervalToEnd;
                holidayName = [info valueForKey:@"ferienName"];
                holidayFlag = YES;
            }
        }
	}
    
	[fetchRequest release];
    [ferien release];
    return maxDaysBetweenHolidays;
}

- (void) dealloc {
    [bundeslandListWithManagedObjects release];
    [bundeslandListFormatted release];
    [super dealloc];
}

@end