assert(require 'luconejo')
local connected_test = assert(require 'test.connected_test')

describe("connected_test",function()
	local this = connected_test.create()
	
	it("",function()
	    local message = luconejo.BasicMessage.Create("Message Body")
	    local queue = this.channel:SimpleDeclareQueue("")
	    assert.True( this.channel:BasicPublish("", queue, message, true, false) )

	    local new_message = this.channel:BasicGet(queue, true)
	    assert.True( new_message.Valid )
	    assert.are.Equal( message.Body , new_message.Message.Body )
	end)
end)

describe("connected_test",function()
	local this = connected_test.create()
	
	it("",function()
	    local message = luconejo.BasicMessage.Create("Message Body")
	    local queue = this.channel:SimpleDeclareQueue("")

	    local new_message = this.channel:BasicGet(queue, true)
	    assert.False( new_message.Valid )
	end)
end)

describe("large message", function()
	local this = connected_test.create()
	
	it("",function()
	    -- Smallest frame size allowed by AMQP
	    local channel = luconejo.Channel.CreateWithParameters(this.host, 5672, "guest", "guest", "/", 4096)
	    -- Create a message with a body larger than a single frame
	    local message = luconejo.BasicMessage.Create( connected_test.LargeMessage(4099) )
	    local queue = this.channel:SimpleDeclareQueue("")

	    assert.True( this.channel:SimpleBasicPublish("", queue, message) )
	    local new_message = this.channel:BasicGet(queue,true)
	    assert.True( new_message.Valid )
	    assert.are.Equal( message.Body , new_message.Message.Body )
	end)
end)

describe("connected_test",function()
	local this = connected_test.create()
	
	it("",function()
	    local new_message = this.channel:BasicGet("test_get_nonexistantqueue", true)
		assert.False( new_message.Valid )		
	end)
end)

describe("connected_test",function()
	local this = connected_test.create()
	
	it("",function()
	    local message = luconejo.BasicMessage.Create("Message Body")
	    local queue = this.channel:SimpleDeclareQueue("")
	    assert.True( this.channel:BasicPublish("", queue, message, true, false) )

	    local new_message = this.channel:BasicGet(queue, false)
	    assert.True( new_message.Valid )
	    assert.True( this.channel:BasicAck(new_message) )

	    assert.False( this.channel:BasicGet(queue, false).Valid )
	end)
end)
