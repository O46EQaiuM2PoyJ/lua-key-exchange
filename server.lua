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

function randString(len)
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
local secretKeys = {};
local keys = {};

remote.OnServerEvent:Connect(function(p, stage, data)
	if(stage==3) then
		keys[p.Name] = secretKeys[p.Name][data[1]]..secretKeys[p.Name][data[2]];
		secretKeys[p.Name] = false;
		warn('Server: saved pkey for player '..p.Name..': '..keys[p.Name]);
	end;
end);

local function handlePlayer(p)
	local a_s = {};
	local a_p = {};
	for i=1,500000 do
	  local v = randString(4);
	  local k = hashString(v);
	  a_s[k] = v;
	  a_p[k] = true;
	end;
	secretKeys[p.Name] = a_s;
	remote:FireClient(p,2,a_p);
end;

for _,p in pairs(game.Players:GetPlayers()) do 	handlePlayer(p); end;
game.Players.PlayerAdded:Connect(handlePlayer);
