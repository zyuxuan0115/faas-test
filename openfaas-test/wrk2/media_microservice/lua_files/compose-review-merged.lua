--require "socket"
--math.randomseed(socket.gettime()*1000)
math.random(); math.random(); math.random()

local charset = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's',
  'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'Q',
  'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H',
  'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '1', '2', '3', '4', '5',
  '6', '7', '8', '9', '0'}

local decset = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}

local function stringRandom(length)
  if length > 0 then
    return stringRandom(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

local function decRandom(length)
  if length > 0 then
    return decRandom(length - 1) .. decset[math.random(1, #decset-1)]
  else
    return ""
  end
end

counter = 4000

request = function(req_id)
  counter = counter + 1
  local req_id = counter
  local user_index = math.random(1, 999)
  local username = "username_" .. tostring(user_index)
  local title = 'movie_' .. tostring(math.random(1,999))
  local rating = math.random(1,5)
  local text = stringRandom(100)

  local method = "POST"
  local path = "/function/compose-review-merged"
  local headers = {}
  local body
  headers["Content-Type"] = "application/x-www-form-urlencoded"

  body = '{"req_id":' .. tostring(req_id) .. ',"title":"' .. title .. '","rating":'
         .. rating .. ',"username":"' .. username .. '","password":"123456","text":"'
         .. text .. '"}' 

  file = io.open('req_data_log.txt', 'w')
  file:write(body)
  file:close()

  if req_id ~= "" then
    headers["Req-Id"] = req_id
  end

  return wrk.format(method, path, headers, body)
end

response = function(status, headers, body)
  if status ~= 200 then
      io.write("------------------------------\n")
      io.write("Response with status: ".. status .."\n")
      io.write("------------------------------\n")
      io.write("[response] Body:\n")
      io.write(body .. "\n")
  end
end

function init(rand_seed)
  math.randomseed(rand_seed)
end
