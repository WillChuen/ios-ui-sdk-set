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

/// 引用内容视图
@implementation EasyFunReferencedContentView

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

/// 设置UI
- (void)setupUI {
    //
    self.backgroundColor = [UIColor purpleColor];
    self.stackView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.stackView];
    [self.stackView addArrangedSubview:self.nameLabel];
    [self.stackView addArrangedSubview:self.textView];
    [self.stackView addArrangedSubview:self.imageView];
    [self.stackView addArrangedSubview:self.sightView];
    [self.stackView addArrangedSubview:self.linkView];
    [self.stackView addArrangedSubview:self.gameView];
    //
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sightView.translatesAutoresizingMaskIntoConstraints = NO;
    self.linkView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gameView.translatesAutoresizingMaskIntoConstraints = NO;
    //
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-12],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4],
        
        [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor],
        [self.nameLabel.widthAnchor constraintLessThanOrEqualToConstant:100],
        
        [self.textView.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
        
        [self.imageView.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
        
        [self.sightView.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor],
        [self.sightView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
        [self.sightView.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
        
        [self.linkView.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor],
        [self.linkView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
        [self.linkView.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
        
        [self.gameView.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor],
        [self.gameView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:4],
        [self.gameView.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor],
    ]];
    self.textView.hidden = NO;
    self.textView.textLabel.text = @"引用的文本内容引用的文本内容引用的文本内容引用的文本内容引用的文本内容引用的文本内容";
    self.nameLabel.backgroundColor = [UIColor yellowColor];
    self.textView.backgroundColor = [UIColor orangeColor];
}

/// 设置消息内容
- (void)setMessage:(RCMessageModel *)message contentSize:(CGSize)contentSize {
    
}

/// 堆栈视图
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 4.0;
    }
    return _stackView;
}

- (RCBaseLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[RCBaseLabel alloc] initWithFrame:CGRectZero];
        _nameLabel.text = @"TEXT";
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

/// 显示图片引用的视图
- (EasyFunReferencedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[EasyFunReferencedImageView alloc] initWithFrame:CGRectZero];
        _imageView.hidden = YES;
    }
    return _imageView;
}

/// 显示小视频引用的视图
- (EasyFunReferencedSightView *)sightView {
    if (!_sightView) {
        _sightView = [[EasyFunReferencedSightView alloc] initWithFrame:CGRectZero];
        _sightView.hidden = YES;
    }
    return _sightView;
}

/// 显示链接引用的视图
- (EasyFunReferencedLinkView *)linkView {
    if (!_linkView) {
        _linkView = [[EasyFunReferencedLinkView alloc] initWithFrame:CGRectZero];
        _linkView.hidden = YES;
    }
    return _linkView;
}

/// 显示游戏引用的视图
- (EasyFunReferencedGameView *)gameView {
    if (!_gameView) {
        _gameView = [[EasyFunReferencedGameView alloc] initWithFrame:CGRectZero];
        _gameView.hidden = YES;
    }
    return _gameView;
}
@end
