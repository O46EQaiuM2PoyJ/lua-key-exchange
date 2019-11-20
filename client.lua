math.randomseed(os.time());

local function numToChar(x)
  if(x>=0 and x<=9) then
    return tostring(x);
  elseif(x>=10 and x<=35) then
    return string.char(x+55);
  elseif(x>=36 and x<=61) then
    return string.char(x+61);
  else
    return 'OUT_OF_RANGE';
  end;
end;

local function randString(len)
  local ret = '';
  for i=1,len do
    ret = ret..numToChar(math.random(0,61));
  end;
  return ret;
end;

local function hashString(inputString)
	local ret = '';
	local sumOfChars = 0;
	local productOfChars = 1;
	for i=1, #inputString do
		local charByte = string.byte(inputString:sub(i,i));
		sumOfChars = sumOfChars + charByte + i;
	end;
	for i=1, #inputString do
		local charByte = string.byte(inputString:sub(i,i));
		ret = ret..string.format('%X',sumOfChars+charByte+i);
	end;
	return ret;
end;



local remote = game.ReplicatedStorage.KeyExchange;
local key = '';

remote.OnClientEvent:Connect(function(stage,data)
	if(stage==2) then
		--local tblsize = 0; for k,v in pairs(data) do tblsize = tblsize + 1; end; print('server pubkey size: '..tblsize);
		local collisions = 0;
		local hashes,keys = {},{};
		while(wait() and collisions<2) do
		  local v = randString(4);
		  local k = hashString(v);
		  if(data[k]==true) then 
			table.insert(hashes,k);
			table.insert(keys,v);
		    collisions = collisions + 1;
		  end;
		end;
		warn('Client: saved pkey: '..keys[1]..keys[2]);
		key = keys[1]..keys[2];
		remote:FireServer(3,{hashes[1],hashes[2]});
	end;
end);
