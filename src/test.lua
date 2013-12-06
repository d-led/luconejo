assert(require 'luconejo')

describe("library is loaded correctly", function()
  assert.are.equal( type(luconejo) , "table" )
end)
