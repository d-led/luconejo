assert(require 'luconejo')

local connected_test = {
	create = function()
		local test_host = 'localhost'
		local fixture = {
			host = test_host,
			channel = luconejo.Channel.Create( test_host ),
			message = luconejo.BasicMessage.Create("Test message")
		}
		assert.truthy( fixture.channel )
		assert.truthy( fixture.message )
		return fixture
	end	
}

describe("basic ack",function()
	local this = connected_test.create()

	it("should work",function()

		local queue = this.channel:SimpleDeclareQueue("")

	    assert.True( this.channel:SimpleBasicPublish("", queue, this.message) )

	    local consumer = this.channel:BasicConsume(queue, "", true, false, true, 1)

	    local env = this.channel:BasicConsumeMessage(consumer,-1)

	    assert.True( env.Valid )

	    assert.True ( this.channel:BasicAck(env) )
	end)
end)