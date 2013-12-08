assert(require 'luconejo')

local connected_test = {
	create = function()
		local fixture = {
			channel = luconejo.Channel.Create( "localhost" ),
			message = luconejo.BasicMessage.Create("Test message")
		}
		assert.truthy( fixture.channel )
		assert.truthy( fixture.message )
		return fixture
	end	
}

-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------

describe("publishing messages via a channel", function()
	local this = connected_test.create()

	it("should be possible to send a simple message",function ()
    	assert.True( this.channel:BasicPublish("", "test_channel_routingkey", this.message, false, false) )
	end)

	it("should be possible to publish the same message multiple times",function ()
    	assert.True( this.channel:BasicPublish("", "test_channel_routingkey", this.message, false, false) )
    	assert.True( this.channel:BasicPublish("", "test_channel_routingkey", this.message, false, false) )
	end)

	it("should return mandatory messages sent to an unexistent queue",function ()
		assert.False( this.channel:BasicPublish("", "test_channel_noqueue", this.message, true, false) )
	end)
end)
