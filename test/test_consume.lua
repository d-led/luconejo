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

	it("should be able to start consuming",function ( )
		local queue = this.channel:SimpleDeclareQueue("")
		local consumer = this.channel:SimpleBasicConsume(queue)
		local consumer_duplicate = this.channel:BasicConsume(queue, consumer,true,true,true,1)
		assert.False( #consumer_duplicate > 0 )
	end)
end)


-- describe("snippet",function()
-- 	local this = connected_test.create()

-- 	it("should be able to start consuming",function ( )		
-- 	end)
-- end)

