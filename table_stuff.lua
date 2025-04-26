function tableFind(inWhatTable, findWhat)
	for i=1, #inWhatTable do
		if inWhatTable[i] == findWhat then
			return i
		end
	end

	return -1
end


function tableClear(whatTable)
	for i=1, #whatTable do
		if whatTable[i] ~= nil then
			if whatTable[i].startSfx ~= nil then whatTable[i].startSfx:stop(); whatTable[i].startSfx:release() end
			if whatTable[i].walkSfx ~= nil then whatTable[i].walkSfx:stop(); whatTable[i].walkSfx:release() end
		end

		
		table.remove(whatTable, i)
	end
end