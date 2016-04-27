return function (Layer, timed_automaton, ref)

  local meta               = Layer.key.meta
  local checks             = Layer.key.checks
  local refines            = Layer.key.refines

  local collection         = Layer.require "cosy/formalism/data.collection"
  local record             = Layer.require "cosy/formalism/data.record"
  local automaton          = Layer.require "cosy/formalism/automaton"

  local identifier         = Layer.require "cosy/formalism/automaton/timed_automaton/literal.identifier"
  local boolean_operation = Layer.require "cosy/formalism/automaton/timed_automaton/operation/boolean_operation"
  local operands_arithmetic_type = Layer.require "cosy/formalism/automaton/timed_automaton/operation/operands_arithmetic_type"
  local operands_relational_type = Layer.require "cosy/formalism/automaton/timed_automaton/operation/operands_relational_type"
  local multiplication_operation = Layer.require "cosy/formalism/automaton/timed_automaton/operation/multiplication_operation"
  local division_operation = Layer.require "cosy/formalism/automaton/timed_automaton/operation/division_operation"

  local prefix = Layer.require "cosy/formalism/automaton/timed_automaton/" 

  timed_automaton [refines] = {
    automaton,
  }

--[[ 
-not refined because we are using a boolean_operation specific for timed_automaton (no need to inherit it).
-if we refine we will lose the tree structure of the operations.
]]--
  timed_automaton [meta].guard_type = boolean_operation 

  timed_automaton [meta].state_type [meta] = {
    [record] = {
      invariant  = { value_type = ref [meta].guard_type},
    },
  }
  

  timed_automaton [meta].clock_type = {
    [refines] = {
      identifier,
      operands_arithmetic_type,
      operands_relational_type,
    },
  }

  timed_automaton.clocks [refines] = {
    collection,
  }
  
  timed_automaton.clocks [meta] = {
    [collection] = {
      value_type = ref [meta].clock_type,
    },
  }

  timed_automaton [meta].transition_type [meta][record] = {
    guard = { value_type = ref [meta].guard_type},
    resets = {
      [refines] = {
        collection,
      },
    },
  }

  timed_automaton [meta].transition_type [meta] [record].resets [meta] [collection] = {
    value_type = ref[meta].clock_type,
    value_container = ref.clocks,
  }

  timed_automaton.states = {
    [meta] = {
      [collection] = {
        value_type = ref [meta].state_type,
      },
    },
  }

  timed_automaton.transitions = {
    [meta] = {
      [collection] = {
        value_type = ref [meta].transition_type,
      },
    },
  }

   timed_automaton.invariants = {
    [meta] = {
      [collection] = {
        value_type = ref [meta].guard_type,
      },
    },
  }





   multiplication_operation[checks][ prefix .. ".multiplication operands_type_constraints"] = function(proxy)
    if Layer.Proxy.has_meta (proxy) then
    	return
    end

    local count = 0
    for _,v in pairs (proxy.operands) do 
    	if( proxy[meta].clock_type <= v) then
    		count=count+1
    	end
        if(count==2) then
        	Layer.coroutine.yied(prefix .. ".multiplication: cannot use more than one clock.invalid", {
      	      proxy=proxy,
      	      used=v,
      	    })  
        	break
        end
    end
  end

    division_operation[checks][ prefix .. ".division operands_type_constraints"] = function(proxy)
    if Layer.Proxy.has_meta (proxy) then
    	return
    end

    local count = 0
    for _,v in pairs (proxy.operands) do 
    	if( proxy[meta].clock_type <= v) then
    		count=count+1
    	end
        if(count==2) then
        	Layer.coroutine.yied(prefix .. ".division: cannot use more than one clock.invalid", {
      	      proxy=proxy,
      	      used=v,
      	    })  
        	break
        end
    end
  end


  return timed_automaton
end
