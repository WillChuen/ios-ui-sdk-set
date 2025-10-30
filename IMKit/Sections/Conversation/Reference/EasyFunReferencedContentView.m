//
//  EasyFunReferencedContentView.m
//  RongCloudOpenSource
//
//  Created by zhongwei on 2025/10/30.
//

#import "EasyFunReferencedContentView.h"
#import "RCKitUtility.h"
#import "EasyFunReferencedTextView.h"
#import "EasyFunReferencedImageView.h"
#import "EasyFunReferencedSightView.h"
#import "EasyFunReferencedLinkView.h"
#import "EasyFunReferencedGameView.h"
#import "RCKitCommonDefine.h"
#import "RCUserInfoCacheManager.h"
#import "RCMessageCellTool.h"
#import "RCKitConfig.h"
#import "RCIM.h"
#import "RCMessageEditUtil.h"
#import <Masonry/Masonry.h>

@interface EasyFunReferencedContentView()

@property (nonatomic, strong) RCMessageModel *referModel;
@property (nonatomic, strong) RCMessageContent *referedContent;
@property (nonatomic, copy) NSString *referedSenderId;
@property (nonatomic, assign) RCReferenceMessageStatus referMsgStatus;

@end

/// 引用内容视图
@implementation EasyFunReferencedContentView
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}

/// 设置UI
- (void)setupUI {
    //
    [self addSubview:self.backgroundContentView];
    [self.backgroundContentView addSubview:self.contentView];
    [self.contentView addSubview:self.nameLabel];
    //
    [self.backgroundContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.leading.mas_greaterThanOrEqualTo(self.mas_leading);
        make.trailing.mas_lessThanOrEqualTo(self.mas_trailing);
    }];
    //
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backgroundContentView.mas_top).offset(4);
        make.bottom.mas_equalTo(self.backgroundContentView.mas_bottom).offset(-4);
        make.leading.mas_equalTo(self.backgroundContentView.mas_leading).offset(12);
        make.trailing.mas_equalTo(self.backgroundContentView.mas_trailing).offset(-12);
    }];
    //
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.width.mas_lessThanOrEqualTo(100);
    }];
}

/// 设置消息内容
- (void)setMessage:(RCMessageModel *)message contentSize:(CGSize)contentSize {
    // 隐藏全部引用内容
    [self hideAllReferencedViews];
    // 重新设置UI
    [self setupUI];
    // 发送
    if (message.messageDirection == MessageDirection_SEND) {
        [self updateToRightAlignment];
    } else {
        [self updateToLeftAlignment];
    }
    // 引用消息
    self.referModel = message;
    if (![self fetchReferedContentInfo]) {
        return;
    }
    // 设置用户名称
    [self setUserDisplayName];
    // 设置内容
    [self setContentInfo];
}

