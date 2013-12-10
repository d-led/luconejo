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

	it("should fail sending to nonexistent exchange", function( )
		assert.False( this.channel:BasicPublish("test_channel_badexchange", "test_channel_rk", this.message, false, false) )
	end)

	it("should be able to recover from bad message publish",function()
		this.channel:BasicPublish("test_channel_badexchange", "test_channel_rk", this.message, false, false)

		assert.True( this.channel:BasicPublish("", "test_channel_rk", this.message, false, false) )
	end)
end)

describe("consuming messages",function ()
	local this = connected_test.create()

	it("should consume a message sent within 1 second",function ()
		local queue = this.channel:DeclareQueue("",false,false,true,true)

		local consumer = this.channel:BasicConsume(queue, "", true, false, true, 1)
		this.channel:BasicPublish("", queue, this.message,false,false)

		local consumed_envelope = this.channel:BasicConsumeMessage(consumer, 1)
		assert.True( consumed_envelope.Valid )
	end)

	local function repeated_string(count, contents)
		local message_table = {}
		for i = 1, count do message_table[#message_table+1] = contents end
		return table.concat(message_table)
	end

	it("should be possible to send large messages", function()
		-- another channel here
		local channel = luconejo.Channel.CreateWithParameters( this.host, 5672, "guest", "guest", "/", 4096)
		assert.True( channel.Valid )

		-- create message
		local message_length = 4099
		local message_text = repeated_string(message_length, 'a')
		assert.are.equal( #message_text , message_length )
		local message = luconejo.BasicMessage.Create( message_text )
		assert.True( message.Valid )

		-- declare queue
		local queue = channel:SimpleDeclareQueue("")
		assert.are.not_equal ( queue , luconejo.Channel.INVALID_QUEUE_NAME )

		local consumer = channel:SimpleBasicConsume( queue )
		assert.are.not_equal ( consumer , luconejo.Channel.INVALID_CONSUMER_TAG )

		assert.True( channel:BasicPublish("", queue, message, false, false) )

		local consumed_envelope =  channel:BasicConsumeMessage(consumer, -1)
		assert.True( consumed_envelope.Valid )
		local received_message = consumed_envelope.Message
		assert.True( received_message.Valid )
		assert.are.equal( message_text , received_message.Body )
	end)
end)
