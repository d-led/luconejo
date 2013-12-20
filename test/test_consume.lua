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

-- describe(connected_test, basic_consume_inital_qos)
--,function()
--     local message1 = BasicMessage::Create("Message1")
--     local message2 = BasicMessage::Create("Message2")
--     local message3 = BasicMessage::Create("Message3")

--     local queue = this.channel:DeclareQueue("")
--     this.channel:BasicPublish("", queue, message1, true)
--     this.channel:BasicPublish("", queue, message2, true)
--     this.channel:BasicPublish("", queue, message3, true)

--     local consumer = this.channel:BasicConsume(queue, "", true, false)
--     local received1, received2
--     ASSERT_TRUE(this.channel:BasicConsumeMessage(consumer, received1, 1))

--     EXPECT_FALSE(this.channel:BasicConsumeMessage(consumer, received2, 0))
--     this.channel:BasicAck(received1)

--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, received2, 1))
-- end)

-- describe(connected_test, basic_consume_2consumers)
--,function()
--     local message1 = BasicMessage::Create("Message1")
--     local message2 = BasicMessage::Create("Message2")
--     local message3 = BasicMessage::Create("Message3")

--     local queue1 = this.channel:DeclareQueue("")
--     local queue2 = this.channel:DeclareQueue("")
--     local queue3 = this.channel:DeclareQueue("")

--     this.channel:BasicPublish("", queue1, message1)
--     this.channel:BasicPublish("", queue2, message2)
--     this.channel:BasicPublish("", queue3, message3)

--     local consumer1 = this.channel:BasicConsume(queue1, "", true, false)
--     local consumer2 = this.channel:BasicConsume(queue2, "", true, false)

--     local envelope1
--     local envelope2
--     local envelope3

--     this.channel:BasicConsumeMessage(consumer1, envelope1)
--     this.channel:BasicAck(envelope1)
--     this.channel:BasicConsumeMessage(consumer2, envelope2)
--     this.channel:BasicAck(envelope2)
--     this.channel:BasicGet(envelope3, queue3)
--     this.channel:BasicAck(envelope3)
-- end)

-- describe(connected_test, basic_consume_1000messages)
--,function()
--     local message1 = BasicMessage::Create("Message1")

--     local queue = this.channel:DeclareQueue("")
--     local consumer = this.channel:BasicConsume(queue, "")

--     local msg
--     for (int i = 0 i < 1000 ++i)
--     {
--         message1->Timestamp(i)
--         this.channel:BasicPublish("", queue, message1, true)
--         this.channel:BasicConsumeMessage(consumer, msg)
--     }

-- end)

-- describe(connected_test, basic_recover)
--,function()
--     local message = BasicMessage::Create("Message1")

--     local queue = this.channel:DeclareQueue("")
--     local consumer = this.channel:BasicConsume(queue, "", true, false)
--     this.channel:BasicPublish("", queue, message)

--     local message1
--     local message2

--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, message1))
--     this.channel:BasicRecover(consumer)
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, message2))

--     this.channel:DeleteQueue(queue)
-- end)

-- describe(connected_test, basic_recover_badconsumer)
--,function()
--     assert.False(this.channel:BasicRecover("consumer_notexist"), ConsumerTagNotFoundException)
-- end)

-- describe(connected_test, basic_qos)
--,function()
--     local queue = this.channel:DeclareQueue("")
--     local consumer = this.channel:BasicConsume(queue, "", true, false)
--     this.channel:BasicPublish("", queue, BasicMessage::Create("Message1"))
--     this.channel:BasicPublish("", queue, BasicMessage::Create("Message2"))

--     local incoming
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, incoming, 1))
--     EXPECT_FALSE(this.channel:BasicConsumeMessage(consumer, incoming, 1))

--     this.channel:BasicQos(consumer, 2)
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, incoming, 1))

--     this.channel:DeleteQueue(queue)
-- end)

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

--     this.channel:BasicPublish("", queue, BasicMessage::Create("Message"))
--     this.channel:BasicConsumeMessage(consumer)

--     this.channel:DeleteQueue(queue)

--     assert.False(this.channel:BasicConsumeMessage(consumer), ConsumerCancelledException)
-- end)

-- describe(connected_test, consume_multiple)
--,function()
--     local queue1 = this.channel:DeclareQueue("")
--     local queue2 = this.channel:DeclareQueue("")

--     local Body = "Message 1"
--     this.channel:BasicPublish("", queue1, BasicMessage::Create(Body))


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

