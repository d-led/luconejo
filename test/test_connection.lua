assert(require 'luconejo')

print('luconejo version : ' .. luconejo.version)
print('SimpleAmqpClient version : ' .. luconejo.client_version)
print('amqp version : ' .. luconejo.amqp_version())

local test_hostname = 'localhost'

------------------------------------------------------------------------------------

describe("library is loaded correctly", function()
	it("should be a table", function ()
		assert.are.equal( type(luconejo) , "table" )
	end)
end)

------------------------------------------------------------------------------------

describe("opening and closing a connection", function()

	local connection = luconejo.Channel.Create( test_hostname )

	it("should connect to the given host",function ()
		assert.True( connection.Valid )
	end)

	it("should be able to disconnect from the given host",function ()
		assert.True( connection:Disconnect() )
		assert.False( connection.Valid )
	end)

	it("should be able to connect from an uri",function ()
		local host_uri = "amqp://" .. test_hostname
    	local channel = luconejo.Channel.CreateFromUri( host_uri )
		assert.True( channel.Valid )
	end)
end)

describe("opening an invalid connection", function()
	it("should fail when asking for an unknown host", function()
		local connection = luconejo.Channel.Create("HostDoesntExist")
		assert.truthy( connection )
		assert.False( connection.Valid )
	end)

	it("should fail when providing bad credentials", function()
	    local connection = luconejo.Channel.CreateWithParameters(test_hostname, 5672, "baduser", "badpass","/",10000)
	    assert.truthy( connection )
	    assert.False ( connection.Valid )
	end)

	it("should fail when a minimum frame size of 4096 is not given", function()
	    local connection = luconejo.Channel.CreateWithParameters(test_hostname, 5672, "guest", "guest", "/", 400)
	    assert.truthy( connection )
	    assert.False ( connection.Valid )
	end)

	it("should fail when a nonexitant vhost is given", function()
	    local connection = luconejo.Channel.CreateWithParameters(test_hostname, 5672, "guest", "guest", "nonexitant_vhost", 10000)
	    assert.truthy( connection )
	    assert.False ( connection.Valid )
	end)
end)

------------------------------------------------------------------------------------
