//
//  RCReferencingView.m
//  RongIMKit
//
//  Created by 张改红 on 2020/2/27.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import "RCReferencingView.h"
#import "RCKitUtility.h"
#import "RCKitCommonDefine.h"
#import "RCUserInfoCacheManager.h"
#import "RCKitConfig.h"
#import "RCIM.h"
#import "RCStreamUtilities.h"
#import "RCStreamMessage+Internal.h"
#import "EasyFunReferencedTextView.h"
#import "EasyFunReferencedImageView.h"
#import "EasyFunReferencedSightView.h"
#import "EasyFunReferencedLinkView.h"
#import "EasyFunReferencedGameView.h"
#import <Masonry/Masonry.h>

@interface RCReferencingView ()
@property (nonatomic, strong) UIView *inView;
@end

#define textlabel_left_space 12
#define textlabel_and_dismiss_space 12
#define dismiss_right_space 8
#define dismiss_width 18
#define content_lefeding_space 12
#define content_top_space 10
#define content_bottom_space 10

#define referencingView_height 32
#define referencingView_image_height 39

@implementation RCReferencingView

/// 初始化引用视图
- (instancetype)initWithModel:(RCMessageModel *)model inView:(UIView *)view {
    if (self = [super init]) {
        self.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xffffff) darkColor:HEXCOLOR(0x1c1c1c)];
        self.inView = view;
        self.referModel = model;
        [self addNotification];
        [self setupSubviews];
        [self setContentInfo];
        [self addTapGesture];
    }
    return self;
}

/// 设置引用视图的Y偏移量
- (void)setOffsetY:(CGFloat)offsetY {
    [UIView animateWithDuration:0.25
                     animations:^{
        CGRect rect = self.frame;
        rect.origin.y = offsetY;
        self.frame = rect;
    }];
}

#pragma mark - Private Methods

/// 设置子视图
- (void)setupSubviews {
    //
    CGFloat maxWidth = self.inView.frame.size.width - 24;
    CGFloat referencingViewHeight = [self calculateReferencingViewHeight:maxWidth];
    self.frame = CGRectMake(0, self.inView.frame.size.height, self.inView.frame.size.width, referencingViewHeight);
    //
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.dismissButton];
    //
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(12);
        make.top.mas_equalTo(self.mas_top);
        make.trailing.mas_equalTo(self.mas_trailing).inset(12);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(dismiss_width);
        make.height.mas_equalTo(dismiss_width);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).inset(dismiss_right_space);
    }];
}

/// 计算引用视图高度
- (CGFloat)calculateReferencingViewHeight:(CGFloat)maxWidth {
    //
    if ([self.referModel.content isKindOfClass:[RCFileMessage class]]) { // 引用的是文件消息
        return referencingView_height;
    } else if ([self.referModel.content isKindOfClass:[RCRichContentMessage class]]) { // 引用的是图文消息
        return referencingView_image_height;
    } else if ([self.referModel.content isKindOfClass:[RCImageMessage class]]) { // 引用的是图片消息
        return referencingView_image_height;
    } else if ([self.referModel.content isKindOfClass:[RCSightMessage class]]) { // 引用的是视频消息
        return referencingView_image_height;
    } else if ([self.referModel.content isKindOfClass:[RCTextMessage class]] || [self.referModel.content isKindOfClass:[RCReferenceMessage class]]) { // 引用的是文本消息或者引用消息
        
        NSString * nameContent = [self getNameContent];
        NSString * contentText = [RCKitUtility formatMessage:self.referModel.content targetId:self.referModel.targetId conversationType:self.referModel.conversationType isAllMessage:YES];
        NSString * completeContent = [NSString stringWithFormat:@"%@%@", nameContent, contentText];
        UIFont * contentFont = self.textReferView.textLabel.font;
        // 计算内容宽度
        CGSize contentSize = [RCKitUtility getTextDrawingSize:completeContent font: contentFont constrainedSize:CGSizeMake(maxWidth - content_lefeding_space - textlabel_and_dismiss_space - dismiss_width - dismiss_right_space, CGFLOAT_MAX)];
        // 最小的高度
        if (contentSize.height < referencingView_height) {
            return referencingView_height;
        }
        // 最大的高度
        if (contentSize.height > contentFont.lineHeight * 2) {
            return ceil(contentFont.lineHeight * 2 + content_top_space + content_bottom_space);
        }
        // 返回文本内容的高度
        return ceil(contentSize.height + content_top_space + content_bottom_space);
        
    } else if ([self.referModel.content isKindOfClass:[RCStreamMessage class]]) { // 引用的是流式消息
        return referencingView_height;
    } else if ([[[self.referModel.content class] getObjectName] isEqualToString:@"LD:GameCardMsg"]) { // 游戏卡片
        return referencingView_height;
    } else if ([[[self.referModel.content class] getObjectName] isEqualToString:@"LD:LinkCardMsg"]) { // 连接卡片
        return referencingView_height;
    } else if ([self.referModel.content isKindOfClass:[RCMessageContent class]]) { // 引用其他类型消息
        return referencingView_height;
    } else {
        return referencingView_height;
    }
}

