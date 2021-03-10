PACKAGE_VERSION = 1.1.1

ifeq ($(SIMULATOR),1)
	TARGET = simulator:clang:latest:8.0
	ARCHS = x86_64 i386
else
	TARGET = iphone:clang:latest:5.0
	ARCHS = armv7 arm64
endif

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = EmojiLocalization
EmojiLocalization_FILES = Tweak.xm
EmojiLocalization_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries/EmojiPort
EmojiLocalization_EXTRA_FRAMEWORKS = CydiaSubstrate
EmojiLocalization_USE_SUBSTRATE = 1

include $(THEOS_MAKE_PATH)/library.mk

ifeq ($(SIMULATOR),1)
setup:: all
	@rm -f /opt/simject/$(LIBRARY_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(LIBRARY_NAME).dylib /opt/simject
	@cp -v $(PWD)/$(LIBRARY_NAME).plist /opt/simject
endif
