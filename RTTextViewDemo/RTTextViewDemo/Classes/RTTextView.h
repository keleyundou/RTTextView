//
//  RTTextView.h
//  RTTextViewDemo
//
//  Created by ColaBean on 2017/4/21.
//  Copyright © 2017年 ColaBean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTTextView;
@protocol RTTextViewLayout <NSObject>

-(void)textView:(RTTextView*)textView didChangeHeight:(CGFloat)height;

@end

IB_DESIGNABLE
@interface RTTextView : UITextView

@property (nonatomic, weak) id <RTTextViewLayout>layout;
@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@property (nonatomic, assign) IBInspectable CGFloat minTextHeight;
@property (nonatomic, assign) IBInspectable CGFloat maxTextHeight;

@end
