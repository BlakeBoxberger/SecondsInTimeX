@interface _UIStatusBarStringView : UIView
@property (copy) NSString *text;
@property NSInteger numberOfLines;
@property (copy) UIFont *font;
@property NSInteger textAlignment;
@end

NSDateFormatter *dateFormatter;

%hook _UIStatusBarStringView

- (void)setText:(NSString *)text {
	if([text containsString:@":"]) {
		NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
		timeString = [timeString substringToIndex:([timeString length]-2)];
		self.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold];
		%orig(timeString);
	}
	else {
		%orig(text);
	}
}

%end


@interface _UIStatusBarTimeItem
@property (copy) _UIStatusBarStringView *shortTimeView;
@property (copy) _UIStatusBarStringView *pillTimeView;
@property (nonatomic, retain) NSTimer *nz9_seconds_timer;
@end

%hook _UIStatusBarTimeItem
%property (nonatomic, retain) NSTimer *nz9_seconds_timer;

- (instancetype)init {
	%orig;
	self.nz9_seconds_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
                self.shortTimeView.text = @":";
								self.pillTimeView.text = @":";
								self.shortTimeView.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold];
								self.pillTimeView.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold];
						}];
	return self;
}

- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2 {
	id returnThis = %orig;
	self.shortTimeView.text = @":";
	self.pillTimeView.text = @":";
	self.shortTimeView.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold];
	self.pillTimeView.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold];
	return returnThis;
}

%end


%hook _UIStatusBarIndicatorLocationItem

- (id)applyUpdate:(id)arg1 toDisplayItem:(id)arg2 {
	// set it to hidden
	return nil;
}

%end

%ctor {
	dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterNoStyle;
	dateFormatter.timeStyle = NSDateFormatterMediumStyle;
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	%init;
}
