assert(require 'luconejo')
local connected_test = assert(require 'connected_test')

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