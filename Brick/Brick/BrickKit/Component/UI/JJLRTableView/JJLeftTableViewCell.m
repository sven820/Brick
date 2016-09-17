//
//  JJLeftTableViewCell.m
//  JJLRTableView
//
//  Created by jxf on 16/2/18.
//  Copyright © 2016年 JJ.sevn. All rights reserved.
//

#import "JJLeftTableViewCell.h"

@implementation JJLeftTableViewCell

+ (instancetype)leftTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *leftID = @"left";
    JJLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftID];
    if (!cell) {
        cell = [[JJLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
    }
    return cell;
}

@end
