#import "../EmojiLibrary/Header.h"
#import "../EmojiLibrary/PSEmojiUtilities.h"
#import "../PSHeader/Misc.h"

NSString *displayName(UIKeyboardEmojiCategory *self) {
    NSInteger categoryType = self.categoryType;
    NSString *name = categoryType < CATEGORIES_COUNT ? [[self class] displayNames][categoryType] : nil;
    return [NSClassFromString(@"UIKeyboardEmojiCategory") localizedStringForKey:name];
}

NSString *localizedStringForKey(NSString *key) {
    NSBundle *bundle = [NSBundle bundleWithPath:realPath(@"/System/Library/TextInput/TextInput_emoji.bundle")];
    return [bundle localizedStringForKey:key value:nil table:@"Localizable2"];
}

%group iOS5

%hook UIKeyboardEmojiCategory

%new
- (NSString *)displayName {
    NSString *name = self.name;
    if (stringEqual(name, @"UIKeyboardEmojiCategoryRecent"))
        return [NSClassFromString(@"UIKeyboardLayoutEmoji") localizedStringForKey:@"RECENTS_TITLE"];
    return localizedStringForKey([[[self class] displayNames] objectAtIndex:[[[self class] categoriesMap] indexOfObject:name]]);
}

%end

%end

%group iOS6Up

%hook UIKeyboardEmojiCategory

+ (NSString *)localizedStringForKey: (NSString *)key {
    if ([key hasPrefix:@"Recents"])
        return %orig;
    return localizedStringForKey(key);
}

- (NSString *)displayName {
    NSInteger categoryType = self.categoryType;
    return categoryType < CATEGORIES_COUNT ? [[self class] localizedStringForKey:[[self class] displayNames][categoryType]] : %orig;
}

%end

%end

%hook UIKeyboardEmojiCategory

%new
+ (NSArray <NSString *> *)displayNames {
    return @[ @"Recents Category", @"People Category", @"Nature Category", @"Food & Drink Category", @"Activity Category", @"Travel & Places Category", @"Objects Category", @"Symbols Category", @"Flags" ];
}

%new
+ (NSArray <NSString *> *)categoriesMap {
    return @[
        @"UIKeyboardEmojiCategoryRecent", @"UIKeyboardEmojiCategoryPeople", @"UIKeyboardEmojiCategoryNature", @"UIKeyboardEmojiCategoryFoodAndDrink", @"UIKeyboardEmojiCategoryCelebration", @"UIKeyboardEmojiCategoryActivity", @"UIKeyboardEmojiCategoryTravelAndPlaces", @"UIKeyboardEmojiCategoryObjectsAndSymbols", @"UIKeyboardEmojiCategoryFlags"];
}


%group iOS83Up

+ (NSString *)displayName: (NSInteger)categoryType {
    NSString *name = [self displayNames][categoryType];
    return isiOS9Up ? [NSClassFromString(@"UIKeyboardEmojiCategory") localizedStringForKey:name] : [self localizedStringForKey:name];
}

%end

%group preiOS83Not5

- (NSString *)displayName {
    return displayName(self);
}

%end

%group iOS78And83

- (NSString *)name {
    NSUInteger categoryType = self.categoryType;
    return categoryType < CATEGORIES_COUNT ? [[self class] categoriesMap][categoryType] : nil;
}

%end

%end

%ctor {
    %init;
    BOOL iOS78 = isiOS78;
    BOOL iOS83Up = isiOS83Up;
    BOOL iOS9Up = isiOS9Up;
    if (!iOS83Up && isiOS6Up) {
        %init(preiOS83Not5);
    }
    if (iOS78 || iOS83Up) {
        if (iOS83Up) {
            %init(iOS83Up);
        }
        if (!iOS9Up) {
            %init(iOS78And83);
        }
    }
    if (isiOS6Up) {
        %init(iOS6Up);
    } else {
        %init(iOS5);
    }
}
