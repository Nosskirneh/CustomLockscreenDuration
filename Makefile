include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CustomLockscreenDuration
CustomLockscreenDuration_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"

SUBPROJECTS += preferences
SUBPROJECTS += flipswitch
include $(THEOS_MAKE_PATH)/aggregate.mk
