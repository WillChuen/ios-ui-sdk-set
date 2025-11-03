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
#define textlabel_and_dismiss_space 8
#define dismiss_right_space 8
#define dismiss_width 18
#define referencingView_height 32

@implementation RCReferencingView

/// 初始化引用视图
- (instancetype)initWithModel:(RCMessageModel *)model inView:(UIView *)view {
    if (self = [super init]) {
        self.backgroundColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0xffffff) darkColor:HEXCOLOR(0x1c1c1c)];
        self.inView = view;
        self.referModel = model;
        [self addNotification];
        [self setupSubviews];
        [self setNameContent];
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
    CGFloat referencingViewHeight = referencingView_height;
    self.frame = CGRectMake(0, self.inView.frame.size.height, self.inView.frame.size.width, referencingViewHeight);
    //
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.dismissButton];
    [self.contentView addSubview:self.nameLabel];
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
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(textlabel_left_space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_lessThanOrEqualTo(100);
    }];
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
- (void)setNameContent {
    // 设置用户昵称
    if([RCKitUtility isRTL]){
        self.nameLabel.text = [NSString stringWithFormat:@":%@",[self getUserDisplayName]];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@：",[self getUserDisplayName]];
    }
}

/// 设置文本引用内容
- (void)layoutTextView:(NSString *)messageInfo {
    // 替换换行符为空格
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    messageInfo = [messageInfo stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    //
    [self.contentView addSubview:self.textReferView];
    [self.textReferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.trailing.mas_lessThanOrEqualTo(self.dismissButton.mas_leading).inset(8);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.textReferView updateLableText:messageInfo];
}

/// 设置图文引用内容
- (void)setRichContent:(RCRichContentMessage *)richMessage {
    //
    [self.contentView addSubview:self.imageReferView];
    [self.imageReferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.imageReferView updateRichContentMessage:richMessage];
}

/// 设置图片引用内容
- (void)layoutImageView:(RCImageMessage *)imageMessage {
    //
    [self.contentView addSubview:self.imageReferView];
    [self.imageReferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.imageReferView updateImageMessage:imageMessage];
}

/// 设置小视频引用内容
- (void)layoutSightView:(RCSightMessage *)sightMessage {
    //
    [self.contentView addSubview:self.sightReferView];
    [self.sightReferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.sightReferView updateSightMessage:sightMessage];
}

/// 设置连接引用内容
- (void)layoutLinkView:(RCMessageContent *)messageContent {
    //
    [self.contentView addSubview:self.linkReferView];
    [self.linkReferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.contentView.mas_trailing);
    }];
    [self.linkReferView updateMessageContent:messageContent];
}

/// 设置游戏引用内容
- (void)layoutGameView:(RCMessageContent *)messageContent {
    //
    [self.contentView addSubview:self.gameReferView];
    [self.gameReferView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.trailing.mas_lessThanOrEqualTo(self.contentView.mas_trailing);
    }];
    [self.gameReferView updateMessageContent:messageContent];
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
            [self setNameContent];
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
                [self setNameContent];
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

/// 被引用消息发送者名称
- (RCBaseLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[RCBaseLabel alloc] init];
        _nameLabel.textColor = [RCKitUtility generateDynamicColor:HEXCOLOR(0x111f2c) darkColor:RCMASKCOLOR(0xffffff, 0.4)];
        _nameLabel.font = [[RCKitConfig defaultConfig].font fontOfGuideLevel];
    }
    return _nameLabel;
}

/// 文本引用内容
- (EasyFunReferencedTextView *)textReferView {
    if (!_textReferView) {
        _textReferView = [[EasyFunReferencedTextView alloc] initWithFrame:CGRectZero];
    }
    return _textReferView;
}

/// 图片引用内容
- (EasyFunReferencedImageView *)imageReferView {
    if (!_imageReferView) {
        _imageReferView = [[EasyFunReferencedImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageReferView;
}

/// 小视频引用内容
- (EasyFunReferencedSightView *)sightReferView {
    if (!_sightReferView) {
        _sightReferView = [[EasyFunReferencedSightView alloc] initWithFrame:CGRectZero];
    }
    return _sightReferView;
}

/// 链接引用内容
- (EasyFunReferencedLinkView *)linkReferView {
    if (!_linkReferView) {
        _linkReferView = [[EasyFunReferencedLinkView alloc] initWithFrame:CGRectZero];
    }
    return _linkReferView;
}

/// 游戏引用内容
- (EasyFunReferencedGameView *)gameReferView {
    if (!_gameReferView) {
        _gameReferView = [[EasyFunReferencedGameView alloc] initWithFrame:CGRectZero];
    }
    return _gameReferView;
}

@end
