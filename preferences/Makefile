include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomLockDurationPrefs
CustomLockDurationPrefs_FILES = CLDPrefsRootListController.m
CustomLockDurationPrefs_CFLAGS = -fobjc-arc
CustomLockDurationPrefs_INSTALL_PATH = /Library/PreferenceBundles
CustomLockDurationPrefs_FRAMEWORKS = UIKit
CustomLockDurationPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomLockDuration.plist$(ECHO_END)
