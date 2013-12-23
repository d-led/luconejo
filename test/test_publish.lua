assert(require 'luconejo')
local connected_test = assert(require 'test.connected_test')

describe("publish_success",function()
	local this = connected_test.create()

	it("",function()
    local message = luconejo.BasicMessage.Create("message body")

    assert.True( this.channel:SimpleBasicPublish("", "test_publish_rk", message) )
	end)
end)

-- TEST(test_publish, publish_large_message)
-- {
--     // Smallest frame size allowed by AMQP
--     local channel = Channel::Create(this.host, 5672, "guest", "guest", "/", 4096)
--     // Create a message with a body larger than a single frame
--     local message = luconejo.BasicMessage.Create(std::string(4099, 'a'))

--     this.channel:BasicPublish("", "test_publish_rk", message)
--	end)
-- end)

-- describe("publish_badexchange",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")

--     EXPECT_THROW(this.channel:BasicPublish("test_publish_notexist", "test_publish_rk", message), ChannelException)
--	end)
-- end)

-- describe("publish_recover_from_error",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")

--     EXPECT_THROW(this.channel:BasicPublish("test_publish_notexist", "test_publish_rk", message), ChannelException)
--     this.channel:BasicPublish("", "test_publish_rk", message)
--	end)
-- end)

-- describe("publish_mandatory_fail",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")

--     EXPECT_THROW(this.channel:BasicPublish("", "test_publish_notexist", message, true), MessageReturnedException)
--	end)
-- end)

-- describe("publish_mandatory_success",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")
--     std::string queue = this.channel:DeclareQueue("")

--     this.channel:BasicPublish("", queue, message, true)
--	end)
-- end)

-- describe("DISABLED_publish_immediate_fail1",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")

--     // No queue connected
--     EXPECT_THROW(this.channel:BasicPublish("", "test_publish_notexist", message, false, true), MessageReturnedException)
--	end)
-- end)

-- describe("DISABLED_publish_immediate_fail2",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")
--     std::string queue = this.channel:DeclareQueue("")

--     // No consumer connected
--     EXPECT_THROW(this.channel:BasicPublish("", queue, message, false, true), MessageReturnedException)
--	end)
-- end)

-- describe("publish_immediate_success",function()
-- 	local this = connected_test.create()
--	it("",function()
--     local message = luconejo.BasicMessage.Create("message body")
--     std::string queue = this.channel:DeclareQueue("")
--     std::string consumer = this.channel:BasicConsume(queue, "")

--     this.channel:BasicPublish("", queue, message, true)
--	end)
-- end)
