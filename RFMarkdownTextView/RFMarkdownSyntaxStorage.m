//
//  RFMarkdownSyntaxStorage.m
//
//    Derived from RFMarkdownTextView Copyright (c) 2015 Rudd Fawcett
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RFMarkdownSyntaxStorage.h"

@interface RFMarkdownSyntaxStorage ()


@property (nonatomic, strong,readonly) NSDictionary *attributeDictionary;
@property (nonatomic, strong,readonly) NSDictionary *bodyAttributes;

@property (nonatomic,strong,readonly) UIFont* bodyFont;

@property (nonatomic,strong,readonly) UIColor* bodyTextColor;

@property (nonatomic, strong, readonly) UIColor* heading1TextColor;

@property (nonatomic, strong, readonly) UIColor* heading2TextColor;

@property (nonatomic, strong, readonly) UIColor* heading3TextColor;

@property (nonatomic, strong, readonly) UIColor* codeTextColor;

@property (nonatomic, strong, readonly) UIColor* linkTextColor;

@property (nonatomic, strong, readonly) UIColor* headingUnderlineTextColor;


@end

@implementation RFMarkdownSyntaxStorage {
    NSMutableAttributedString* _backingStore;
}

- (id)init {
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString*)str {
    [self beginEditing];
    
    [_backingStore replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    
    [_backingStore setAttributes:attrs range:range];
    
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing {
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
    NSString* backingString = [_backingStore string];
    NSRange extendedRange = extendedRange = NSUnionRange(changedRange, [backingString lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange {
    NSDictionary* attributeDictionary = self.attributeDictionary;
    NSString* backingString = [_backingStore string];
    NSDictionary* bodyAttributes  = self.bodyAttributes;
    [self setAttributes:bodyAttributes range:searchRange];
    [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(NSRegularExpression* regex, NSDictionary* attributes, BOOL* stop) {
        [regex enumerateMatchesInString:backingString options:0 range:searchRange
                             usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                                 NSRange matchRange = [match rangeAtIndex:1];
                                 [self addAttributes:attributes range:matchRange];
                             }];
    }];
}

#pragma mark Property Access

@synthesize bodyTextColor = _bodyTextColor;

-(UIColor *)bodyTextColor {
    if (!_bodyTextColor) {
        if (@available(iOS 13.0, *)) {
            _bodyTextColor = [UIColor labelColor];
        } else {
            // Fallback on earlier versions
            _bodyTextColor = [UIColor blackColor];
        }
    }
    return _bodyTextColor;
}

@synthesize codeTextColor = _codeTextColor;

-(UIColor *)codeTextColor {
    if (!_codeTextColor) {
        _codeTextColor = [UIColor systemGrayColor];
    }
    return _codeTextColor;
}


@synthesize linkTextColor = _linkTextColor;

-(UIColor *)linkTextColor {
    if (!_linkTextColor) {
        if (@available(iOS 13.0, *)) {
            _linkTextColor = [UIColor linkColor];
        } else {
            // Fallback on earlier versions
            _linkTextColor = [UIColor colorWithRed:0.255 green:0.514 blue:0.769 alpha:1.00];
        }
    }
    return _linkTextColor;
}

@synthesize heading1TextColor = _heading1TextColor;

-(UIColor *)heading1TextColor {
    if (!_heading1TextColor) {
        if (@available(iOS 13.0, *)) {
            _heading1TextColor = [UIColor labelColor];
        } else {
            // Fallback on earlier versions
            _heading1TextColor = [UIColor blackColor];
        }
    }
    return _heading1TextColor;
}


@synthesize heading2TextColor = _heading2TextColor;

-(UIColor *)heading2TextColor {
    if (!_heading2TextColor) {
        if (@available(iOS 13.0, *)) {
            _heading2TextColor = [UIColor secondaryLabelColor];
        } else {
            // Fallback on earlier versions
            _heading2TextColor = [UIColor darkGrayColor];
        }
    }
    return _heading2TextColor;
}

@synthesize heading3TextColor = _heading3TextColor;

-(UIColor *)heading3TextColor {
    if (!_heading3TextColor) {
        if (@available(iOS 13.0, *)) {
            _heading3TextColor = [UIColor tertiaryLabelColor];
        } else {
            // Fallback on earlier versions
            _heading3TextColor = [UIColor grayColor];
        }
    }
    return _heading3TextColor;
}

@synthesize headingUnderlineTextColor = _headingUnderlineTextColor;


-(UIColor *)headingUnderlineTextColor {
    if (!_headingUnderlineTextColor) {
        if (@available(iOS 13.0, *)) {
            _headingUnderlineTextColor = [UIColor opaqueSeparatorColor];
        } else {
            // Fallback on earlier versions
            _headingUnderlineTextColor = [UIColor colorWithWhite:0.933 alpha:1.0];
        }
    }
    return _headingUnderlineTextColor;
}

@synthesize bodyAttributes = _bodyAttributes;

-(NSDictionary *)bodyAttributes {
    if (!_bodyAttributes) {
        
        _bodyAttributes = @{NSFontAttributeName:self.bodyFont, NSForegroundColorAttributeName:self.bodyTextColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone]};
    }
    return _bodyAttributes;
}

@synthesize bodyFont = _bodyFont;

-(UIFont *)bodyFont {
    if (!_bodyFont) {
        UIFontDescriptor* baseDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
        CGFloat baseFontSize = baseDescriptor.pointSize;
        CGFloat bodyFontSize = ceilf(baseFontSize * 14 / 17 / 2) * 2;
        _bodyFont = [UIFont fontWithName:@"Menlo" size:bodyFontSize];
    }
    return _bodyFont;
}

@synthesize attributeDictionary = _attributeDictionary;

-(NSDictionary *)attributeDictionary {
    if (!_attributeDictionary) {
        UIFont* bodyFont = self.bodyFont;
        CGFloat bodyFontSize = bodyFont.pointSize;
        CGFloat smallerFontSize = roundf(bodyFontSize * 0.8 / 2) * 2;
        
        UIColor* codeColor = self.codeTextColor;
        
        NSDictionary *boldAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Bold" size:bodyFontSize]};
        NSDictionary *italicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-Italic" size:bodyFontSize]};
        NSDictionary *boldItalicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo-BoldItalic" size:bodyFontSize]};
        
        NSDictionary *codeAttributes = @{NSForegroundColorAttributeName:codeColor};
        NSDictionary *preformattedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Menlo" size:smallerFontSize],NSForegroundColorAttributeName : codeColor};
        
        UIFont* headerFont = [UIFont fontWithName:@"Menlo-Bold" size:bodyFontSize];
        NSNumber* headerUnderlineStyle = [NSNumber numberWithInt:NSUnderlineStyleSingle];
        UIColor* headerUnderlineColor = self.headingUnderlineTextColor;
        
        NSDictionary *headerOneAttributes = @{NSFontAttributeName:headerFont, NSUnderlineStyleAttributeName:headerUnderlineStyle, NSUnderlineColorAttributeName:headerUnderlineColor,NSForegroundColorAttributeName : self.heading1TextColor};
        NSDictionary *headerTwoAttributes = @{NSFontAttributeName:headerFont, NSUnderlineStyleAttributeName:headerUnderlineStyle, NSUnderlineColorAttributeName:headerUnderlineColor,NSForegroundColorAttributeName : self.heading2TextColor};
        NSDictionary *headerThreeAttributes = @{NSFontAttributeName:headerFont, NSUnderlineStyleAttributeName:headerUnderlineStyle, NSUnderlineColorAttributeName:headerUnderlineColor,NSForegroundColorAttributeName : self.heading3TextColor};
        
        NSDictionary *strikethroughAttributes = @{NSFontAttributeName:bodyFont, NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)};
        
        /*
         NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
         NSDictionary *headerTwoAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
         NSDictionary *headerThreeAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.5]};
         
         Alternate H1 with underline:
         
         NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineColorAttributeName:[UIColor colorWithWhite:0.933 alpha:1.0]};
         
         Headers need to be worked on...
         
         @"(\\#\\w+(\\s\\w+)*\n)":headerOneAttributes,
         @"(\\##\\w+(\\s\\w+)*\n)":headerTwoAttributes,
         @"(\\###\\w+(\\s\\w+)*\n)":headerThreeAttributes
         
         */
        
        NSRegularExpression* (^regex)(NSString*) = ^(NSString* regexString) {
            NSError* regexError = nil;
            NSRegularExpression* pattern = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionAnchorsMatchLines error:&regexError];
            if (regexError) {
                NSLog(@"Regex %@ error: %@",regexString,regexError);
            }
            return pattern;
        };
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:self.linkTextColor};
        
        _attributeDictionary = @{
                                 regex(@"~~(\\w+(\\s\\w+)*)~~") :strikethroughAttributes,
                                 regex(@"\\**(?:^|[^*])(\\*\\*(\\w+(\\s\\w+)*)\\*\\*)") :boldAttributes,
                                 regex(@"\\**(?:^|[^*])(\\*(\\w+(\\s\\w+)*)\\*)") :italicAttributes,
                                 regex(@"(\\*\\*\\*\\w+(\\s\\w+)*\\*\\*\\*)") :boldItalicAttributes,
                                 regex(@"(`\\w+(\\s\\w+)*`)") :codeAttributes,
                                 regex(@"^((?:\\h{4}|\\t).*)$") :preformattedTextAttributes,
                                 regex(@"(```\n([\\s\n\\d\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/]]*)\n```)") :codeAttributes,
                                 regex(@"(\\[\\w+(\\s\\w+)*\\]\\(\\w+\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/ \\w+]*\\))") :linkAttributes,
                                 regex(@"(\\[\\[\\w+(\\s\\w+)*\\]\\])") :linkAttributes,
                                 regex(@"^(\\#\\h?.*)$") :headerOneAttributes,
                                 regex(@"^(\\#{2}?\\h?.*)$") :headerTwoAttributes,
                                 regex(@"^(\\#{3}?\\h?.*)$") :headerThreeAttributes,
                                 };

    }
    return _attributeDictionary;
}

@end
