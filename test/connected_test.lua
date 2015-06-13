local connected_test = {
	create = function()
		local test_host = 'localhost'
		local fixture = {
			host = test_host,
			channel = luconejo.Channel.Create( test_host ),
			message = luconejo.BasicMessage.Create("Test message")
		}
		assert ( fixture.channel )
		assert ( fixture.message )
		return fixture
	end
	,
	LargeMessage = function (num) t={} for i=1,num do t[#t+1]='a' end return table.concat(t) end
}

return connected_test
