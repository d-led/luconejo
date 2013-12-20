assert(require 'luconejo')
local connected_test = assert(require 'test.connected_test')

describe("basic consume",function()
	local this = connected_test.create()

	it("should be able to start consuming",function ( )
			
		local queue = this.channel:SimpleDeclareQueue("")
		assert.True( #queue > 0 )
	    
	    local consumer = this.channel:SimpleBasicConsume(queue)
	    assert.True( #consumer > 0 )
	end)
end)

describe("consume nonexistent queue",function()
	local this = connected_test.create()

	it("should not be able to start consuming",function ( )
		local consumer = this.channel:SimpleBasicConsume("test_consume_noexistqueue")
		assert.False( #consumer > 0 )
	end)
end)

describe("duplicate tag",function()
	local this = connected_test.create()

	it("should not be able to start consuming",function ( )
		local queue = this.channel:SimpleDeclareQueue("")
		local consumer = this.channel:SimpleBasicConsume(queue)
		local consumer_duplicate = this.channel:BasicConsume(queue, consumer,true,true,true,1)
		assert.False( #consumer_duplicate > 0 )
	end)
end)

describe("cancelling consumer",function()
	local this = connected_test.create()

	it("should be able to cancel a consumer",function ( )
	local queue = this.channel:SimpleDeclareQueue("")
	local consumer = this.channel:SimpleBasicConsume( queue )
	assert.True( this.channel:BasicCancel(consumer) )
	end)
end)

describe("cancelling nonexistent consumer",function()
	local this = connected_test.create()

	it("should not cancel nonexistent consumers",function ( )
	    assert.False( this.channel:BasicCancel("test_consume_noexistconsumer") )
	end)

end)

describe("recancelling consumer",function()
	local this = connected_test.create()

	it("should not cancel cancelled consumers",function()
	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:SimpleBasicConsume(queue)
	    this.channel:BasicCancel(consumer)
	    assert.False( this.channel:BasicCancel(consumer) )
	end)

end)

describe("basic consume message",function()
	local this = connected_test.create()

	it("should deliver the messages successfully",function()
	    local message = luconejo.BasicMessage.Create("Message Body")
	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:SimpleBasicConsume(queue)
	    this.channel:SimpleBasicPublish("", queue, message)

	    local delivered = this.channel:BasicConsumeMessage(consumer, -1)
	    assert.True( delivered.Valid )
	    assert.are.Equal( consumer, delivered.ConsumerTag )
	    assert.are.Equal( "" , delivered.Exchange )
	    assert.are.Equal( queue , delivered.RoutingKey )
	    assert.are.Equal( message.Body , delivered.Message.Body )
	end)
end)

describe("consuming from bad consumer",function()
	local this = connected_test.create()

	it("should not be able to consume message",function()
    	assert.False( this.channel:BasicConsumeMessage("test_consume_noexistconsumer",-1).Valid )
    end)

end)

describe("basic consume inital qos", function()
	local this = connected_test.create()

	it("",function()
	    local message1 = luconejo.BasicMessage.Create("Message1")
	    local message2 = luconejo.BasicMessage.Create("Message2")
	    local message3 = luconejo.BasicMessage.Create("Message3")

	    local queue = this.channel:SimpleDeclareQueue("")
	    this.channel:BasicPublish("", queue, message1, true, false)
	    this.channel:BasicPublish("", queue, message2, true, false)
	    this.channel:BasicPublish("", queue, message3, true, false)

	    local consumer = this.channel:BasicConsume(queue, "", true, false,true,1)
	    local received1 = this.channel:BasicConsumeMessage(consumer, 1)
	    assert.True( received1.Valid )

	    local received2 = this.channel:BasicConsumeMessage(consumer, 0)
	    assert.False( received2.Valid )
	    assert.True( this.channel:BasicAck(received1) )

	    received2 = this.channel:BasicConsumeMessage(consumer, 1)
	    assert.True( received2.Valid )
	end)
end)

describe("2 consumers basic consume", function()
		local this = connected_test.create()

		it("",function()
			local message1 = luconejo.BasicMessage.Create("Message1")
			local message2 = luconejo.BasicMessage.Create("Message2")
			local message3 = luconejo.BasicMessage.Create("Message3")

			local queue1 = this.channel:SimpleDeclareQueue("")
			local queue2 = this.channel:SimpleDeclareQueue("")
			local queue3 = this.channel:SimpleDeclareQueue("")

			this.channel:SimpleBasicPublish("", queue1, message1)
			this.channel:SimpleBasicPublish("", queue2, message2)
			this.channel:SimpleBasicPublish("", queue3, message3)

			local consumer1 = this.channel:BasicConsume(queue1, "", true, false, true, 1)
			local consumer2 = this.channel:BasicConsume(queue2, "", true, false, true, 1)

			local envelope1 = this.channel:BasicConsumeMessage(consumer1,-1)
			assert.True( envelope1.Valid )
			assert.True( this.channel:BasicAck(envelope1) )
			local envelope2 = this.channel:BasicConsumeMessage(consumer2,-1)
			assert.True( envelope2.Valid )
			assert.True( this.channel:BasicAck(envelope2) )
			local envelope3 = this.channel:BasicGet(queue3,true)
			assert.True( envelope3.Valid )
			assert.True( this.channel:BasicAck(envelope3) )
		end)
end)

describe("basic consume 1000 messages",function()
	local this = connected_test.create()

	it("",function ()
	    local message1 = luconejo.BasicMessage.Create("Message1")

	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:SimpleBasicConsume(queue)

	    for i = 1,1000 do
			message1.Timestamp = i
			this.channel:BasicPublish("", queue, message1, true, false)
			local envelope = this.channel:BasicConsumeMessage(consumer, -1)
			assert.True( envelope.Valid )
			assert.are.Equal( envelope.Message.Timestamp , tostring(i) )
		end
	end)
end)

describe("basic_recover",function()
	local this = connected_test.create()

	it("",function()
	    local message = luconejo.BasicMessage.Create("Message1")

	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:BasicConsume(queue, "", true, false, true, 1)
	    this.channel:SimpleBasicPublish("", queue, message)

	    local message1 = this.channel:BasicConsumeMessage(consumer,-1)
	    assert.True( message1.Valid )
	    
	    assert.True( this.channel:BasicRecover(consumer) )

		local message2 = this.channel:BasicConsumeMessage(consumer,-1)
	    assert.True( message2.Valid )

	    assert.are.Equal( message1.Body, message2.Body )

	    this.channel:DeleteQueue(queue,false,false)
	end)
end)

describe("basic recover of a bad consumer", function()
	local this = connected_test.create()
    
    it("",function()
		assert.False( this.channel:BasicRecover("consumer_notexist") )
	end)
end)

describe("basic qos", function()
	local this = connected_test.create()

	it("", function()
	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:BasicConsume(queue, "", true, false, true, 1)
	    this.channel:SimpleBasicPublish("", queue, luconejo.BasicMessage.Create("Message1"))
	    this.channel:SimpleBasicPublish("", queue, luconejo.BasicMessage.Create("Message2"))

	    local incoming = this.channel:BasicConsumeMessage(consumer, 1)
	    assert.True( incoming.Valid )

	    incoming = this.channel:BasicConsumeMessage(consumer, 1)
	    assert.False( incoming.Valid )

	    assert.True( this.channel:BasicQos(consumer, 2) )
	    incoming = this.channel:BasicConsumeMessage(consumer, 1)
	    assert.True( incoming.Valid )

	    this.channel:DeleteQueue(queue,false,false)
	end)
end)

-- describe(connected_test, basic_qos_badconsumer)
--,function()
--     assert.False(this.channel:BasicQos("consumer_notexist", 1), ConsumerTagNotFoundException)
-- end)

-- describe(connected_test, consumer_cancelled)
--,function()
--     local queue = this.channel:DeclareQueue("")
--     local consumer = this.channel:BasicConsume(queue, "", true, false)
--     this.channel:DeleteQueue(queue)

--     assert.False(this.channel:BasicConsumeMessage(consumer), ConsumerCancelledException)
-- end)

-- describe(connected_test, consumer_cancelled_one_message)
--,function()
--     local queue = this.channel:DeclareQueue("")
--     local consumer = this.channel:BasicConsume(queue, "", true, false)

--     this.channel:BasicPublish("", queue, luconejo.BasicMessage.Create("Message"))
--     this.channel:BasicConsumeMessage(consumer)

--     this.channel:DeleteQueue(queue)

--     assert.False(this.channel:BasicConsumeMessage(consumer), ConsumerCancelledException)
-- end)

-- describe(connected_test, consume_multiple)
--,function()
--     local queue1 = this.channel:DeclareQueue("")
--     local queue2 = this.channel:DeclareQueue("")

--     local Body = "Message 1"
--     this.channel:BasicPublish("", queue1, luconejo.BasicMessage.Create(Body))


--     this.channel:BasicConsume(queue1)
--     this.channel:BasicConsume(queue2)

--     local env = this.channel:BasicConsumeMessage()

--     assert.are.Equal(Body, env->Message()->Body())
-- end)


-- describe("snippet"--,function()
-- 	local this = connected_test.create()

-- 	it("should be able to start consuming",function ( )
-- 	-- end)
-- end)

