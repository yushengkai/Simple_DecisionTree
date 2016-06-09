compute_info_gain = function(instance_idset, attribute)
  total_count = #instance_idset
  class_map = {}

  for id,_ in pairs(instance_idset) do
    instance = instance_list[id]
    class = instance['class']
    if class_map[class] == nil then 
      class_map[class] = 0 
    end
    class_map[class] = class_map[class] + 1
  end
  entropy = 0.0
  for class, count in pairs(class_map) do
    class_map[class] = count/total_count
    entropy = entropy - class_map[class] * math.log(class_map[class])
  end
  print(entropy)
end

Node={
  name = nil,
  attribute_name = nil,
  atribute_value = nil,
  info_gain = nil,
  is_leaf = false,
  output_value = nil,
  left_child = nil,
  right_child = nil,
  learn = function(self,instance_idset, depth)
    for _, attribute in pairs(attribute_list) do 
      print(attribute)
      compute_info_gain(instance_idset,attribute)
    end 
  end
}

