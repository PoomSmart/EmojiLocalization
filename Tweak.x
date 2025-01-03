#import <EmojiLibrary/Header.h>
#import <EmojiLibrary/PSEmojiUtilities.h>
#import <PSHeader/Misc.h>
#import <PSHeader/iOSVersions.h>

static NSString *displayName(UIKeyboardEmojiCategory *self) {
    NSInteger categoryType = self.categoryType;
    NSString *name = categoryType < CATEGORIES_COUNT ? [[self class] displayNames][categoryType] : nil;
    return [%c(UIKeyboardEmojiCategory) localizedStringForKey:name];
}

static NSString *localizedStringForKey(NSString *key) {
    NSBundle *bundle = [NSBundle bundleWithPath:realPath(@"/System/Library/TextInput/TextInput_emoji.bundle")];
    return [bundle localizedStringForKey:key value:nil table:@"Localizable2"];
}

%hook UIKeyboardEmojiCategory

+ (NSString *)localizedStringForKey:(NSString *)key {
    if ([key hasPrefix:@"Recents"])
        return %orig;
    return localizedStringForKey(key);
}

- (NSString *)displayName {
    NSInteger categoryType = self.categoryType;
    return categoryType < CATEGORIES_COUNT ? [[self class] localizedStringForKey:[[self class] displayNames][categoryType]] : %orig;
}

%end

%hook UIKeyboardEmojiCategory

%new(@@:)
+ (NSArray <NSString *> *)displayNames {
    return @[
        @"Recents Category",
        @"People Category",
        @"Nature Category",
        @"Food & Drink Category",
        @"Activity Category",
        @"Travel & Places Category",
        @"Objects Category",
        @"Symbols Category",
        @"Flags"
    ];
}

%new(@@:)
+ (NSArray <NSString *> *)categoriesMap {
    return @[
        @"UIKeyboardEmojiCategoryRecent",
        @"UIKeyboardEmojiCategoryPeople",
        @"UIKeyboardEmojiCategoryNature",
        @"UIKeyboardEmojiCategoryFoodAndDrink",
        @"UIKeyboardEmojiCategoryCelebration",
        @"UIKeyboardEmojiCategoryActivity",
        @"UIKeyboardEmojiCategoryTravelAndPlaces",
        @"UIKeyboardEmojiCategoryObjectsAndSymbols",
        @"UIKeyboardEmojiCategoryFlags"
    ];
}

%end

%group iOS83Up

%hook UIKeyboardEmojiCategory

+ (NSString *)displayName:(NSInteger)categoryType {
    NSString *name = [self displayNames][categoryType];
    return IS_IOS_OR_NEWER(iOS_9_0) ? [%c(UIKeyboardEmojiCategory) localizedStringForKey:name] : [self localizedStringForKey:name];
}

%end

%end

%group preiOS83

%hook UIKeyboardEmojiCategory

- (NSString *)displayName {
    return displayName(self);
}

%end

%end

%group iOS78And83

%hook UIKeyboardEmojiCategory

- (NSString *)name {
    NSUInteger categoryType = self.categoryType;
    return categoryType < CATEGORIES_COUNT ? [[self class] categoriesMap][categoryType] : nil;
}

%end

%end

%ctor {
    BOOL iOS78 = IS_IOS_BETWEEN_EEX(iOS_7_0, iOS_9_0);
    BOOL iOS83Up = IS_IOS_OR_NEWER(iOS_8_3);
    BOOL iOS9Up = IS_IOS_OR_NEWER(iOS_9_0);
    if (!iOS83Up) {
        %init(preiOS83);
    }
    if (iOS78 || iOS83Up) {
        if (iOS83Up) {
            %init(iOS83Up);
        }
        if (!iOS9Up) {
            %init(iOS78And83);
        }
    }
    %init;
}
