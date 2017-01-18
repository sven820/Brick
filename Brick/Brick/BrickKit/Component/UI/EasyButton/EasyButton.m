//
//  EasyButton.m
//  YXY
//
//  Created by jinxiaofei on 16/10/9.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "EasyButton.h"

@interface EasyButton ()
@property(nonatomic, assign) UIEdgeInsets contentInsets;
@property(nonatomic, assign) UIEdgeInsets iconInsets;
@property(nonatomic, assign) UIEdgeInsets titleInsets;
@property(nonatomic, assign) EasyBtnType btnType;
@property (nonatomic, assign) BOOL isSetIconRound;

@end
@implementation EasyButton
- (void)configTabItemBtn:(EasyBtnType)btnType contentInsets:(UIEdgeInsets)contentInsets titleInsets:(UIEdgeInsets)titleInsets iconInsets:(UIEdgeInsets)iconInsets isSetIconRound:(BOOL)isSetIconRound
{
    self.btnType = btnType;
    self.contentInsets = contentInsets;
    self.iconInsets = iconInsets;
    self.titleInsets = titleInsets;
    self.isSetIconRound = isSetIconRound;
    
    if (self.isSetIconRound)
    {
        self.imageView.layer.cornerRadius = self.imageView.image.size.width * 0.5;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.titleLabel && !self.imageView.image)
    {
        CGFloat centerX = self.bounds.size.width * 0.5;
        CGFloat centerY = self.bounds.size.height * 0.5;
        self.titleLabel.center = CGPointMake(centerX, centerY);
        return;
    }
    else if(self.imageView.image && !(self.titleLabel.text && self.titleLabel.text.length > 0))
    {
        CGFloat centerX = self.bounds.size.width * 0.5;
        CGFloat centerY = self.bounds.size.height * 0.5;
        self.imageView.center = CGPointMake(centerX, centerY);
        return;
    }
    
    switch (self.btnType) {
        case EasyBtnTypeHorizontaIconTitle:
        {
            CGFloat iconCenterX = self.imageView.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.iconInsets.left -self.iconInsets.right;
            CGFloat iconCenterY = self.bounds.size.height * 0.5;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            
            CGFloat titleCenterX = CGRectGetMaxX(self.imageView.frame) +self.titleLabel.bounds.size.width * 0.5 + self.titleInsets.left -self.titleInsets.right;
            CGFloat titleCenterY = self.imageView.center.y + self.titleInsets.top - self.titleInsets.bottom;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            break;
        }
        case EasyBtnTypeBtnTypeHorizontaTitleIcon:
        {
            CGFloat titleCenterX = self.titleLabel.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.titleInsets.left -self.titleInsets.right;
            CGFloat titleCenterY = self.bounds.size.height * 0.5;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            
            CGFloat iconCenterX = CGRectGetMaxX(self.titleLabel.frame) + self.imageView.bounds.size.width * 0.5 + self.iconInsets.left -self.iconInsets.right;
            CGFloat iconCenterY = self.titleLabel.center.y + self.iconInsets.left -self.iconInsets.right;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            break;
        }
        case EasyBtnTypeBtnTypeVerticalIconTitle:
        {
            CGFloat iconCenterX = self.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.iconInsets.left -self.iconInsets.right;
            CGFloat iconCenterY = self.imageView.bounds.size.height * 0.5 + self.contentInsets.top - self.contentInsets.bottom + self.iconInsets.top - self.iconInsets.bottom;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            
            CGFloat titleCenterX = self.imageView.center.x;
            CGFloat titleCenterY = CGRectGetMaxY(self.imageView.frame) + self.titleLabel.bounds.size.height * 0.5 + self.titleInsets.top - self.titleInsets.bottom;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            break;
        }
        case EasyBtnTypeBtnTypeVerticalTitleIcon:
        {
            CGFloat titleCenterX = self.bounds.size.width * 0.5 + self.contentInsets.left - self.contentInsets.right + self.titleInsets.left -self.titleInsets.right;
            CGFloat titleCenterY = self.titleLabel.bounds.size.height * 0.5 + self.contentInsets.top - self.contentInsets.bottom + self.titleInsets.top - self.titleInsets.bottom;
            self.titleLabel.center = CGPointMake(titleCenterX, titleCenterY);
            
            CGFloat iconCenterX = self.titleLabel.center.x;
            CGFloat iconCenterY = CGRectGetMaxY(self.titleLabel.frame) + self.imageView.bounds.size.height * 0.5 + self.iconInsets.top - self.iconInsets.bottom;
            self.imageView.center = CGPointMake(iconCenterX, iconCenterY);
            break;
        }
    }
}
@end
