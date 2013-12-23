assert(require 'luconejo')
local connected_test = assert(require 'test.connected_test')

describe("publish_success",function()
	local this = connected_test.create()

	it("",function()
    local message = luconejo.BasicMessage.Create("message body")

    assert.True( this.channel:SimpleBasicPublish("", "test_publish_rk", message) )
	end)
end)

describe("publish_large_message",function()
	local this = connected_test.create()
	it("",function()
	    local channel = luconejo.Channel.CreateWithParameters(this.host, 5672, "guest", "guest", "/", 4096)
	    assert.True( channel.Valid )
	    local message = luconejo.BasicMessage.Create( connected_test.LargeMessage(4099) )

	    assert.True( this.channel:SimpleBasicPublish("", "test_publish_rk", message) )
	end)
end)

describe("publish_badexchange",function()
	local this = connected_test.create()
	
	it("",function()
	    local message = luconejo.BasicMessage.Create("message body")

	    assert.False( this.channel:SimpleBasicPublish("test_publish_notexist", "test_publish_rk", message) )
	end)
end)

describe("publish_recover_from_error",function()
	local this = connected_test.create()

	it("",function()
	    local message = luconejo.BasicMessage.Create("message body")

	    assert.False( this.channel:SimpleBasicPublish("test_publish_notexist", "test_publish_rk", message) )
	    assert.True( this.channel:SimpleBasicPublish("", "test_publish_rk", message) )
	end)
end)

describe("publish_mandatory_fail",function()
	local this = connected_test.create()
	
	it("",function()
	    local message = luconejo.BasicMessage.Create("message body")

	    assert.False( this.channel:BasicPublish("", "test_publish_notexist", message, true, false) )
	end)
end)

describe("publish_mandatory_success",function()
	local this = connected_test.create()

	it("",function()
	    local message = luconejo.BasicMessage.Create("message body")
	    local queue = this.channel:SimpleDeclareQueue("")

	    assert.True( this.channel:BasicPublish("", queue, message, true, false) )
	end)
end)

-- not implemented yet
-- describe("DISABLED_publish_immediate_fail1",function()
-- 	local this = connected_test.create()

-- 	it("",function()
-- 	    local message = luconejo.BasicMessage.Create("message body")

-- 	    -- No queue connected
-- 	    assert.False( this.channel:BasicPublish("", "test_publish_notexist", message, false, true) )
-- 	end)
-- end)

-- not implemented yet
-- describe("DISABLED_publish_immediate_fail2",function()
-- 	local this = connected_test.create()

-- 	it("",function()
-- 	    local message = luconejo.BasicMessage.Create("message body")
-- 	    local queue = this.channel:SimpleDeclareQueue("")

-- 	    -- No consumer connected
-- 	    assert.False( this.channel:BasicPublish("", queue, message, false, true) )
-- 	end)
-- end)

describe("publish_immediate_success",function()
	local this = connected_test.create()

	it("",function()
	    local message = luconejo.BasicMessage.Create("message body")
	    local queue = this.channel:SimpleDeclareQueue("")
	    local consumer = this.channel:SimpleBasicConsume(queue)

	    assert.True( this.channel:BasicPublish("", queue, message, true, false) )
	end)
end)
