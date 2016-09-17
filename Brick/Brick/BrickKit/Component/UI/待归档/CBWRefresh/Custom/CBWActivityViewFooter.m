//
//  CBWActivityViewFooter.m
//  CBWRefresh
//
//  Created by 陈博文 on 16/6/3.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWActivityViewFooter.h"
#import "UIView+CBWFrame.h"
#import "CBWRefreshConst.h"

@interface CBWActivityViewFooter ()
/** label*/
@property (nonatomic ,strong) UILabel *label;
/** activityIndicatorView*/
@property (nonatomic ,strong) UIActivityIndicatorView *activityIndicatorView;
/** arrowView*/
@property (nonatomic ,strong) UIImageView *arrowView;
@end

@implementation CBWActivityViewFooter


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
        
    float centerX = self.width * 0.5 - 80;
    float centerY = self.height * 0.5;
    
    self.arrowView.center = CGPointMake(centerX, centerY);
    self.activityIndicatorView.center = CGPointMake(centerX, centerY);
  }

#pragma mark - 设置状态

-(void)setState:(CBWRefreshState)state{
    
    [super setState:state];
    
    [self setNormal];
    
    switch (state) {
        case CBWRefreshStateIdle:
        {
            self.label.text = @"上拉加载更多";
            [UIView animateWithDuration:CBWRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];

            
        }
            break;
        case CBWRefreshStatePulling:
        {
            self.label.text = @"松开立即刷新";
            
            [UIView animateWithDuration:CBWRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
           
        }
            break;
        case CBWRefreshStateRefreshing:
        {
            self.label.text = @"正在刷新数据...";

            [self setLoading];
            [self.activityIndicatorView startAnimating];
        }
            break;
        case CBWRefreshStateWillRefresh:
        {
            self.label.text = @"即将刷新的状态";
        }
            break;
        case CBWRefreshStateNoMoreData:
        {
            self.label.text = @"没有更多的数据了";
            self.arrowView.hidden = YES;
        }
            break;
        default:
            break;
    }
    
}

- (void)setNormal{
    
    self.activityIndicatorView.hidden = YES;
    self.arrowView.hidden = NO;
}

- (void)setLoading{
    
    self.activityIndicatorView.hidden = NO;
    self.arrowView.hidden = YES;
}

#pragma mark - setter && getter

- (UILabel *)label{
    
    if (_label == nil) {
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"这是刷新控件";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:fontSize];
        [self addSubview:label];
        
        _label = label;

    }
    
    return _label;
}
-(UIActivityIndicatorView *)activityIndicatorView{
    
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self addSubview:_activityIndicatorView];
        _activityIndicatorView.hidesWhenStopped = YES;
        
    }
    
    return _activityIndicatorView;
}

-(UIImageView *)arrowView{
    
    if (_arrowView == nil) {
        //看是否存在,不存在则用最后的
         UIImage *image = [UIImage imageNamed:CBWRefreshSrcName(@"arrow.png")] ?: [UIImage imageNamed:CBWRefreshFrameworkSrcName(@"arrow.png")];
//         NSLog(@"imageNamed%@",image);
        _arrowView = [[UIImageView alloc]initWithImage:image];
        
        [UIView animateWithDuration:CBWRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];

        [self addSubview:_arrowView];
        
    }
    return _arrowView;
}

@end
