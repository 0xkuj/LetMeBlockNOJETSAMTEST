export TARGET = iphone:clang:14.5:14.5
PACKAGE_VERSION = 1.2.1
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	ARCHS = arm64 arm64e
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LetMeBlock
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_LIBRARIES = sandy
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += dmnjskiller
include $(THEOS_MAKE_PATH)/aggregate.mk
