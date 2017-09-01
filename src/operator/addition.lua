return function (Layer, addition)
  local refines    = Layer.key.refines
  local meta       = Layer.key.meta
  local operator   = Layer.require "operator"
  local collection = Layer.require "data.collection"
  local _, re      = Layer.require "expression"

  addition [refines] = {
    operator
  }

  addition [meta] = {
    operands = {
      [refines] = { collection },
      [meta   ] = {
        [collection] = {
          minimum    = 2,
          maximum    = 2,
          value_type = re.operator [meta].of,
        },
      },
    },
  }

  return addition
end
