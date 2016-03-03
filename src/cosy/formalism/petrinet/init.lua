-- Petri nets
-- ==========
--
-- This formalism defines the basic structure of any Petri net: a collection
-- of places, a collection of transitions (both being graph vertices), and
-- a collection of arcs.
--
-- See [here](https://en.wikipedia.org/wiki/Petri_net)

return function (Layer, petrinet, ref)

  local meta     = Layer.key.meta
  local refines  = Layer.key.refines

  local collection       = Layer.require "cosy/formalism/data.collection"
  local record           = Layer.require "cosy/formalism/data.record"
  local graph            = Layer.require "cosy/formalism/graph"
  local labeled_edges    = Layer.require "cosy/formalism/graph.labeled.edges"
  local labeled_vertices = Layer.require "cosy/formalism/graph.labeled.vertices"
  local directed         = Layer.require "cosy/formalism/graph.directed"
  local binary_edges     = Layer.require "cosy/formalism/graph.binary_edges"

  petrinet [refines] = {
    graph,
    directed,
    binary_edges,
    labeled_vertices,
    labeled_edges,
  }

  petrinet [meta].place_type = {
    [refines] = {
      ref [meta].vertex_type,
    },
    [meta] = {
      [record] = {
        identifier = false,
        marking    = false,
      }
    }
  }

  petrinet [meta].transition_type = {
    [refines] = {
      ref [meta].vertex_type,
    }
  }

  petrinet [meta].arc_type = {
    [refines] = {
      ref [meta].edge_type,
    },
  }

  petrinet.places = {
    [meta] = {
      [refines] = {
        ref [meta].vertices [meta],
      },
      [collection] = {
        value_type = ref [meta].place_type,
      }
    }
  }

  petrinet.transitions = {
    [meta] = {
      [refines] = {
        ref [meta].vertices [meta],
      },
      [collection] = {
        value_type = ref [meta].transition_type,
      }
    }
  }

  petrinet.arcs = {
    [meta] = {
      [refines] = {
        ref [meta].edges [meta],
      },
      [collection] = {
        value_type = ref [meta].arc_type,
      }
    }
  }

  petrinet.vertices [refines] = {
    ref.places,
    ref.transitions,
  }
  petrinet.edges    [refines] = {
    ref.arcs,
  }

end
