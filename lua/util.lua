function table.copy(t)
  local u = { }
  for k, v in pairs(t) 
  do 
    u[k] = v 
  end
  return setmetatable(u, getmetatable(t))
end

function parse_cmd()
  cmd = torch.CmdLine()
  cmd:text()
  cmd:option('--input_file', '', 'train data input')
  cmd:option('--output_file', '', 'to save model')
  cmd:option('--depth', -1, 'depth of tree')
  cmd:text()
  opt = cmd:parse(arg or {})
  return opt
end

function check_cmd(flags)
  if flags.input_file == '' then
    print('input_file empty')
    return 1
  end
  if flags.output_file == '' then
    print('output_file empty')
    return 1
  end
  if flags.depth <= 0 then
    print('depth must > 0') 
  end
  return 0
end

function split(pString, pPattern)
  local Table = {}
  local fpat = "(.-)" .. pPattern
  local last_end = 1
  local s, e, cap = pString:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
    end
    last_end = e+1
    s, e, cap = pString:find(fpat, last_end)
  end
  if last_end <= #pString then
    cap = pString:sub(last_end)
    table.insert(Table, cap)
  end
  return Table
end

function join_attribute(attribute_list, instance)
  if #attribute_list ~= #instance then
    return nil
  end
  result = {}
  for i=1, #attribute_list do
    result[attribute_list[i]] = instance[i]
  end
  return result
end

function read_csv(input_file)
  data_list = {}
  fid = io.open(input_file, 'r')
  idx = 0
  attribute_list = {}
  instance_list = {}
  value_list = {}
  while true do
    line = fid:read()
    if line == nil then
      break
    end
    if idx == 0 then
      tmp_list = split(line, ',')
      for _, attribute in pairs(tmp_list) do
        if attribute~='id' and attribute~='class' then
          table.insert(attribute_list, attribute)
        end 
      end
    else
      instance = split(line, ',')
      instance = join_attribute(tmp_list, instance)
      for attr, value in pairs(instance) do
        if attr~='id' and attr~='class' then
          if not value_list[attr] then
            value_list[attr] = {}
          end
          value_list[attr][value] = 1
        end
      end
      table.insert(instance_list, instance)
    end
    idx = idx + 1
  end
  fid:close()
  return attribute_list, instance_list,value_list
end
