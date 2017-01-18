//
//  YXYChatCell.m
//  YXY
//
//  Created by Captain Black on 16/7/22.
//  Copyright © 2016年 Guangzhou TalkHunt Information Technology Co., Ltd. All rights reserved.
//

#import "YXYChatCell.h"
#import "YXYChatHelper.h"

@interface YXYChatCell ()
@property (nonatomic, strong) YXYChatHelper *helper;

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIView *promptContentView; //顶部提示view, time/欢迎词等
@property (nonatomic, strong) UIView *chatContentView; //内容容器

@property (nonatomic, strong) UIImageView *promptBackgroundImageView;
@property (nonatomic, strong) UILabel *promptMsgLabel;

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UIImageView *bubbleBackgroundImageView;
@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) YXYChatCellAttributes *attributes;

@property (nonatomic, strong) YXYBubbleContentView *bubbleContent;

@end

@implementation YXYChatCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self drawViews];
        [self makeContraints];
    }
    return self;
}

+ (CGFloat)caculateCellHeightWithAttributes:(YXYChatCellAttributes *)attributes
{
    YXYChatCell *cell = [[YXYChatCell alloc] init];
    [cell configWithCellAttributes:attributes];
    
    CGRect rect = cell.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    cell.frame = rect;
    
    [cell layoutIfNeeded];
    return CGRectGetMaxY(cell.chatContentView.frame);
}

- (void)configWithCellAttributes:(YXYChatCellAttributes *)attributes
{
    self.attributes = attributes;
    [self.nameButton setTitle:attributes.name forState:UIControlStateNormal];
    [self.avatarButton sd_setImageWithURL:attributes.avatarImageUrl forState:UIControlStateNormal placeholderImage:nil];
    
    //chatContentView
    switch (attributes.cellType) {
        case YXYChatCellTypeLeft:
            [self configLayoutForLeftType];
            break;
        case YXYChatCellTypeRight:
            [self configLayoutForRightType];
            break;

    }
    
    YXYBubbleContentView *bubbleContent;
    switch (attributes.bubbleType) {
        case YXYChatBubbleContentTypeText:
        {
            if (attributes.text)
            {
                bubbleContent = [self.helper dequeContentViewWithText:attributes.text bubbleContentView:self.bubbleContent];
            }
        }
            break;
        case YXYChatBubbleContentTypeImage:
            bubbleContent = [self.helper dequeContentViewWithImage:attributes.imageUrl bubbleContentView:self.bubbleContent];
            break;
        case YXYChatBubbleContentTypeGifImage:
            bubbleContent = [self.helper dequeContentViewWithGifImage:attributes.gifImageUrl bubbleContentView:self.bubbleContent];
            break;
        case YXYChatBubbleContentTypeAudio:
            
            break;
        case YXYChatBubbleContentTypeCustom:
            
            break;
    }
    
    [self makeContraintsForBubble:bubbleContent];
}

#pragma mark - draw views
- (void)drawViews
{
    [self.contentView addSubview:self.promptContentView];
    [self.contentView  addSubview:self.chatContentView];
    
    [self.promptContentView addSubview:self.promptBackgroundImageView];
    
    [self.chatContentView addSubview:self.avatarButton];
    [self.chatContentView addSubview:self.nameButton];
    [self.chatContentView addSubview:self.bubbleView];
    [self.chatContentView addSubview:self.statusView];
    
    [self.bubbleView addSubview:self.bubbleBackgroundImageView];
    
}

- (void)makeContraints
{
    [self.promptContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.promptContentView.superview;
        make.left.equalTo(superView);
        make.top.equalTo(superView);
        make.right.equalTo(superView);
        make.height.mas_equalTo(0);
    }];
    
    [self.chatContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.chatContentView.superview;
        make.left.right.equalTo(superView);
        make.top.equalTo(self.promptContentView.mas_bottom).offset(8);
    }];
    
    [self.promptBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        __weak UIView *superView = self.promptBackgroundImageView.superview;
        make.edges.equalTo(superView).with.priorityLow();
    }];
}
#pragma mark - private

