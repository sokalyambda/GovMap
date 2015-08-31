//
//  ViewController.m
//  GovMap
//
//  Created by Pavlo on 8/31/15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "ViewController.h"
#import "GMPCommunicator.h"
#import "GMPCadastre.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) GMPCommunicator *communicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.communicator = [GMPCommunicator sharedInstance];
}

- (IBAction)loadButtonPressed:(id)sender
{
    [self.communicator requestCadastralNumbersWithAddress:nil completionBlock:^(GMPCadastre *cadastralInfo, NSError *error) {
        self.label.text = [NSString stringWithFormat:@"Major: %ld, minor: %ld", (long)cadastralInfo.major, (long)cadastralInfo.minor];
    }];
}

@end