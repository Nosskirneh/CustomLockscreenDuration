include $(THEOS)/makefiles/common.mk
ARCHS = armv7s arm64 arm64e

BUNDLE_NAME = CLDSwitch
$(BUNDLE_NAME)_FILES = Switch.m
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_LIBRARIES = flipswitch
$(BUNDLE_NAME)_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