/// 添加点击事件
- (void)addTapGesture {
    
    UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
    [self.contentView addGestureRecognizer:tapGesture];
}

/// 设置引用内容
- (void)setContentInfo {
    //
    if ([self.referModel.content isKindOfClass:[RCFileMessage class]]) { // 引用的是文件消息
        
        RCFileMessage *msg = (RCFileMessage *)self.referModel.content;
        NSString * messageInfo = [NSString
                       stringWithFormat:@"%@ %@", RCLocalizedString(@"RC:FileMsg"), msg.name];
        [self layoutTextView:messageInfo];
        
    } else if ([self.referModel.content isKindOfClass:[RCRichContentMessage class]]) { // 引用的是图文消息
        
        RCRichContentMessage * richMessage = (RCRichContentMessage *)self.referModel.content;
        [self setRichContent:richMessage];
        
    } else if ([self.referModel.content isKindOfClass:[RCImageMessage class]]) { // 引用的是图片消息
        
        RCImageMessage * imageMessage = (RCImageMessage *)self.referModel.content;
        [self layoutImageView:imageMessage];
        
    } else if ([self.referModel.content isKindOfClass:[RCSightMessage class]]) { // 引用的是视频消息
        
        RCSightMessage * sightMessage = (RCSightMessage *)self.referModel.content;
        [self layoutSightView:sightMessage];
        
    } else if ([self.referModel.content isKindOfClass:[RCTextMessage class]] ||
               [self.referModel.content isKindOfClass:[RCReferenceMessage class]]) { // 引用的是文本消息或者引用消息
        
        NSString * messageInfo = [RCKitUtility formatMessage:self.referModel.content
                                         targetId:self.referModel.targetId
                                 conversationType:self.referModel.conversationType
                                     isAllMessage:YES];
        [self layoutTextView:messageInfo];
        
    } else if ([self.referModel.content isKindOfClass:[RCStreamMessage class]]) { // 引用的是流式消息
        
        RCStreamMessage *msg = (RCStreamMessage *)self.referModel.content;
        NSString * messageInfo;
        if (msg.isSync) {
            messageInfo = msg.content;
        } else {
            RCStreamSummaryModel *summary = [RCStreamUtilities parserStreamSummary:self.referModel];
            if (summary.isComplete) {
                messageInfo = summary.summary;
                msg.content = summary.summary;
            }
        }
        [self layoutTextView:messageInfo];
        
    } else if ([[[self.referModel.content class] getObjectName] isEqualToString:@"LD:GameCardMsg"]) { // 游戏卡片
        
        [self layoutGameView:self.referModel.content];
        
    } else if ([[[self.referModel.content class] getObjectName] isEqualToString:@"LD:LinkCardMsg"]) { // 连接卡片
        
        [self layoutLinkView:self.referModel.content];
        
    } else if ([self.referModel.content isKindOfClass:[RCMessageContent class]]) { // 引用其他类型消息
        
        NSString * messageInfo = [RCKitUtility formatMessage:self.referModel.content
                                         targetId:self.referModel.targetId
                                 conversationType:self.referModel.conversationType
                                     isAllMessage:YES];
        if (messageInfo <= 0 ||
            [messageInfo isEqualToString:[[self.referModel.content class] getObjectName]]) {
            messageInfo = RCLocalizedString(@"unknown_message_cell_tip");
        }
        [self layoutTextView:messageInfo];
    }
}

