//
//  TemplateTableViewCell.h
//  Brick
//
//  Created by jinxiaofei on 16/9/21.
//  Copyright © 2016年 jinxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateTableViewCell : UITableViewCell

+ (CGFloat)calculateCellHeightWithModel:(id)model;
- (void)configCellWithModel:(id)model;
@end
