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
	-- local queue = this.channel:DeclareQueue("")
	-- local consumer = this.channel:BasicConsume(queue)
	-- this.channel:BasicCancel(consumer)
	end)
end)

-- describe(connected_test, basic_cancel_bad_consumer)
-- {
--     EXPECT_THROW(this.channel:BasicCancel("test_consume_noexistconsumer"), ConsumerTagNotFoundException);
-- }

-- describe(connected_test, basic_cancel_cancelled_consumer)
-- {
--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue);
--     this.channel:BasicCancel(consumer);
--     EXPECT_THROW(this.channel:BasicCancel(consumer), ConsumerTagNotFoundException);
-- }

-- describe(connected_test, basic_consume_message)
-- {
--     BasicMessage::ptr_t message = BasicMessage::Create("Message Body");
--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue);
--     this.channel:BasicPublish("", queue, message);

--     Envelope::ptr_t delivered;
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, delivered, -1));
--     EXPECT_EQ(consumer, delivered->ConsumerTag());
--     EXPECT_EQ("", delivered->Exchange());
--     EXPECT_EQ(queue, delivered->RoutingKey());
--     EXPECT_EQ(message->Body(), delivered->Message()->Body());
-- }

-- describe(connected_test, basic_consume_message_bad_consumer)
-- {
--     EXPECT_THROW(this.channel:BasicConsumeMessage("test_consume_noexistconsumer"), ConsumerTagNotFoundException);
-- }

-- describe(connected_test, basic_consume_inital_qos)
-- {
--     BasicMessage::ptr_t message1 = BasicMessage::Create("Message1");
--     BasicMessage::ptr_t message2 = BasicMessage::Create("Message2");
--     BasicMessage::ptr_t message3 = BasicMessage::Create("Message3");

--     std::string queue = this.channel:DeclareQueue("");
--     this.channel:BasicPublish("", queue, message1, true);
--     this.channel:BasicPublish("", queue, message2, true);
--     this.channel:BasicPublish("", queue, message3, true);

--     std::string consumer = this.channel:BasicConsume(queue, "", true, false);
--     Envelope::ptr_t received1, received2;
--     ASSERT_TRUE(this.channel:BasicConsumeMessage(consumer, received1, 1));

--     EXPECT_FALSE(this.channel:BasicConsumeMessage(consumer, received2, 0));
--     this.channel:BasicAck(received1);

--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, received2, 1));
-- }

-- describe(connected_test, basic_consume_2consumers)
-- {
--     BasicMessage::ptr_t message1 = BasicMessage::Create("Message1");
--     BasicMessage::ptr_t message2 = BasicMessage::Create("Message2");
--     BasicMessage::ptr_t message3 = BasicMessage::Create("Message3");

--     std::string queue1 = this.channel:DeclareQueue("");
--     std::string queue2 = this.channel:DeclareQueue("");
--     std::string queue3 = this.channel:DeclareQueue("");

--     this.channel:BasicPublish("", queue1, message1);
--     this.channel:BasicPublish("", queue2, message2);
--     this.channel:BasicPublish("", queue3, message3);

--     std::string consumer1 = this.channel:BasicConsume(queue1, "", true, false);
--     std::string consumer2 = this.channel:BasicConsume(queue2, "", true, false);

--     Envelope::ptr_t envelope1;
--     Envelope::ptr_t envelope2;
--     Envelope::ptr_t envelope3;

--     this.channel:BasicConsumeMessage(consumer1, envelope1);
--     this.channel:BasicAck(envelope1);
--     this.channel:BasicConsumeMessage(consumer2, envelope2);
--     this.channel:BasicAck(envelope2);
--     this.channel:BasicGet(envelope3, queue3);
--     this.channel:BasicAck(envelope3);
-- }

-- describe(connected_test, basic_consume_1000messages)
-- {
--     BasicMessage::ptr_t message1 = BasicMessage::Create("Message1");

--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue, "");

--     Envelope::ptr_t msg;
--     for (int i = 0; i < 1000; ++i)
--     {
--         message1->Timestamp(i);
--         this.channel:BasicPublish("", queue, message1, true);
--         this.channel:BasicConsumeMessage(consumer, msg);
--     }

-- }

-- describe(connected_test, basic_recover)
-- {
--     BasicMessage::ptr_t message = BasicMessage::Create("Message1");

--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue, "", true, false);
--     this.channel:BasicPublish("", queue, message);

--     Envelope::ptr_t message1;
--     Envelope::ptr_t message2;

--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, message1));
--     this.channel:BasicRecover(consumer);
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, message2));

--     this.channel:DeleteQueue(queue);
-- }

-- describe(connected_test, basic_recover_badconsumer)
-- {
--     EXPECT_THROW(this.channel:BasicRecover("consumer_notexist"), ConsumerTagNotFoundException);
-- }

-- describe(connected_test, basic_qos)
-- {
--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue, "", true, false);
--     this.channel:BasicPublish("", queue, BasicMessage::Create("Message1"));
--     this.channel:BasicPublish("", queue, BasicMessage::Create("Message2"));

--     Envelope::ptr_t incoming;
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, incoming, 1));
--     EXPECT_FALSE(this.channel:BasicConsumeMessage(consumer, incoming, 1));

--     this.channel:BasicQos(consumer, 2);
--     EXPECT_TRUE(this.channel:BasicConsumeMessage(consumer, incoming, 1));

--     this.channel:DeleteQueue(queue);
-- }

-- describe(connected_test, basic_qos_badconsumer)
-- {
--     EXPECT_THROW(this.channel:BasicQos("consumer_notexist", 1), ConsumerTagNotFoundException);
-- }

-- describe(connected_test, consumer_cancelled)
-- {
--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue, "", true, false);
--     this.channel:DeleteQueue(queue);

--     EXPECT_THROW(this.channel:BasicConsumeMessage(consumer), ConsumerCancelledException);
-- }

-- describe(connected_test, consumer_cancelled_one_message)
-- {
--     std::string queue = this.channel:DeclareQueue("");
--     std::string consumer = this.channel:BasicConsume(queue, "", true, false);

--     this.channel:BasicPublish("", queue, BasicMessage::Create("Message"));
--     this.channel:BasicConsumeMessage(consumer);

--     this.channel:DeleteQueue(queue);

--     EXPECT_THROW(this.channel:BasicConsumeMessage(consumer), ConsumerCancelledException);
-- }

-- describe(connected_test, consume_multiple)
-- {
--     std::string queue1 = this.channel:DeclareQueue("");
--     std::string queue2 = this.channel:DeclareQueue("");

--     std::string Body = "Message 1";
--     this.channel:BasicPublish("", queue1, BasicMessage::Create(Body));


--     this.channel:BasicConsume(queue1);
--     this.channel:BasicConsume(queue2);

--     Envelope::ptr_t env = this.channel:BasicConsumeMessage();

--     EXPECT_EQ(Body, env->Message()->Body());
-- }


-- describe("snippet",function()
-- 	local this = connected_test.create()

-- 	it("should be able to start consuming",function ( )
-- 	end)
-- end)

