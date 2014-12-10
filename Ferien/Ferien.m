//
//  Ferien.m
//  FerienCountdown
//
//  Created by Tobias Frischholz on 19.04.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import "Ferien.h"
#import "BB.h"
#import "BE.h"
#import "BW.h"
#import "BY.h"
#import "HB.h"
#import "HE.h"
#import "HH.h"
#import "MV.h"
#import "NI.h"
#import "NW.h"
#import "RP.h"
#import "SH.h"
#import "SL.h"
#import "SN.h"
#import "ST.h"
#import "TH.h"

@implementation Ferien

@synthesize managedObjectContext = _managedObjectContext;
@synthesize defaultBundesland = _defaultBundesland;
@synthesize currentBundesland = _currentBundesland;
@synthesize bundeslandListWithManagedObjects = _bundeslandListWithManagedObjects;
@synthesize bundeslandListFormatted = _bundeslandListFormatted;
@synthesize holidayName = _holidayName;
@synthesize holidayFlag = _holidayFlag;

- (id)init {
    if ((self = [super init])) {
        if (self.managedObjectContext == nil) {
            self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        }
        self.bundeslandListWithManagedObjects = [[NSArray alloc] initWithObjects:@"BW", @"BY", @"BE", @"BB", @"HB", @"HH", @"HE", @"MV", @"NI", @"NW", @"RP", @"SL", @"SN", @"ST", @"SH", @"TH", nil];
        self.bundeslandListFormatted = [[NSArray alloc] initWithObjects:@"Baden-Württemberg", @"Bayern", @"Berlin", @"Brandenburg", @"Bremen", @"Hamburg", @"Hessen", @"Mecklenburg-Vorpommern", @"Niedersachsen", @"Nordrhein-Westfalen", @"Rheinland-Pfalz", @"Saarland", @"Sachsen", @"Sachsen-Anhalt", @"Schleswig-Holstein", @"Thüringen", nil];
        self.defaultBundesland = [NSUserDefaults standardUserDefaults];
        self.currentBundesland = [self.defaultBundesland integerForKey:@"bundesland"];
    }
    return self;
}

- (NSString *)bundeslandFromArray {
    return [self.bundeslandListWithManagedObjects objectAtIndex:self.currentBundesland];
}

- (NSString *)formattedBundeslandFromArray {
    return [self.bundeslandListFormatted objectAtIndex:self.currentBundesland];
}

- (NSEntityDescription *)getEntity {
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self bundeslandFromArray] inManagedObjectContext:self.managedObjectContext];
    return (entity);
}

- (NSArray *)getNumberOfHolidays {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self getEntity]];
    NSError *error;
    NSArray *numberOfHolidays = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return numberOfHolidays;
}

- (NSDate *)getDate {
    NSDate *date = [NSDate date];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self getEntity]];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for (NSManagedObject *info in mutableFetchResults) {
        NSDate *startDate = [info valueForKey:@"beginn"];
        NSDate *endDate = [info valueForKey:@"ende"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *startName = [dateFormatter stringFromDate:startDate];
        // If holidays start on a Monday, subtract 3 days.
        if ([startName isEqualToString:@"Montag"]) {
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -3;
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            startDate = [theCalendar dateByAddingComponents:dayComponent toDate:startDate options:0];
        }
        
        NSString *endName = [dateFormatter stringFromDate:endDate];
        // If holidays end on a Friday, add 2 more days.
        if ([endName isEqualToString:@"Freitag"]) {
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = 2;
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            endDate = [theCalendar dateByAddingComponents:dayComponent toDate:endDate options:0];
        }
        
        if ([date compare:startDate] == NSOrderedAscending || [date compare:endDate] == NSOrderedAscending) {
            if ([date compare:startDate] == NSOrderedAscending) {
                date = startDate;
                self.holidayFlag = NO;
                self.holidayName = [info valueForKey:@"ferienName"];
            } else {
                date = endDate;
                self.holidayFlag = YES;
                self.holidayName = [info valueForKey:@"ferienName"];
            }
            break;
        }
    }
    return date;
}

- (NSInteger)daysBetweenDate:(NSDate *)dt1 andDate:(NSDate *)dt2 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *endName = [dateFormatter stringFromDate:dt2];
    // If holidays end on a Friday, add 2 more days.
    if ([endName isEqualToString:@"Freitag"]) {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 2;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        dt2 = [theCalendar dateByAddingComponents:dayComponent toDate:dt2 options:0];
    }
    
    if ([endName isEqualToString:@"Samstag"]) {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        dt2 = [theCalendar dateByAddingComponents:dayComponent toDate:dt2 options:0];
    }
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

- (NSInteger)getTotalDays {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self getEntity]];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSInteger count = 0;
    
    for (NSManagedObject *info in mutableFetchResults) {
        NSDate *startDate = [info valueForKey:@"beginn"];
        NSDate *endDate = [info valueForKey:@"ende"];
        count += [self daysBetweenDate:startDate andDate:endDate];
    }
    return count;
}

- (NSMutableArray *)getToplist {
    NSMutableArray *countArray = [[NSMutableArray alloc] initWithCapacity:16];
    NSInteger index = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	for (NSString *bl in self.bundeslandListWithManagedObjects) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:bl inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
        NSInteger count = 0;
        
        for (NSManagedObject *info in mutableFetchResults) {
            NSDate *startDate = [info valueForKey:@"beginn"];
            NSDate *endDate = [info valueForKey:@"ende"];
            count += [self daysBetweenDate:startDate andDate:endDate];
        }
        
        [countArray addObject:[NSNumber numberWithInteger:count]];
        index++;
    }
    
    return countArray;
}

- (NSString *)getDateAsString {
    NSUInteger flags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date] toDate:[self getDate]options:0];
    
    if ([dateComponents day] == 1) {
        NSString *dateAsString = [NSString stringWithFormat:@"%d Tag, %d Stunden, %d Minuten, %d Sekunden", [dateComponents day], [dateComponents hour], [dateComponents minute], [dateComponents second]];
        return dateAsString;
    } else {
        NSString *dateAsString = [NSString stringWithFormat:@"%d Tage, %d Stunden, %d Minuten, %d Sekunden", [dateComponents day], [dateComponents hour], [dateComponents minute], [dateComponents second]];
        return dateAsString;
    }
    
    return nil;
}

@end