/// 设置用户昵称
- (NSString *)getNameContent {
    // 设置用户昵称
    if([RCKitUtility isRTL]) {
        return [NSString stringWithFormat:@":%@",[self getUserDisplayName]];
    }else{
        return [NSString stringWithFormat:@"%@：",[self getUserDisplayName]];
    }
}

/// 点击关闭按钮
- (void)didClickDismissButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissReferencingView:)]) {
        [self.delegate dismissReferencingView:self];
    }
}

/// 获取用户显示名称
- (NSString *)getUserDisplayName {
    // 优先使用消息内的用户信息
    if ([self.referModel.content.senderUserInfo.userId isEqualToString:self.referModel.senderUserId] && [RCIM sharedRCIM].currentDataSourceType == RCDataSourceTypeInfoManagement) {
        return [RCKitUtility getDisplayName:self.referModel.content.senderUserInfo];
    }
    NSString *name;
    if (ConversationType_GROUP == self.referModel.conversationType) {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.referModel.senderUserId
                                                                         inGroupId:self.referModel.targetId];
        self.referModel.userInfo = userInfo;
        if (userInfo) {
            name = userInfo.name;
        }
    } else {
        RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:self.referModel.senderUserId];
        self.referModel.userInfo = userInfo;
        if (userInfo) {
            name = userInfo.name;
        }
    }
    return name;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUserInfoUpdate:)
                                                 name:RCKitDispatchUserInfoUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGroupUserInfoUpdate:)
                                                 name:RCKitDispatchGroupUserInfoUpdateNotification
                                               object:nil];
}

- (void)didTapContentView:(id)sender {
    // 再通知代理跳转到被引用消息
    if ([self.delegate respondsToSelector:@selector(didTapReferencingView:)]) {
        [self.delegate didTapReferencingView:self.referModel];
    }
    // 先强制引用视图
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissReferencingViewForce:)]) {
        [self.delegate dismissReferencingViewForce:self];
    }
}

#pragma mark - UserInfo Update
- (void)onUserInfoUpdate:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.object;
    if ([self.referModel.senderUserId isEqualToString:userInfoDic[@"userId"]]) {
        // 重新取一下混合的用户信息
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setContentInfo];
        });
    }
}

- (void)onGroupUserInfoUpdate:(NSNotification *)notification {
    if (self.referModel.conversationType == ConversationType_GROUP) {
        NSDictionary *groupUserInfoDic = (NSDictionary *)notification.object;
        if ([self.referModel.targetId isEqualToString:groupUserInfoDic[@"inGroupId"]] &&
            [self.referModel.senderUserId isEqualToString:groupUserInfoDic[@"userId"]]) {
            // 重新取一下混合的用户信息
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setContentInfo];
            });
        }
    }
}

#pragma mark - Getters and Setters
/// 所有内容
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _contentView.backgroundColor = HEXCOLOR(0xEBECED);
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

