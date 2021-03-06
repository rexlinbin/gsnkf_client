-- FileName: RedEquipData.lua 
-- Author: llp 
-- Date: 15/10/30 
-- Purpose: 红色装备进阶数据


module("RedEquipData", package.seeall)


--[[
	@des 	: 得到红色装备进阶需要的英雄等级
	@param 	: p_developNum 进阶的次数 从0阶开始
	@return : num
--]]
function getDevelopNeedHeroLv( p_developNum )
	local retNum = 0
	require "db/DB_Normal_config"
	local data = DB_Normal_config.getDataById(1)
	local needLvTab = string.split(data.treasure_lv_limit, ",")
	for i=1,#needLvTab do
		if( tonumber(p_developNum) + 1 == i )then
			retNum = tonumber(needLvTab[i])
			break
		end
	end
	return retNum
end

--[[
	@des 	: 得到红色装备进阶最大进阶阶数 	进阶的阶数 从0阶开始
	@param 	: p_itemTid 模板id
	@return : num 从0开始所有进阶数-1
--]]
function getDevelopMaxNum( p_itemTid )
	local data = DB_Item_arm.getDataById(p_itemTid)
	local retNum = tonumber(data.max_evolve)
	return retNum
end


--[[
	@des 	: 得到红色装备进阶需要消耗的数据
	@param 	: p_developNum 进阶的次数 从0阶开始
	@return : table or nil
--]]
function getDevelopNeedCost(p_itemTid, p_developNum )
	local retNeed = nil
	local itemInfo = ItemUtil.getItemById(p_itemTid)

	local needStr = itemInfo.evolve_cost
	local developNeedData = {}
	if( needStr == nil)then
		retNeed = nil
	else
		retNeed = {}
		local data = string.split(needStr,",")
		for k,v in pairs(data)do
			local data1 = string.split(v,"|")
			if(tonumber(data1[1])==tonumber(p_developNum))then
				table.insert(developNeedData,string.sub(v, 3, -1))
			else
				-- break
			end
		end
	end
	for i=1,table.count(developNeedData) do
		table.insert(retNeed,ItemUtil.getItemsDataByStr(developNeedData[i]))
	end
	return retNeed
end

--[[
	@des 	: 得到红色装备进阶需要消耗的数据itemId
	@param 	: p_oldTab:原来属性组 p_newTab:新属性组
	@return : table {id=value}
--]]
function getDevelopAddAttrTab( p_oldTab, p_newTab )
	local retTab = {}
	if( p_newTab == nil)then
		return retTab
	end
	for n_id,n_v in pairs(p_newTab) do
		local isNew = true
		for o_id,o_v in pairs(p_oldTab) do
			if( tonumber(n_id) == tonumber(o_id) and tonumber(n_v) == tonumber(o_v) )then
				isNew = false
				break
			end
		end
		if(isNew)then
			retTab[n_id] = n_v
		end
	end
	return retTab
end


--[[
	@des 	: 得到红色装备进阶增加的属性
	@param 	: p_developNum 进阶的次数 从0阶开始
	@return : table
--]]
function getDevelopAttrTab(p_itemTid, p_developNum )
	local retAdd = {}
	local itemInfo = ItemUtil.getItemById(p_itemTid)
	local addStr = itemInfo["extra_affix_" .. p_developNum]
	if( addStr == nil)then
		retAdd = {}
	else
		local temp = string.split(addStr, "|")
		local affixInfo,dealNum,realNum = ItemUtil.getAtrrNameAndNum(temp[1],temp[2])
		local attrTab = {}
		attrTab.id = temp[1]
		attrTab.showNum = dealNum
		attrTab.realNum = realNum
		attrTab.name = affixInfo.sigleName
		table.insert(retAdd,attrTab)
	end
	return retAdd
end


--[[
	@des 	: 得到属性按id大小排列
	@param 	: p_table { 2=1,4=1,3=1 }
	@return : { {k=2,v=1} {k=3,v=1} {k=4,v=1} }
--]]
function getAttrSortTab( p_table )
	local retTab = {}
	for k,v in pairs(p_table) do
		local temp = {}
		temp.attrId = k
		temp.attrNum = v
		table.insert(retTab,temp)
	end

	local sortFun = function ( p_data1, p_data2 )
		return tonumber(p_data1.attrId) < tonumber(p_data2.attrId)
	end
	table.sort(retTab,sortFun)
	return retTab
end

--获取装备进阶解锁属性
function getExtraAffixData( p_info )
	-- body
	--橙色宝物解锁属性
	local affix = {}
	local db_data = DB_Item_arm.getDataById(p_info.item_template_id)
	if p_info.va_item_text.armDevelop and tonumber(p_info.va_item_text.armDevelop) > -1 then
		local developLevel = tonumber(p_info.va_item_text.armDevelop)
		local developExtActives = string.split(db_data.evolve_attr, ",")
		for k,v in pairs(developExtActives) do
			local values     = string.split(v, "|")
			local needDevelopLevel 	= tonumber(values[1])
			local affixId 			= tonumber(values[2])
			local affixValue 		= tonumber(values[3])
			if developLevel >= needDevelopLevel then
				if affix[affixId] == nil then
					affix[affixId] = affixValue 
				else
					affix[affixId] = affix[affixId] + affixValue
				end
			end
		end
	end
	return affix
end

function isRedCard( p_itemid )
	-- body
	local showItemInfo = ItemUtil.getItemByItemId(tonumber(p_itemid))
	if(showItemInfo == nil)then
		showItemInfo = ItemUtil.getEquipInfoFromHeroByItemId(tonumber(p_itemid))
	end
	if( table.isEmpty(showItemInfo.itemDesc) )then
		showItemInfo.itemDesc = ItemUtil.getItemById(tonumber(showItemInfo.item_template_id))
	end
	if(showItemInfo.va_item_text.armDevelop)then
		return true
	else
		return false
	end
end

function getBaseAffixData( p_info )
	-- body
	local fixData = EquipAffixModel.getEquipFixedAffix(p_info)
	local baseData = EquipAffixModel.getEquipAffixById(tonumber(p_info.item_id))
	local developData = EquipAffixModel.getDevelopAffixByInfo(p_info)
	local pTable = {}
	for k,v in pairs(baseData)do
		pTable[k]=v
	end
	
	for k,v in pairs(fixData)do
		if pTable[k] == nil then
			pTable[k] = v
		else
			pTable[k] = pTable[k] + v
		end
	end
	
	for k,v in pairs(developData)do
		if pTable[k] == nil then
			pTable[k] = v
		else
			pTable[k] = pTable[k] + v
		end
	end
	return pTable
end