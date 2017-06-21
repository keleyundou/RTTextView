//
//  RTTextView.m
//  RTTextViewDemo
//
//  Created by ColaBean on 2017/4/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import "RTTextView.h"

@implementation RTTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.editable = YES;
        self.textAlignment = NSTextAlignmentLeft;
        self.returnKeyType = UIReturnKeyDone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self awakeFromNib];
        self.minTextHeight = frame.size.height;
        self.maxTextHeight = frame.size.height;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    [self setTextContainerInset:UIEdgeInsetsMake(2, 0, 0, 0)];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"contentSize"];
}

- (void)didChange
{
    [self setNeedsDisplay];
}

#pragma mark -
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat textHeight = self.contentSize.height;
//        self.height = self.contentSize.height;
        
        if (textHeight >= self.maxTextHeight) {
            textHeight = self.maxTextHeight;
        }
        
        if (textHeight < self.minTextHeight) {
            textHeight = self.minTextHeight;
        }
        
        CGSize size = CGSizeMake(self.frame.size.width, textHeight);
        self.frame = (CGRect){self.frame.origin,size};
        if ([self.layout respondsToSelector:@selector(textView:didChangeHeight:)]) {
            [self.layout textView:self didChangeHeight:textHeight];
        }
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.hasText) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    [self.placeholder drawInRect:[self placeholderFrame] withAttributes:attrs];
}

- (CGRect)placeholderFrame {
    CGFloat x = 5;
    CGFloat w = self.bounds.size.width - 2 * x;
    CGFloat y = self.textContainerInset.top;
    CGFloat h = self.bounds.size.height;
    return CGRectMake(x, y, w, h);
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.origin.y += (self.font.ascender - self.font.capHeight - self.font.descender)/2.0;
    originalRect.size.height = 0 + self.font.pointSize;
    return originalRect;
}

//若屏幕旋转 -drawRect: 不会主动调用，为了避免出现文字拉伸，需重写此方法
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.hasText || self.placeholder == nil) {
        return;
    }
    [self drawRect:self.frame];
}
@end