/// 关闭引用 button
- (RCBaseButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [RCBaseButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [_dismissButton setImage:RCResourceImage(@"referencing_view_dismiss_icon") forState:UIControlStateNormal];
        [_dismissButton addTarget:self
                           action:@selector(didClickDismissButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

/// 文本引用内容
- (EasyFunReferencedTextView *)textReferView {
    if (!_textReferView) {
        _textReferView = [[EasyFunReferencedTextView alloc] initWithFrame:CGRectZero];
        _textReferView.textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _textReferView.textLabel.font = [UIFont systemFontOfSize:12];
    }
    return _textReferView;
}

/// 设置文本引用内容
- (void)layoutTextView:(NSString *)messageInfo {
    // 替换换行符为空格
    NSString * nameContent = [self getNameContent];
    NSString * completeContent = [NSString stringWithFormat:@"%@%@", nameContent, messageInfo];
    completeContent = [completeContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    completeContent = [completeContent stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    completeContent = [completeContent stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    //
    [self.contentView addSubview:self.textReferView];
    [self.textReferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(content_lefeding_space);
        make.trailing.mas_lessThanOrEqualTo(self.dismissButton.mas_leading).inset(textlabel_and_dismiss_space);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.textReferView updateLableText:completeContent];
}

/// 图片引用内容
- (EasyFunReferencedImageView *)imageReferView {
    if (!_imageReferView) {
        _imageReferView = [[EasyFunReferencedImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageReferView;
}

/// 设置图文引用内容
- (void)setRichContent:(RCRichContentMessage *)richMessage {
    //
    [self.contentView addSubview:self.imageReferView];
    [self.imageReferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(content_lefeding_space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    NSString * nameContent = [self getNameContent];
    [self.imageReferView updateNameLabelText:nameContent];
    [self.imageReferView updateRichContentMessage:richMessage];
}

/// 设置图片引用内容
- (void)layoutImageView:(RCImageMessage *)imageMessage {
    //
    [self.contentView addSubview:self.imageReferView];
    [self.imageReferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(content_lefeding_space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    NSString * nameContent = [self getNameContent];
    [self.imageReferView updateNameLabelText:nameContent];
    [self.imageReferView updateImageMessage:imageMessage];
}

/// 小视频引用内容
- (EasyFunReferencedSightView *)sightReferView {
    if (!_sightReferView) {
        _sightReferView = [[EasyFunReferencedSightView alloc] initWithFrame:CGRectZero];
    }
    return _sightReferView;
}

/// 设置小视频引用内容
- (void)layoutSightView:(RCSightMessage *)sightMessage {
    //
    [self.contentView addSubview:self.sightReferView];
    [self.sightReferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(content_lefeding_space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    NSString * nameContent = [self getNameContent];
    [self.sightReferView updateNameLabelText:nameContent];
    [self.sightReferView updateSightMessage:sightMessage];
}

/// 链接引用内容
- (EasyFunReferencedLinkView *)linkReferView {
    if (!_linkReferView) {
        _linkReferView = [[EasyFunReferencedLinkView alloc] initWithFrame:CGRectZero];
    }
    return _linkReferView;
}

/// 设置连接引用内容
- (void)layoutLinkView:(RCMessageContent *)messageContent {
    //
    [self.contentView addSubview:self.linkReferView];
    [self.linkReferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(content_lefeding_space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.contentView.mas_trailing);
    }];
    NSString * nameContent = [self getNameContent];
    [self.linkReferView updateNameLabelText:nameContent];
    [self.linkReferView updateMessageContent:messageContent];
}

/// 游戏引用内容
- (EasyFunReferencedGameView *)gameReferView {
    if (!_gameReferView) {
        _gameReferView = [[EasyFunReferencedGameView alloc] initWithFrame:CGRectZero];
    }
    return _gameReferView;
}

/// 设置游戏引用内容
- (void)layoutGameView:(RCMessageContent *)messageContent {
    //
    [self.contentView addSubview:self.gameReferView];
    [self.gameReferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(content_lefeding_space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.contentView.mas_trailing);
    }];
    NSString * nameContent = [self getNameContent];
    [self.gameReferView updateNameLabelText:nameContent];
    [self.gameReferView updateMessageContent:messageContent];
}

@end
