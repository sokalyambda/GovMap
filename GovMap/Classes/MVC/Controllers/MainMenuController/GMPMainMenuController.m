//
//  GMPMainMenuController.m
//  GovMap
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "GMPMainMenuController.h"
#import "GMPMapController.h"
#import "GMPAppLanguageSwitchController.h"
#import "GMPAboutController.h"

#import "GMPLocationObserver.h"

#import "GMPMenuView.h"

#import "GMPSerialViewsConstructor.h"

static NSString *const kMapControllerSegueIdentifier = @"mapControllerSegue";
static NSString *const kSearchWithAddressControllerSegueIdentifier = @"searchWithAddressControllerSegue";
static NSString *const kSearchWithGeoNumbersControllerSegueIdentifier = @"searchWithGeoNumbersControllerSegue";
static NSString *const kAboutControllerSegueIdentifier = @"aboutControllerSegue";
static NSString *const kAboutImageName = @"about";

@interface GMPMainMenuController() <GMPMenuViewDelegate>

@property (weak, nonatomic) IBOutlet GMPMenuView *menuView;
@property (strong, nonatomic) GMPAppLanguageSwitchController *appLanguageSwitchController;

@end

@implementation GMPMainMenuController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuView.delegate = self;
    
    self.appLanguageSwitchController = [[GMPAppLanguageSwitchController alloc] initWithNibName:NSStringFromClass([GMPAppLanguageSwitchController class]) bundle:nil];
    
    [self.navigationController addChildViewController:self.appLanguageSwitchController];
    [self.appLanguageSwitchController didMoveToParentViewController:self.navigationController];
}

#pragma mark - GMPMenuViewDelegate methods

- (void)menuViewDidPressFirstButton:(GMPMenuView *)menuView
{
    [self.appLanguageSwitchController removeFromParentViewController];
    [self performSegueWithIdentifier:kSearchWithAddressControllerSegueIdentifier sender:self];
}

- (void)menuViewDidPressSecondButton:(GMPMenuView *)menuView
{
    [self.appLanguageSwitchController removeFromParentViewController];
    [self performSegueWithIdentifier:kMapControllerSegueIdentifier sender:self];
}

- (void)menuViewDidPressThirdButton:(GMPMenuView *)menuView
{
    [self.appLanguageSwitchController removeFromParentViewController];
    [self performSegueWithIdentifier:kSearchWithGeoNumbersControllerSegueIdentifier sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kMapControllerSegueIdentifier]) {
        
        BOOL isGeolocationEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kLocationServiceEnabled];
        if (isGeolocationEnabled) {
            
            GMPMapController *controller = (GMPMapController *)segue.destinationViewController;
            controller.currentSearchType = GMPSearchTypeCurrentPlacing;
            
        } else {
            [GMPAlertService showChangeLocationPermissionsAlertForController:self
                                                               andCompletion:nil];
        }
    }
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitleView:self.appLanguageSwitchController.view];

    self.navigationItem.rightBarButtonItem = [GMPSerialViewsConstructor customBarButtonWithImage:[UIImage imageNamed:kAboutImageName]
                                                                                  forController:self
                                                                                     withAction:@selector(aboutClick)];
    
    // Set transparent UIView to right bar button so the title view will be centered horizontally
    CGRect rightButtonRect = CGRectMake(0, 0, self.navigationItem.rightBarButtonItem.image.size.width, self.navigationItem.rightBarButtonItem.image.size.height);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:rightButtonRect]];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)aboutClick
{
    [self.appLanguageSwitchController removeFromParentViewController];
    [self performSegueWithIdentifier:kAboutControllerSegueIdentifier sender:self];
}

@end
