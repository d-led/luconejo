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

return connected_test
