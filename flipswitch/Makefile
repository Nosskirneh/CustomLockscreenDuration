include $(THEOS)/makefiles/common.mk
ARCHS = armv7s arm64 arm64e

BUNDLE_NAME = CustomLockDuration
CustomLockDuration_FILES = Switch.m
CustomLockDuration_FRAMEWORKS = UIKit
CustomLockDuration_LIBRARIES = flipswitch
CustomLockDuration_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
