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

	it("should be possible to reuse channels",function()
		assert.True( this.channel:DeclareExchange("test_channel_exchange1", luconejo.Channel.EXCHANGE_TYPE_FANOUT, false, false, true) )
		assert.True( this.channel:DeclareExchange("test_channel_exchange2", luconejo.Channel.EXCHANGE_TYPE_FANOUT, false, false, true) )
		assert.True( this.channel:DeleteExchange("test_channel_exchange1") )
		assert.True( this.channel:DeleteExchange("test_channel_exchange2") )
	end)

	it("should be possible to recover from error",function()
		assert.False( this.channel:DeclareExchange("test_channel_exchangedoesnotexist", luconejo.Channel.EXCHANGE_TYPE_FANOUT, true, false, true) )

		assert.True( this.channel:DeclareExchange("test_channel_exchange", luconejo.Channel.EXCHANGE_TYPE_FANOUT, false, false, true) )
		assert.True( this.channel:DeleteExchange("test_channel_exchange") )
	end)
end)
