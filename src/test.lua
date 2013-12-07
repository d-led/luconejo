assert(require 'luconejo')

print('luconejo version : ' .. luconejo.version)
print('SimpleAmqpClient version : ' .. luconejo.client_version)
print('amqp version : ' .. luconejo.amqp_version())

local test_hostname = 'localhost'

describe("library is loaded correctly", function()
  assert.are.equal( type(luconejo) , "table" )
end)

describe("opening and closing a connection", function()

	local connection = luconejo.Channel.Create( test_hostname )

	it("should connect to the given host",function ()
		assert.True( connection.Valid )
	end)

	it("should be able to disconnect from the given host",function ()
		connection:Disconnect()
		assert.False( connection.Valid )
	end)
end)

describe("opening an invalid connection", function()
	it("should fail", function()
		local connection = luconejo.Channel.Create("HostDoesntExist")
		assert.False( connection.Valid )
	end)
end)