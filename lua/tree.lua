get_leaf_value = function(instance_idset)
  class_map = {}
  max_class = nil
  max_class_num = 0
  for id,_ in pairs(instance_idset) do
    instance = instance_list[id]
    class = instance['class']
    if class_map[class] == nil then 
      class_map[class] = 0 
    end
    class_map[class] = class_map[class] + 1
    if class_map[class]>max_class_num then
      max_class_num = class_map[class]
      max_class = class
    end
  end
  
  if table_len(class_map)==1 then
    return max_class, true
  else
    return max_class, false
  end
end


compute_info_gain = function(instance_idset, attribute, target_value)
  total_count = table_len(instance_idset)
  class_map = {}
  value_map = {}
  value_count = {}
  for id,_ in pairs(instance_idset) do
    instance = instance_list[id]
    class = instance['class']
    if class_map[class] == nil then 
      class_map[class] = 0 
    end
    class_map[class] = class_map[class] + 1
    value = instance[attribute]
    if value ~= target_value then
      value = 'other'  
    end
    if value_map[value] == nil then
      value_map[value] = {}
      value_count[value] = 0.0
    end
    if value_map[value][class] == nil then
      value_map[value][class] = 0
    end
    value_map[value][class] = value_map[value][class] + 1 
    value_count[value] =  value_count[value] + 1
  end
  entropy = 0.0
  if table_len(class_map) > 1 then
    for class, count in pairs(class_map) do
      class_map[class] = count/total_count
      entropy = entropy - class_map[class] * math.log(class_map[class])
    end
    conditional_entropy_exp = 0.0
    for value, map in pairs(value_map) do
      conditional_entropy = 0.0
      for class, count in pairs(map) do
        class_probability = count / value_count[value] 
        conditional_entropy = conditional_entropy - class_probability * math.log(class_probability)
      end
      conditional_entropy_exp = conditional_entropy_exp + value_count[value] / total_count * conditional_entropy
    end
    info_gain = entropy - conditional_entropy_exp
  else
  --  print('only one class:'..#class_map)
  --  print(class_map)
    info_gain = 0.0
  end
  return info_gain
end

Node={
  name = nil,
  attribute_name = nil,
  attribute_value = nil,
  leaf_value = nil,
  info_gain = nil,
  is_leaf = false,
  output_value = nil,
  left_child = nil,
  right_child = nil,
  learn = function(self, instance_idset, depth)
    max_class, is_same = get_leaf_value(instance_idset)
    if depth>flags.depth then
      self.is_leaf = true
      return nil
    end
    if is_same then
      self.is_leaf = true
      self.leaf_value = max_class
      return nil
    end
    for _, attribute in pairs(attribute_list) do 
      for target_value,_ in pairs(value_list[attribute]) do
        ig = compute_info_gain(instance_idset, attribute, target_value)
        --print('attribute:'..attribute..' target_value:'..target_value..' info_gain:'..ig)
        if self.info_gain == nil or self.info_gain < ig then
          self.info_gain = ig
          self.attribute_name = attribute
          self.attribute_value = target_value
        end
      end
    end 
    print('target_attribute:'..self.attribute_name..' target_value:'..self.attribute_value)
    left_set = {}
    right_set = {}
    for id,_ in pairs(instance_idset) do
      instance = instance_list[id]
      value = instance[self.attribute_name]
      isnumber = tonumber(value)
      if isnumber == nil then
        if value == self.attribute_value then
          left_set[id] = 1
        else
          right_set[id] = 1
        end
      else
        value = tonumber(value)
        if value < tonumber(self.attribute_value) then
          left_set[id] = 1
        else
          right_set[i] = 1
        end
      end
    end
    --print(depth..' left_set:')
    --print(left_set)
    if table_len(left_set) > 0 then
      self.left_child = table.copy(Node)
      self.left_child:learn(left_set, depth+1)
    end
    if self.left_child.is_leaf then
      print('leaf_value:'..self.left_child.leaf_value)
    end
    --print(depth..' right_set:')
    --print(right_set)
    if table_len(right_set) > 0 then
      self.right_child = table.copy(Node)
      self.right_child:learn(right_set, depth+1)
    end
    if self.right_child.is_leaf then
      print('leaf_value:'..self.right_child.leaf_value)
    end
  end
}

