//
//  CBWActivityViewHeader.m
//  CBWRefresh
//
//  Created by 陈博文 on 16/6/3.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "CBWActivityViewHeader.h"

#import "CBWRefreshConst.h"
#import "UIView+CBWFrame.h"

@interface CBWActivityViewHeader ()

/** label*/
@property (nonatomic ,strong) UILabel *tipsLabel;
/** timeLabel*/
@property (nonatomic ,strong) UILabel *timeLabel;
/** activityIndicatorView*/
@property (nonatomic ,strong) UIActivityIndicatorView *activityIndicatorView;
/** arrowView*/
@property (nonatomic ,strong) UIImageView *arrowView;
/** 最近的时间*/
@property (nonatomic ,copy) NSString *lastTime;
@end

@implementation CBWActivityViewHeader


-(void)layoutSubviews{
    
    [super layoutSubviews];

    //这里时间可以设置 label的高度,但是一定要设置 width 否则显示不出来
    self.tipsLabel.x = 0;
    self.tipsLabel.y = 0;
    self.tipsLabel.height = self.height * 0.5;
    self.tipsLabel.width = self.width ;
    
    self.timeLabel.x = 0;
    self.timeLabel.y = CGRectGetMaxY( self.tipsLabel.frame);
    self.timeLabel.height = self.height * 0.5;
    self.timeLabel.width = self.width;

    float centerX = self.width * 0.5 - 100;
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
            self.tipsLabel.text = @"下拉加载更多";
            [UIView animateWithDuration:CBWRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;;
            }];

        }
            break;
        case CBWRefreshStatePulling:
        {
            self.tipsLabel.text = @"松开立即刷新";
            [UIView animateWithDuration:CBWRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];

        }
            break;
        case CBWRefreshStateRefreshing:
        {
            self.tipsLabel.text = @"正在刷新数据...";
            [self setLoading];
            [_activityIndicatorView startAnimating];
            
            [self setLastRefreshTime];//设置时间
            
        }
            break;
        case CBWRefreshStateWillRefresh:
        {
            self.tipsLabel.text = @"即将刷新的状态";
          
        }
            break;
        case CBWRefreshStateNoMoreData:
        {
            self.tipsLabel.text = @"没有更多的数据了";
           
        }
            break;
        default:
            break;
    }
    
}

- (void)setNormal{
    
    self.activityIndicatorView.hidden = YES;
    self.arrowView.hidden = NO;
    [self getLastRefreshTime];
}

- (void)setLoading{
    
    self.activityIndicatorView.hidden = NO;
    self.arrowView.hidden = YES;
}

#pragma mark - private

- (void)setLastRefreshTime{

    // 1.归档
    // 2.保存刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:CBWRefreshHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
 }

- (void)getLastRefreshTime{
    
 
    //bu 知道为什么是 str
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:CBWRefreshHeaderTimeKey];
    
    
    
    if ([lastUpdatedTime isKindOfClass:[NSString class]]) {return;}
    
    if (lastUpdatedTime) {
        // 1.获得年月日
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([cmp1 day] == [cmp2 day]) { // 今天
            formatter.dateFormat = @"今天 HH:mm";
        } else if ([cmp1 year] == [cmp2 year]) { // 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        //3.显示日期
        self.timeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    } else {
        self.timeLabel.text = @"最后更新：无记录";
    }
}



#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}


#pragma mark - setter && getter

- (UILabel *)tipsLabel{
    
    if (_tipsLabel == nil) {
        
        UILabel *tipsLabel = [[UILabel alloc]init];
        tipsLabel.text = @"这是刷新控件";
        tipsLabel.textColor = [UIColor blackColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:fontSize];
        [self addSubview:tipsLabel];
        
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

-(UILabel *)timeLabel{
    
    if (_timeLabel == nil) {
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.text = @"最后刷新时间:无记录";
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:fontSize];
        [self addSubview:timeLabel];
        
        _timeLabel = timeLabel;
    }
    return _timeLabel;
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

        _arrowView = [[UIImageView alloc]initWithImage:image];
        
        [self addSubview:_arrowView];
        
    }
    return _arrowView;
}
@end
