-- Filename: UserHandler.lua
-- Author: fang
-- Date: 2013-05-30
-- Purpose: 该文件用于登录数据模型

module ("UserHandler", package.seeall)

isNewUser = false

function createNewUser()
	require "script/ui/create_user/UserLayer"
	local userLayer = UserLayer.createUserLayer()
	local scene = CCScene:create()
	scene:addChild(userLayer)
	CCDirector:sharedDirector():replaceScene(scene)
end

function getUser()
    local user = CCUserDefault:sharedUserDefault():getStringForKey("user")
    local cjson = require "cjson"
    local b_userinfo = cjson.decode(user)
    setUserInfo(b_userinfo)
end

-- 得到用户信息
function setUserInfo(user)

	require "script/model/user/UserModel"
	UserModel.setUserInfo(user)

	require "script/ui/login/LoginScene"
	LoginScene.setUserInfo (user)

end

function createUser()
	-- body
	local hasUser = CCUserDefault:sharedUserDefault():getBoolForKey("hasUser")
	if (hasUser) then
		getUser()
	else
		isNewUser = true
		--CCUserDefault:sharedUserDefault():setBoolForKey("hasUser", true)
		--CCUserDefault:sharedUserDefault():flush()
		createNewUser()
	end
end


