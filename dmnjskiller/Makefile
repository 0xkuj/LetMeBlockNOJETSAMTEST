export TARGET = iphone:clang:14.5:14.5

include $(THEOS)/makefiles/common.mk

TOOL_NAME = DMNJSKiller

DMNJSKiller_FILES = main.xm
DMNJSKiller_CFLAGS = -fobjc-arc
DMNJSKiller_CODESIGN_FLAGS = -Sentitlements.plist
DMNJSKiller_INSTALL_PATH = /usr/local/bin

include $(THEOS_MAKE_PATH)/tool.mk
