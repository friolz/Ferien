//
//  BW.h
//  FerienCountdown
//
//  Created by Tobias Frischholz on 19.04.11.
//  Copyright (c) 2011 Tobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BW : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * ende;
@property (nonatomic, retain) NSDate * beginn;
@property (nonatomic, retain) NSString * ferienName;

@end
