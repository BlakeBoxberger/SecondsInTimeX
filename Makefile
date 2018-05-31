TARGET = iphone:11.0:10.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SecondsInTimeX
SecondsInTimeX_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
