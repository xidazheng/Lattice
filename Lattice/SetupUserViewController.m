//
//  SetupUserViewController.m
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "SetupUserViewController.h"
#import "PublicChannelsTableViewController.h"

@interface SetupUserViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *latticeLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameInputField;

@end

@implementation SetupUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameInputField.delegate = self;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"existingUser"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"communication"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"transportation"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"healthcare"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"foodWater"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"shelter"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"power"];
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"otherNeeds"];
    
    [textField resignFirstResponder];

//    PublicChannelsTableViewController.h *setupViewController = [storyboard instantiateViewControllerWithIdentifier:@"PublicChannelsTableViewController.h"];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
