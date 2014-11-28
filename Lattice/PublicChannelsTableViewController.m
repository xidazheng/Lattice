//
//  PublicChannelsTableViewController.m
//  Lattice
//
//  Created by Elliott French on 22/11/2014.
//  Copyright (c) 2014 XidaElliott. All rights reserved.
//

#import "PublicChannelsTableViewController.h"
#import "ChannelTableViewCell.h"
#import "ChannelViewController.h"

@interface PublicChannelsTableViewController ()

@property (strong, nonatomic) NSArray *channelTitles;
@property (strong, nonatomic) NSArray *channelImages;


@end

@implementation PublicChannelsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.channelTitles = @[@"Communication", @"Transportation", @"Healthcare", @"Food and Water", @"Shelter", @"Power", @"Sanitation", @"Other"];
    // Set images array for cell images
    UIImage *communicationImage = [UIImage imageNamed:@"communication"];
    UIImage *transportationImage = [UIImage imageNamed:@"transportation"];
    UIImage *healthcareImage = [UIImage imageNamed:@"healthcare"];
    UIImage *foodWaterImage = [UIImage imageNamed:@"foodWater"];
    UIImage *shelterImage = [UIImage imageNamed:@"shelter"];
    UIImage *powerImage = [UIImage imageNamed:@"power"];
    UIImage *sanitationImage = [UIImage imageNamed:@"sanitation"];
    UIImage *otherImage = [UIImage imageNamed:@"other"];

    self.channelImages = @[communicationImage, transportationImage, healthcareImage, foodWaterImage, shelterImage, powerImage, sanitationImage, otherImage];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChannelTableViewCell"
                                               bundle:nil] forCellReuseIdentifier:@"ChannelTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor grayColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set row height in combination to maximum offset and image height
    return 120.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.channelTitles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelTableViewCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ChannelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChannelTableViewCell"];
    }
    
    // Configure cell
    cell.cellImage.image = self.channelImages[indexPath.row];
    cell.cellLabel.text = self.channelTitles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //Create a Channel View Controller and pass in information to it.
    ChannelViewController *channelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChannelViewController"];
    channelVC.channelName = self.channelTitles[indexPath.row];
    [self.navigationController pushViewController:channelVC animated:YES];
    
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
