assert(require 'luconejo')

local connected_test = {
	create = function()
		local fixture = {
			channel = luconejo.Channel.Create( "localhost" )
		}
		assert.truthy( fixture.channel )
		return fixture
	end	
}

describe("first channel", function()
	local this = connected_test.create()
	it("should be able to create and delete exchanges", function ()
		assert.True( this.channel:DeclareExchange("test_channel_exchange", luconejo.Channel.EXCHANGE_TYPE_FANOUT, false, false, true) )
		assert.True( this.channel:DeleteExchange("test_channel_exchange") )
	end)
end)
