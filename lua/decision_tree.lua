dofile 'util.lua'
dofile 'tree.lua'
flags=parse_cmd()

function main()
  if check_cmd(flags) ~= 0 then
    return 1
  end
  attribute_list, instance_list, value_list = read_csv(flags.input_file)
  root = table.copy(Node)
  begin_depth=1
  root:learn(instance_list,begin_depth)
  for i=1,flags.depth do
    best_attr = nil
    best_info_gain = -1
    for _, attribute in pairs(attribute_list) do 
      for id, instance in pairs(instance_list) do
        if not instance then
          print(1) 
        end
      end
    end
  end
end
main()
