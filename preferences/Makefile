TARGET = iphone:clang:9.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomLockscreenDurationPrefs
CustomLockscreenDurationPrefs_FILES = CLDPrefsRootListController.m ../../TwitterStuff/Prompt.m
CustomLockscreenDurationPrefs_CFLAGS = -fobjc-arc
CustomLockscreenDurationPrefs_INSTALL_PATH = /Library/PreferenceBundles
CustomLockscreenDurationPrefs_FRAMEWORKS = UIKit
CustomLockscreenDurationPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomLockscreenDuration.plist$(ECHO_END)
