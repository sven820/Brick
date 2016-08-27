//
//  JJRightTableViewCell.m
//  JJLRTableView
//
//  Created by jxf on 16/2/18.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJRightTableViewCell.h"

@implementation JJRightTableViewCell

+ (instancetype)rightTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *rightID = @"right";
    JJRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightID];
    if (!cell) {
        cell = [[JJRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
    }
    return cell;
}
@end
