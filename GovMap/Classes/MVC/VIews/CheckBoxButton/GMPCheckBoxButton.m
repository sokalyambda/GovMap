//
//  GMPCheckBoxButton.m
//  Relocate
//
//  Created by Myroslava Polovka on 10/14/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "GMPCheckBoxButton.h"

@interface GMPCheckBoxButton ()

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *selectedImage;

@property (strong, nonatomic) NSString *notSelectedImageName;
@property (strong, nonatomic) NSString *selectedImageName;

@end

@implementation GMPCheckBoxButton

#pragma mark - Lifecycle

-(void)awakeFromNib
{
    [self setSelectedImageName:@"check_button_selected"];
    [self setNotSelectedImageName:@"check_button_unselected"];
}

#pragma mark - Accessors

- (void)setSelectedImageName:(NSString *)newValue
{
    _selectedImageName = [newValue copy];
    self.selectedImage = [UIImage imageNamed:_selectedImageName];
}

- (void)setNotSelectedImageName:(NSString *)newValue
{
    _notSelectedImageName = [newValue copy];
    self.notSelectedImage = [UIImage imageNamed: _notSelectedImageName];
}

- (void)setSelected:(BOOL)isSelected
{
    if (isSelected != self.isSelected) {
        [super setSelected:isSelected];
        if (isSelected){
            [self setImage:_selectedImage forState: UIControlStateNormal];
        } else {
            [self setImage:_notSelectedImage forState: UIControlStateNormal];
        }
    }
}

- (void)setNotSelectedImage:(UIImage*)newImage
{
    _notSelectedImage = newImage;
    if (!self.isSelected) {
        [self setImage:_notSelectedImage forState: UIControlStateNormal];
    }
}

- (void)setSelectedImage:(UIImage*)newImage
{
    _selectedImage = newImage;
    if (self.isSelected) {
        [self setImage:_selectedImage forState: UIControlStateNormal];
    }
}

#pragma mark - UIControl methods

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    if (CGRectContainsPoint(self.bounds, [touch locationInView:self])) {
        self.selected = !self.selected;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Public Methods

- (void)animate
{
    [self setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
    [UIView animateWithDuration:0.2f animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
        self.alpha = 1.f;
    }];
}

@end
