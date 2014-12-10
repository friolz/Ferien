//
//  ThirdViewController.m
//  FerienCountdown
//
//  Created by Tobi on 06.03.11.
//  Copyright 2011 Tobi. All rights reserved.
//

#import "ThirdViewController.h"
#import "Ferien.h"

@implementation ThirdViewController

@synthesize background, selectBundesland, pickerView;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    Ferien *ferien = [[Ferien alloc] init];
    [ferien autorelease];
    return [ferien.bundeslandListFormatted count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Ferien *ferien = [[Ferien alloc] init];
    [ferien autorelease];
    return [ferien.bundeslandListFormatted objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // Save the selected Bundesland
    Ferien *ferien = [[Ferien alloc] init];
    [ferien.defaultBundesland setInteger:row forKey:@"bundesland"];
    [ferien.defaultBundesland synchronize];
    [ferien release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [background setImage:[UIImage imageNamed:@"background2.png"]];
    [selectBundesland setImage:[UIImage imageNamed:@"selectBundesland.png"]];
    Ferien *ferien = [[Ferien alloc] init];
    [pickerView selectRow:[ferien currentBundesland] inComponent:0 animated:NO];
    [ferien release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) releaseOutlets {
    self.background = nil;
    self.selectBundesland = nil;
    self.pickerView = nil;
}

- (void)viewDidUnload {
    [self releaseOutlets];
    [super viewDidUnload];
}


- (void)dealloc {
    [self releaseOutlets];
    [super dealloc];
}

@end