- (void)configLayoutForLeftType
{
    UIView *superview = [self.avatarButton superview];
    [self.chatContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(self.bubbleView).offset(8);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview).offset(8);
        make.top.equalTo(superview);
        make.width.height.equalTo(@30);
    }];
    [self.nameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).offset(8);
        make.top.equalTo(superview);
        make.right.lessThanOrEqualTo(@(-8));
    }];
    [self.bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameButton);
        make.top.equalTo(self.nameButton.mas_bottom).offset(2);
        make.bottom.lessThanOrEqualTo(superview).offset(-8);
    }];
    [self.statusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bubbleView);
        make.left.equalTo(self.bubbleView.mas_right).offset(2);
        make.right.lessThanOrEqualTo(superview).offset(-8);
        make.width.height.equalTo(@32);
    }];
    [self.bubbleBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubbleView);
    }];
}

- (void)configLayoutForRightType
{
    UIView *superview = [self.avatarButton superview];
    [self.chatContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.greaterThanOrEqualTo(self.bubbleView).offset(8);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).offset(-8);
        make.top.equalTo(superview);
        make.width.height.equalTo(@30);
    }];
    [self.nameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarButton.mas_left).offset(-8);
        make.top.equalTo(superview);
        make.left.greaterThanOrEqualTo(@8);
    }];
    [self.bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nameButton);
        make.top.equalTo(self.nameButton.mas_bottom).offset(2);
        make.bottom.lessThanOrEqualTo(superview).offset(-8);
    }];
    [self.statusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bubbleView);
        make.right.equalTo(self.bubbleView.mas_left).offset(-2);
        make.left.greaterThanOrEqualTo(superview).offset(8);
        make.width.height.equalTo(@32);
    }];
    [self.bubbleBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubbleView);
    }];
}

- (void)configLayoutForPromptType
{
    
}
- (void)makeContraintsForBubble:(YXYBubbleContentView *)bubbleContent
{
    if (!bubbleContent.superview)
    {
        [self.bubbleView addSubview:bubbleContent];
        self.bubbleContent = bubbleContent;
        
        [bubbleContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            __weak UIView *superView = bubbleContent.superview;
            make.edges.equalTo(superView);
        }];
    }
    
    [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bubbleContent.bounds.size.width);
        make.height.mas_equalTo(bubbleContent.bounds.size.height);
    }];
}

#pragma mark - getter & setter
- (YXYChatHelper *)helper
{
    if (!_helper)
    {
        _helper = [YXYChatHelper helper];
    }
    return _helper;
}

- (UIView *)promptContentView
{
    if (!_promptContentView)
    {
        _promptContentView = [[UIView alloc]init];
        _promptContentView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:0.5];
    }
    return _promptContentView;
}

- (UIView *)chatContentView {
    if (!_chatContentView) {
        _chatContentView = [[UIView alloc] init];
        _chatContentView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _chatContentView;
}

- (UIImageView *)promptBackgroundImageView
{
    if (!_promptBackgroundImageView)
    {
        _promptBackgroundImageView = [[UIImageView alloc]init];
    }
    return _promptBackgroundImageView;
}

- (UILabel *)promptMsgLabel
{
    if (!_promptMsgLabel)
    {
        _promptMsgLabel = [[UILabel alloc]init];
        _promptMsgLabel.numberOfLines = 0;
    }
    return _promptMsgLabel;
}

- (UIButton *)avatarButton
{
    if (!_avatarButton)
    {
        _avatarButton = [[UIButton alloc] init];
        _avatarButton.backgroundColor = [UIColor blackColor];
    }
    return _avatarButton;
}

- (UIButton *)nameButton
{
    if (!_nameButton)
    {
        _nameButton = [[UIButton alloc] init];
        [_nameButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_nameButton setTitle:@"用户名" forState:UIControlStateNormal];
    }
    return _nameButton;
}

- (UIView *)bubbleView
{
    if (!_bubbleView)
    {
        _bubbleView = [[UIView alloc] init];
        _bubbleView.backgroundColor = [UIColor cyanColor];
    }
    return _bubbleView;
}

- (UIImageView *)bubbleBackgroundImageView
{
    if (!_bubbleBackgroundImageView)
    {
        _bubbleBackgroundImageView = [[UIImageView alloc] init];
    }
    return _bubbleBackgroundImageView;
}

- (UIView *)statusView
{
    if (!_statusView)
    {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = [UIColor grayColor];
    }
    return _statusView;
}
@end


@implementation YXYChatCellAttributes

@end
