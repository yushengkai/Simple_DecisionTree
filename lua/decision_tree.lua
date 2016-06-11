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
  print_tree(root,1)
end
main()
