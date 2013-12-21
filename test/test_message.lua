assert(require 'luconejo')
local connected_test = assert(require 'test.connected_test')

describe("empty_message",function()
	it("", function()
	    local empty_message = luconejo.BasicMessage.Create ''

	    assert.are.Equal( "", empty_message.Body)
	end)
end)

describe("empty_message_add_body",function()
	it("", function()
	    local empty_message = luconejo.BasicMessage.Create ''

	    assert.are.Equal( "", empty_message.Body )

	    local body = "Message Body"
	    empty_message.Body = body

	    assert.are.Equal( body, empty_message.Body )
	end)
end)

describe("empty_message_add_body2",function()
	it("", function()
	    local empty_message = luconejo.BasicMessage.Create ''

	    assert.are.Equal( "", empty_message.Body )

	    local body = "Message Body"
	    empty_message.Body = body

	    assert.are.Equal( body , empty_message.Body )

	    local body2 = "Second body"
	    empty_message.Body =  body2
	    assert.are.Equal( body2 , empty_message.Body )
	end)
end)

describe("initial_message_replace",function()
	it("", function()
	    local first_body = "First message Body"
	    local message = luconejo.BasicMessage.Create(first_body)

	    assert.are.Equal( first_body , message.Body )

	    local second_body = "Second message Body"
	    message.Body = second_body

	    assert.are.Equal( second_body , message.Body )
	end)
end)

describe("initial_message_replace2",function()
	it("", function()
	    local first_body = "First message body"
	    local message = luconejo.BasicMessage.Create(first_body)
	    assert.are.Equal( first_body , message.Body )

	    local second_body = "second message body"
	    message.Body = second_body
	    assert.are.Equal( second_body , message.Body )

	    local third_body = "3rd Body"
	    message.Body = third_body
	    assert.are.Equal( third_body , message.Body )
	end)
end)

-- describe("embedded_nulls",function()
-- 	it("", function() -- c++ remnant. TODO: think of a test definition
-- 	    const boost::array<char, 7> message_data = {{ 'a', 'b', 'c', 0, '1', '2', '3' }}
-- 	    local body(message_data.data(), message_data.size())
-- 	    local message = luconejo.BasicMessage.Create(body)
-- 	    assert.are.Equal(body, message.Body)

-- 	    amqp_bytes_t amqp_body = message->getAmqpBody()
-- 	    assert.are.Equal(body.length(), amqp_body.len)
-- 	    EXPECT_TRUE(std::equal(message_data.begin(), message_data.end(), reinterpret_cast<char *>(amqp_body.bytes)))


-- 	    const boost::array<char, 7> message_data2 = {{ '1', '2', '3', 0, 'a', 'b', 'c' }}
-- 	    local body2(message_data2.data(), message_data2.size())
-- 	    message.Body =  body2)
-- 	    assert.are.Equal(body2, message.Body)

-- 	    amqp_bytes_t amqp_body2 = message->getAmqpBody()
-- 	    assert.are.Equal(body2.length(), amqp_body2.len)
-- 	    EXPECT_TRUE(std::equal(message_data2.begin(), message_data2.end(), reinterpret_cast<char *>(amqp_body2.bytes)))
-- 	end)
-- end)

describe("replaced_received_body",function()
	local this = connected_test.create()

	it("", function()
	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:SimpleBasicConsume(queue)

	    local body = "First Message Body"
	    local out_message = luconejo.BasicMessage.Create(body)
	    this.channel:SimpleBasicPublish("", queue, out_message)

	    local envelope = this.channel:BasicConsumeMessage(consumer,-1)
	    local in_message = envelope.Message
	    assert.are.Equal( out_message.Body , in_message.Body )

	    local body2 = "Second message body"
	    in_message.Body = body2
	    assert.are.Equal( body2 , in_message.Body )
	end)
end)
