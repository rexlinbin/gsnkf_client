-- Filename：    RedEquipCardSprite.lua
-- Author：      llp
-- Date：        2015-10-30

module("RedEquipCardSprite", package.seeall)


require "script/ui/item/ItemUtil"

local scoreSprite   = nil 
local _item_id      = nil
local _item_tmpl_id = nil
local _cardSprite   = nil
local _redCard      = false

local function init()
    scoreSprite   = nil 
    _item_id      = nil
    _item_tmpl_id = nil
    _cardSprite   = nil
    _redCard      = false
end

-- 
local function create(item_tmpl_id, item_id)
    print("item_tmpl_id==",item_tmpl_id)
    print("item_id==",item_id)
    if(item_id)then
        local equipInfo = ItemUtil.getItemInfoByItemId(tonumber(item_id))
        
        if(equipInfo == nil )then
            equipInfo = ItemUtil.getEquipInfoFromHeroByItemId(tonumber(item_id))
        end
        item_tmpl_id = equipInfo.item_template_id
    end

    require "db/DB_Item_arm"
    local localData = DB_Item_arm.getDataById(item_tmpl_id)
    --DB_Item_arm.release()
    --package.loaded["db/DB_Item_arm"] = nil

    -- 卡牌背景 
    local _cardSprite = nil
    if(_redCard==false)then
        _cardSprite = CCSprite:create("images/item/equipinfo/card/equip_" .. localData.quality .. ".png")
    else
        _cardSprite = CCSprite:create("images/item/equipinfo/card/equip_" .. localData.new_quality .. ".png")
    end

    -- icon
    local iconSprite = nil
    if(_redCard == false)then
        iconSprite = CCSprite:create("images/base/equip/big/" .. localData.icon_big)
    else
        iconSprite = CCSprite:create("images/base/equip/big/" .. localData.new_bigicon)
    end
    iconSprite:setAnchorPoint(ccp(0.5, 0.5))
    iconSprite:setPosition(ccp(_cardSprite:getContentSize().width/2, _cardSprite:getContentSize().height*0.55))
    _cardSprite:addChild(iconSprite)

    -- 星级
    local starNum = 1
    if(_redCard == false)then
        starNum = localData.quality
    else
        starNum = localData.new_quality
    end
    for i=1, starNum do
        local starSp = CCSprite:create("images/formation/star.png")
        starSp:setAnchorPoint(ccp(0.5, 0.5))
        starSp:setPosition(ccp( _cardSprite:getContentSize().width * 0.9 - _cardSprite:getContentSize().width* 27.0/300 * (i-1), _cardSprite:getContentSize().height * 410/440))
        _cardSprite:addChild(starSp)
    end
    local totalScore = 0
    if(item_id)then
        totalScore = ItemUtil.getEquipScoreByItemId(item_id,_redCard)
    else
        totalScore = ItemUtil.getEquipScoreByItemTmplId(item_tmpl_id,_redCard)
    end
    require "script/libs/LuaCC"
    scoreSprite = LuaCC.createSpriteOfNumbers("images/item/equipnum", totalScore, 17)
    if (scoreSprite ~= nil) then
        scoreSprite:setAnchorPoint(ccp(0, 0))
        scoreSprite:setPosition(_cardSprite:getContentSize().width*110.0/301, _cardSprite:getContentSize().height*0.05)
        _cardSprite:addChild(scoreSprite)
    end
    
    -- 平台相关装备名字显示兼容
    local plName = Platform.getPlatformFlag()
    if(Platform.getPlatformFlag() == "ios_thailand" or Platform.getPlatformFlag() == "Android_taiguo" ) then
        local nameLabel = CCRenderLabel:create(localData.name, g_sFontName, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
        nameLabel:setAnchorPoint(ccp(0.5,0.5))
        nameLabel:setColor(ccc3(0xff, 0xff, 0xff))
        nameLabel:setPosition(ccp( _cardSprite:getContentSize().width*0.5, _cardSprite:getContentSize().height*0.18))
        _cardSprite:addChild(nameLabel,3)
    elseif (Platform.getLayout ~= nil and Platform.getLayout() == "enLayout" ) then
        local nameLabel = CCRenderLabel:create(localData.name, g_sFontName, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
        nameLabel:setAnchorPoint(ccp(0.5,0.5))
        nameLabel:setColor(ccc3(0xff, 0xff, 0xff))
        nameLabel:setPosition(ccp( _cardSprite:getContentSize().width*0.5, _cardSprite:getContentSize().height*0.18))
        _cardSprite:addChild(nameLabel,3)
    else
        local nameLabel = CCRenderLabel:createWithAlign(localData.name, g_sFontName, 24,
                                      1 , ccc3(0, 0, 0 ), type_stroke, CCSizeMake(25,180), kCCTextAlignmentCenter,
                                      kCCVerticalTextAlignmentCenter);
        -- nameLabel:setSourceAndTargetColor(ccc3( 0x36, 0xff, 0x00), ccc3( 0x36, 0xff, 0x00));
        nameLabel:setColor(ccc3(0xff, 0xff, 0xff))
        nameLabel:setPosition(ccp( _cardSprite:getContentSize().width*0.02, _cardSprite:getContentSize().height*0.98))
        _cardSprite:addChild(nameLabel,3)
    end
    return _cardSprite
end

-- createCardLayer
function createSprite( item_tmpl_id, item_id, isRed)
    init()
    _redCard = isRed or false
    _item_tmpl_id = item_tmpl_id
    _item_id = item_id
    return create(item_tmpl_id, item_id)
end

function refreshCardSprite( m_cardSprite)
    if(scoreSprite) then
        scoreSprite:removeFromParentAndCleanup(true)
        scoreSprite=nil
    end
    local totalScore = 0
    if(_item_id)then
        totalScore = ItemUtil.getEquipScoreByItemId(_item_id)
    else
        totalScore = ItemUtil.getEquipScoreByItemTmplId(_item_tmpl_id)
    end
    require "script/libs/LuaCC"
    scoreSprite = LuaCC.createSpriteOfNumbers("images/item/equipnum", totalScore, 17)
    if (scoreSprite ~= nil) then
        scoreSprite:setAnchorPoint(ccp(0, 0))
        scoreSprite:setPosition(m_cardSprite:getContentSize().width*110.0/301, m_cardSprite:getContentSize().height*0.05)
        m_cardSprite:addChild(scoreSprite)
    end
end



