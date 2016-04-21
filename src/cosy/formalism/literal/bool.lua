-- bool

return function (Layer, bool)


  local meta    =  Layer.key.meta
  local refines =  Layer.key.refines
  
  local record  =  Layer.require "cosy/formalism/data.record"
  local literal  =  Layer.require "cosy/formalism/literal"
 


 
  bool [refines] = {
    literal, 
  }
  
  bool [meta] = {
    [record] = {
     value = { value_type = "boolean" },
    },
  }
  return bool
end