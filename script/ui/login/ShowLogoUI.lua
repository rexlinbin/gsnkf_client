-- Filename: ShowLogoUI.lua
-- Author: fang
-- Date: 2013-11-06
-- Purpose: 该文件用于显示平台要求的logo

module("ShowLogoUI", package.seeall)

local function fnEnterLogin( ... )
    require "script/ui/login/LoginScene"
    LoginScene.enter()
end

function showLogoUI( ... )
    if g_system_type == kBT_PLATFORM_ANDROID then
        jit.off()--关闭luajit
    end
    require "script/utils/extern"
    local scene = CCScene:create()
    CCDirector:sharedDirector():runWithScene(scene)
    performWithDelay(scene, createBg, 1/30)

end

function createBg( ... )
    require "script/Platform"
    Platform.initSDK()
    fnEnterLogin()
end

