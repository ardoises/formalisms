local Layer            = require "layeredata"
local graph            = require "cosy.formalism.graph"
local labeled_edges    = require "cosy.formalism.graph.labeled.edges"
local labeled_vertices = require "cosy.formalism.graph.labeled.vertices"
local directed         = require "cosy.formalism.graph.directed"
local binary_edges     = require "cosy.formalism.graph.binary_edges"
local collection       = require "cosy.formalism.data.collection"
local enumeration      = require "cosy.formalism.data.enumeration"

local automaton = Layer.new {
  name = "cosy.formalism.automaton",
}

local labels  = Layer.key.labels
local meta    = Layer.key.meta
local refines = Layer.key.refines

-- Autpmata
-- ========

-- An automaton is a graph where vertices are called "states", edges are
-- called "transitions", and edges are labeled with symbols.
-- These symbols are taken from an alphabet, represented by an enumeration.
--
-- See [here](http://www.cs.odu.edu/~toida/nerzic/390teched/regular/fa/nfa-definitions.html)

automaton [labels] = {
  ["cosy.formalism.automaton"] = true,
}
local _ = Layer.reference "cosy.formalism.automaton"

automaton [refines] = {
  graph,
  directed,
  binary_edges,
  labeled_vertices,
  labeled_edges,
}

automaton.alphabet = {
  [refines] = {
    enumeration,
  }
}

automaton [meta].state_type = {
  [refines] = {
    _ [meta].vertex_type,
  },
  [meta] = {
    record = {
      identifier = false,
      initial    = "boolean",
      final      = "boolean",
    }
  }
}

automaton [meta].transition_type = {
  [refines] = {
    _ [meta].edge_type,
  },
  [meta] = {
    record = {
     letter = {
       value_type      = _.alphabet [Layer.key.meta].symbol_type,
       value_container = _.alphabet,
     },
   },
 },
}

automaton.states = {
  [refines] = {
    collection,
  },
  [meta] = {
    value_type = _ [meta].state_type,
  }
}

automaton.transitions = {
  [refines] = {
    collection,
  },
  [meta] = {
    value_type = _ [meta].transition_type,
  }
}

automaton.vertices [refines] = {
  _.states,
}

automaton.edges [refines] = {
  _.transitions,
}

return automaton
