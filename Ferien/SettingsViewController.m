//
//  SettingsViewController.m
//  Ferien
//
//  Created by Tobi on 10.01.13.
//  Copyright (c) 2013 Tobi. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 16;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Ferien *ferien = [[Ferien alloc] init];
    return [ferien.bundeslandListFormatted objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Ferien *ferien = [[Ferien alloc] init];
    [ferien.defaultBundesland setInteger:row forKey:@"bundesland"];
    [ferien.defaultBundesland synchronize];
    
    NSString *lowerCaseBundesland = [[ferien.bundeslandListWithManagedObjects objectAtIndex:row] lowercaseString];
    self.bundeslandImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", lowerCaseBundesland]];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Ferien *ferien = [[Ferien alloc] init];
    NSString *lowerCaseBundesland = [[ferien bundeslandFromArray] lowercaseString];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480) {
            self.bundeslandImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 30, 160, 150)];
            self.bundeslandImage.contentMode = UIViewContentModeScaleAspectFit;
        }
        if(result.height == 568) {
            self.bundeslandImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 240, 240)];
            self.bundeslandImage.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    
    self.bundeslandImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", lowerCaseBundesland]];
    [self.view addSubview:self.bundeslandImage];
    [self.pickerView selectRow:[ferien currentBundesland] inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
