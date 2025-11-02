//
//  RCMessageBaseCell.m
//  RongIMKit
//
//  Created by xugang on 15/1/28.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageBaseCell.h"
#import "RCKitCommonDefine.h"
#import "RCKitUtility.h"
#import "RCMessageSelectionUtility.h"
#import "RCAlertView.h"
#import "RCKitConfig.h"
#import "RCBaseButton.h"

/// 消息发送状态更新的Notification
NSString *const KNotificationMessageBaseCellUpdateSendingStatus = @"KNotificationMessageBaseCellUpdateSendingStatus";
/// 选择按钮尺寸
#define SelectButtonSize CGSizeMake(20, 20)
/// 选择按钮据屏幕左侧 5
#define SelectButtonSpaceLeft 8

///
@interface RCMessageBaseCell () {
    // 消息Cell点击的回调
    __weak id<RCMessageCellDelegate> _delegate;
}

/// 多选收拾
@property (nonatomic, strong) UITapGestureRecognizer *multiSelectTap;
/// 选择按钮
@property (nonatomic, strong) RCBaseButton *selectButton;

@end

@implementation RCMessageBaseCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupMessageBaseCellView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMessageBaseCellView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<RCMessageCellDelegate>)delegate {
    _delegate = delegate;
}

- (id<RCMessageCellDelegate>)delegate {
    return _delegate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBaseAutoLayout];
    [self updateUIForMultiSelect];
}

#pragma mark - Public Methods

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    NSLog(@"Warning, you not implement sizeForMessageModel:withCollectionViewWidth:referenceExtraHeight: method for "
          @"you custom cell %@",
          NSStringFromClass(self));
    return CGSizeMake(0, 0);
}

- (void)setDataModel:(RCMessageModel *)model {
    self.model = model;
    self.messageDirection = model.messageDirection;
    _isDisplayMessageTime = model.isDisplayMessageTime;
    if (self.isDisplayMessageTime) {
        NSString * timeText = [[RCKitConfig defaultConfig].custom stringFromTimeInterval:model.sentTime];
        [self.messageTimeLabel setText:timeText dataDetectorEnabled:NO];
    }

    [self setBaseAutoLayout];
    [self updateUIForMultiSelect];
}

#pragma mark - Private Methods

/// 设置基础UI
- (void)setupMessageBaseCellView {
    // 消息发送状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageCellUpdateSendingStatusEvent:)
                                                 name:KNotificationMessageBaseCellUpdateSendingStatus
                                               object:nil];
    self.model = nil;
    self.baseContentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.isDisplayReadStatus = NO;
    [self.contentView addSubview:_baseContentView];
}

/// 设置基础的UI布局
- (void)setBaseAutoLayout {
    // 显示时间内容
    if (self.isDisplayMessageTime) {
        CGSize timeTextSize_ = [RCKitUtility getTextDrawingSize:self.messageTimeLabel.text
                                                           font:[[RCKitConfig defaultConfig].font fontOfAnnotationLevel]
                                                constrainedSize:CGSizeMake(self.bounds.size.width, TIME_LABEL_HEIGHT)];
        timeTextSize_ = CGSizeMake(ceilf(timeTextSize_.width + 10), ceilf(timeTextSize_.height));

        self.messageTimeLabel.hidden = NO;
        [self.messageTimeLabel setFrame:CGRectMake((self.bounds.size.width - timeTextSize_.width) / 2, TIME_LABEL_TOP,
                                                   timeTextSize_.width, TIME_LABEL_HEIGHT)];
        [self.baseContentView setFrame:CGRectMake(0, CGRectGetMaxY(self.messageTimeLabel.frame) + TIME_LABEL_AND_BASE_CONTENT_VIEW_SPACE, self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.messageTimeLabel.frame) - TIME_LABEL_AND_BASE_CONTENT_VIEW_SPACE - BASE_CONTENT_VIEW_BOTTOM)];
        // 不显示时间内容
    } else {
        if (self.messageTimeLabel) {
            self.messageTimeLabel.hidden = YES;
        }
        [self.baseContentView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - (BASE_CONTENT_VIEW_BOTTOM))];
    }
}

/// 消息发送状态更新的通知回调
- (void)messageCellUpdateSendingStatusEvent:(NSNotification *)notification {
    DebugLog(@"%s", __FUNCTION__);
}

#pragma mark - Multi select
/// 多选状态改变的通知回调
- (void)onChangedMessageMultiSelectStatus:(NSNotification *)notification {
    [self setDataModel:self.model];
}

