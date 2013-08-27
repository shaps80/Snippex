/*
 Copyright (c) 2013 Snippex. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SPXView.h"
#import "Image+SPXAdditions.h"

@interface SPXView ()
@property (nonatomic, assign) BOOL updating;
@property (nonatomic, assign) BOOL iterationsSet;
@property (nonatomic, assign) BOOL blurRadiusSet;
@property (nonatomic, assign) BOOL dynamicSet;
@end

@implementation SPXView

- (void)configure
{
    if (!_iterationsSet) _blurIterations = 3;
    if (!_blurRadiusSet) _blurRadius = 60.0f;
    if (!_dynamicSet) _usesDynamicBlurring = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self configure];
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self configure];
    }
    
    return self;
}

- (void)setBlurIterations:(NSInteger)blurIterations
{
    _iterationsSet = YES;
    _blurIterations = blurIterations;
    [self setNeedsDisplay];
}

- (void)setBlurRadius:(CGFloat)blurRadius
{
    _blurRadiusSet = YES;
    _blurRadius = blurRadius;
    [self setNeedsDisplay];
}

- (void)setUsesDynamicBlurring:(BOOL)usesDynamicBlurring
{
    _dynamicSet = YES;
    _usesDynamicBlurring = usesDynamicBlurring;

    if (_usesDynamicBlurring && self.superview)
        [self updateAsynchronously];
}

- (void)willMoveToSuperview:(UIView *)superview
{
    [super willMoveToSuperview:superview];
    
    if (superview)
    {
        UIImage *snapshot = [self superviewAsImage];
        UIImage *blurredImage = [snapshot blurredImageWithRadius:self.blurRadius iterations:self.blurIterations];
        self.layer.contents = (id)blurredImage.CGImage;
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    if (self.superview && self.usesDynamicBlurring)
        [self updateAsynchronously];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.layer setNeedsDisplay];
}

- (void)displayLayer:(CALayer *)layer
{
    if (self.superview)
    {
        BOOL wasHidden = self.hidden;
        self.hidden = YES;
        UIImage *snapshot = [self superviewAsImage];
        self.hidden = wasHidden;
        UIImage *blurredImage = [snapshot blurredImageWithRadius:self.blurRadius iterations:self.blurIterations];
        self.layer.contents = (id)blurredImage.CGImage;
    }
}

- (void)updateAsynchronously
{
    if (self.superview && !self.updating)
    {
        BOOL wasHidden = self.hidden;
        self.hidden = YES;
        UIImage *snapshot = [self superviewAsImage];
        self.hidden = wasHidden;

        self.updating = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

            UIImage *blurredImage = [snapshot blurredImageWithRadius:self.blurRadius iterations:self.blurIterations];
            dispatch_sync(dispatch_get_main_queue(), ^{

                self.layer.contents = (id)blurredImage.CGImage;
                self.updating = NO;

                if (self.usesDynamicBlurring)
                {
                    [self performSelectorOnMainThread:@selector(updateAsynchronously)
                                           withObject:nil
                                        waitUntilDone:NO];
                }
            });
        });
    }
}

-(BOOL)isFlipped
{
	return YES;
}

-(void)setLayoutRequired
{
#if TARGET_OS_IPHONE
	[self setNeedsLayout];
#else
	[self setNeedsLayout:YES];
#endif
}

-(void)setDrawingRequired
{
#if !TARGET_OS_IPHONE
	// we have to call layout when on OSX since it won't get called automatically when drawRect is overriden.
	[self setNeedsDisplay:YES];
	[self layoutViews]; 
#else
	[self setNeedsDisplay];
#endif
}

-(void)layoutViews
{
	// All subclasses should use this method to perform layout as this ensures iOS and OSX get updated correctly.
}

#if TARGET_OS_IPHONE
-(void)layoutSubviews
{
	[self layoutViews];
	[super layoutSubviews];
}
#else
-(void)layout
{
	[self layoutViews];
	[super layout];
}
#endif

@end