/// 切换到左对齐
- (void)updateToLeftAlignment {
    [self.backgroundContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_lessThanOrEqualTo(self.mas_trailing);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

/// 切换到右对齐
- (void)updateToRightAlignment {
    [self.backgroundContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.leading.mas_greaterThanOrEqualTo(self.mas_leading);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (BOOL)fetchReferedContentInfo {
    // 引用消息类
    if ([self.referModel.content isKindOfClass:[RCReferenceMessage class]]) {
        RCReferenceMessage *content = (RCReferenceMessage *)self.referModel.content;
        self.referedContent = content.referMsg;
        self.referedSenderId = content.referMsgUserId;
        self.referMsgStatus = content.referMsgStatus;
        return YES;
        // 流式消息的类型名
    } else if ([self.referModel.content isKindOfClass:[RCStreamMessage class]]) {
        RCStreamMessage *content = (RCStreamMessage *)self.referModel.content;
        self.referedContent = content.referMsg.content;
        self.referedSenderId = content.referMsg.senderId;
        return YES;
    }
    return NO;
}

/// 在Cell重用的时候调用
- (void)prepareForReuse {
    [self hideAllReferencedViews];
}

/// 隐藏所有引用视图
- (void)hideAllReferencedViews {
    // 移除全部内容
    for (UIView * sub in self.subviews) {
        [sub removeFromSuperview];
    }
    self.backgroundContentView = nil;
    self.contentView = nil;
    self.nameLabel = nil;
    self.imageView = nil;
    self.sightView = nil;
    self.linkView = nil;
    self.gameView = nil;
    self.textView = nil;
}

- (void)setUserDisplayName {
    NSString *name;
    if ([self.referedContent.senderUserInfo.userId isEqualToString:self.referedSenderId] && [RCIM sharedRCIM].currentDataSourceType == RCDataSourceTypeInfoManagement) {
        name = [RCKitUtility getDisplayName:self.referedContent.senderUserInfo];
    } else {
        NSString *referUserId = self.referedSenderId;
        if (ConversationType_GROUP == self.referModel.conversationType) {
            RCUserInfo *userInfo =
            [[RCUserInfoCacheManager sharedManager] getUserInfo:referUserId inGroupId:self.referModel.targetId];
            self.referModel.userInfo = userInfo;
            if (userInfo) {
                name = userInfo.name;
            }
        } else {
            RCUserInfo *userInfo = [[RCUserInfoCacheManager sharedManager] getUserInfo:referUserId];
            self.referModel.userInfo = userInfo;
            if (userInfo) {
                name = userInfo.name;
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    dispatch_main_async_safe(^{
        if (name == nil || name.length == 0) {
            self.nameLabel.text = @"";
            self.nameLabel.hidden = YES; return;
        } else {
            self.nameLabel.hidden = NO;
        }
        if([RCKitUtility isRTL]) {
            weakSelf.nameLabel.text = [@":" stringByAppendingString:name ?: @""];
        } else {
            weakSelf.nameLabel.text = [name stringByAppendingString:@":"];
        }
    });
}

/// 设置内容
- (void)setContentInfo {
    
    if (self.referMsgStatus == RCReferenceMessageStatusDeleted) { // 引用被删除
        
        [self layoutTextView];
        [self.textView updateLableText:RCLocalizedString(@"ReferencedMessageDeleted")];
        
    }else if (self.referMsgStatus == RCReferenceMessageStatusRecalled) { // 引用被取消
        
        [self layoutTextView];
        [self.textView updateLableText:RCLocalizedString(@"ReferencedMessageRecalled")];
        
    } else if ([self.referedContent isKindOfClass:[RCFileMessage class]]) { // 引用文件消息
        
        [self layoutTextView];
        RCFileMessage *msg = (RCFileMessage *)self.referedContent;
        NSString * messageInfo = [NSString
            stringWithFormat:@"%@ %@", RCLocalizedString(@"RC:FileMsg"), msg.name];
        [self.textView updateLableText:messageInfo];
        
    }  else if ([self.referedContent isKindOfClass:[RCRichContentMessage class]]) { // 图文消息被引用
        
        [self layoutTextView];
        RCRichContentMessage *msg = (RCRichContentMessage *)self.referedContent;
        NSString * messageInfo = [NSString
            stringWithFormat:@"%@ %@", RCLocalizedString(@"RC:ImgTextMsg"), msg.title];
        [self.textView updateLableText:messageInfo];
        
    } else if ([self.referedContent isKindOfClass:[RCImageMessage class]]) { // 图片消息被引用
        
        [self layoutImageView];
        RCImageMessage *msg = (RCImageMessage *)self.referedContent;
        [self.imageView updateImageMessage:msg];
        
    } else if ([self.referedContent isKindOfClass:[RCTextMessage class]] ||
               [self.referedContent isKindOfClass:[RCReferenceMessage class]]) { // 文本消息 或者 引用消息被引用
        
        // 设置 text 之前设置 textColor，textLabel 的 attributeDictionary 设置才有效
        [self layoutTextView];
        NSString * messageInfo = [RCKitUtility formatMessage:self.referedContent
                                                 targetId:self.referModel.targetId
                                         conversationType:self.referModel.conversationType
                                             isAllMessage:YES];
        [self.textView updateLableText:messageInfo];
    }
}

/// 背景内容
- (UIView *)backgroundContentView {
    if (!_backgroundContentView) {
        _backgroundContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundContentView.backgroundColor = RCMASKCOLOR(0xEBECED, 1.0);
        _backgroundContentView.layer.cornerRadius = 6;
        _backgroundContentView.layer.masksToBounds = YES;
    }
    return _backgroundContentView;
}

/// 堆栈视图
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}

/// 显示用户名称的标签
- (RCBaseLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[RCBaseLabel alloc] initWithFrame:CGRectZero];
        _nameLabel.text = @"NAME";
        // 当文字超过100pt宽度时，尾部显示省略号
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

/// 显示文本引用的视图
- (EasyFunReferencedTextView *)textView {
    if (!_textView) {
        _textView = [[EasyFunReferencedTextView alloc] initWithFrame:CGRectZero];
        _textView.hidden = YES;
    }
    return _textView;
}

/// 布局文本引用视图
- (void)layoutTextView {
    self.textView.hidden = NO;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
}

/// 显示图片引用的视图
- (EasyFunReferencedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[EasyFunReferencedImageView alloc] initWithFrame:CGRectZero];
        _imageView.hidden = YES;
    }
    return _imageView;
}

/// 布局图片引用视图
- (void)layoutImageView {
    self.imageView.hidden = NO;
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
}

/// 显示小视频引用的视图
- (EasyFunReferencedSightView *)sightView {
    if (!_sightView) {
        _sightView = [[EasyFunReferencedSightView alloc] initWithFrame:CGRectZero];
        _sightView.hidden = YES;
    }
    return _sightView;
}

/// 布局小视频引用视图
- (void)layoutSightView {
    self.sightView.hidden = NO;
    [self.contentView addSubview:self.sightView];
    [self.sightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
}

/// 显示链接引用的视图
- (EasyFunReferencedLinkView *)linkView {
    if (!_linkView) {
        _linkView = [[EasyFunReferencedLinkView alloc] initWithFrame:CGRectZero];
        _linkView.hidden = YES;
    }
    return _linkView;
}

/// 布局链接引用视图
- (void)layoutLinkView {
    self.linkView.hidden = NO;
    [self.contentView addSubview:self.linkView];
    [self.linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
}

/// 显示游戏引用的视图
- (EasyFunReferencedGameView *)gameView {
    if (!_gameView) {
        _gameView = [[EasyFunReferencedGameView alloc] initWithFrame:CGRectZero];
        _gameView.hidden = YES;
    }
    return _gameView;
}

/// 布局游戏引用视图
- (void)layoutGameView {
    self.gameView.hidden = NO;
    [self.contentView addSubview:self.gameView];
    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
    }];
}

@end