/// 更新多选UI
- (void)updateUIForMultiSelect {
    // 移除多选手势
    [self.contentView removeGestureRecognizer:self.multiSelectTap];
    // 开启多选
    if ([RCMessageSelectionUtility sharedManager].multiSelect) {
        self.baseContentView.userInteractionEnabled = NO;
        if (self.allowsSelection) {
            self.selectButton.hidden = NO;
            [self.contentView addGestureRecognizer:self.multiSelectTap];
        } else {
            self.selectButton.hidden = YES;
        }
        //
    } else {
        self.baseContentView.userInteractionEnabled = YES;
        self.selectButton.hidden = YES;
        CGRect frame = self.baseContentView.frame;
        frame.origin.x = 0;
        self.baseContentView.frame = frame;
        return;
    }
    // 更新选择按钮状态
    [self updateSelectButtonStatus];

    CGRect frame = self.baseContentView.frame;
    CGFloat selectButtonY = frame.origin.y +
                            (RCKitConfigCenter.ui.globalMessagePortraitSize.height - SelectButtonSize.height) /
                                2; // 如果消息有头像，头像距离 baseContentView 顶部距离为 10
    if (MessageDirection_RECEIVE == self.model.messageDirection) {
        if (frame.origin.x < 3) { // cell不是左顶边的时候才会偏移
            if ([RCKitUtility isRTL]) {
                frame.origin.x = frame.origin.x - 12 - SelectButtonSpaceLeft;
            } else {
                frame.origin.x = SelectButtonSpaceLeft + 12;
            }
        }
        self.baseContentView.frame = frame;
    }
    CGRect selectButtonFrame = CGRectMake(SelectButtonSpaceLeft, selectButtonY, 20, 20);
    if ([RCKitUtility isRTL]) {
        if (MessageDirection_RECEIVE == self.model.messageDirection) {
            selectButtonFrame.origin.x = frame.origin.x + frame.size.width - SelectButtonSpaceLeft;
        } else {
            selectButtonFrame.origin.x = CGRectGetMaxX(frame) - SelectButtonSpaceLeft - 20;
        }
    }
    self.selectButton.frame = selectButtonFrame;
}

/// 设置是否允许选择
- (void)setAllowsSelection:(BOOL)allowsSelection {
    _allowsSelection = allowsSelection;
    if (self.model) {
        [self updateUIForMultiSelect];
    }
}

/// 选择事件
- (void)onSelectMessageEvent {
    //
    if ([[RCMessageSelectionUtility sharedManager] isContainMessage:self.model]) {
        [[RCMessageSelectionUtility sharedManager] removeMessageModel:self.model];
        [self updateSelectButtonStatus];
    } else {
        if ([RCMessageSelectionUtility sharedManager].selectedMessages.count >= 100) {
            [RCAlertView showAlertController:nil message:RCLocalizedString(@"ChatTranscripts") cancelTitle:RCLocalizedString(@"OK")];
        } else {
            [[RCMessageSelectionUtility sharedManager] addMessageModel:self.model];
            [self updateSelectButtonStatus];
        }
    }
}

/// 更新选择按钮状态
- (void)updateSelectButtonStatus {
    NSString *imgName = [[RCMessageSelectionUtility sharedManager] isContainMessage:self.model]
                            ? @"message_cell_select"
                            : @"message_cell_unselect";
    UIImage *image = RCResourceImage(imgName);
    [self.selectButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Getters and Setters
/// 选择按钮
- (RCBaseButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[RCBaseButton alloc] initWithFrame:CGRectZero];
        [_selectButton setImage:RCResourceImage(@"message_cell_unselect") forState:UIControlStateNormal];
        [_selectButton addTarget:self
                          action:@selector(onSelectMessageEvent)
                forControlEvents:UIControlEventTouchUpInside];
        _selectButton.hidden = YES;
        [self.contentView addSubview:_selectButton];
        CGRect selectButtonFrame = CGRectMake(SelectButtonSpaceLeft, 0, 20, 20);
        _selectButton.frame = selectButtonFrame;
    }
    return _selectButton;
}

/// 多选手势
- (UITapGestureRecognizer *)multiSelectTap {
    if (!_multiSelectTap) {
        _multiSelectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectMessageEvent)];
        _multiSelectTap.numberOfTapsRequired = 1;
        _multiSelectTap.numberOfTouchesRequired = 1;
    }
    return _multiSelectTap;
}

/// 大量cell不显示时间，使用延时加载
- (RCTipLabel *)messageTimeLabel {
    if (!_messageTimeLabel) {
        _messageTimeLabel = [RCTipLabel greyTipLabel];
        _messageTimeLabel.backgroundColor = [UIColor clearColor];
        _messageTimeLabel.textColor = RCDYCOLOR(0xA0A5AB, 0x585858);
        _messageTimeLabel.font = [[RCKitConfig defaultConfig].font fontOfAnnotationLevel];
        [self.contentView addSubview:_messageTimeLabel];
    }
    return _messageTimeLabel;
}
@end
