include 'premake'

local OS = os.get()

lua = assert(dofile 'premake/recipes/lua.lua')
boost = assert(dofile 'premake/recipes/boost.lua')

OS = os.get()

------------------------
make_solution 'luconejo'
------------------------

includedirs { 
	'./rabbitmq-c/librabbitmq',
	'./SimpleAmqpClient/src',
	'./LuaBridge-1.0.2',
	'./SimpleAmqpClient/third-party/gtest-1.7.0'
}

boost:set_libdirs()

includedirs {
	lua.includedirs[OS],
	boost.includedirs[OS]
}

libdirs {
	lua.libdirs[OS]
}

defines { 'BOOST_NO_VARIADIC_TEMPLATES' }

--------------------------
make_static_lib( 'SimpleAmqpClient',
	{
		'./SimpleAmqpClient/src/*.cpp',
		'./SimpleAmqpClient/src/**.h'
	}
)

----------------------------
make_shared_lib( 'luconejo',
	{
		'./src/*.h',
		'./src/*.cpp'
	}
)

targetdir '.'

links {
	'rabbitmq',
	'SimpleAmqpClient',
}

links {
	lua.links[OS],
	boost.links[OS]
}

targetprefix ''

configuration 'macosx'
	links 'boost_chrono'
	targetextension '.so'
configuration 'linux'
	links 'boost_chrono'
configuration '*'

--original tests--------------------
make_static_lib( 'gtest',
	{
		'./SimpleAmqpClient/third-party/gtest-1.7.0/gtest/*.cc'
	}
)

make_console_app( 'SimpleAmqpClientTests',
	{
		'./SimpleAmqpClient/testing/*.cpp'
	}
)

links {
	'rabbitmq',
	'SimpleAmqpClient',
	'gtest',
}

links {
	lua.links[OS],
	boost.links[OS]
}

configuration 'macosx'
	links 'boost_chrono'
configuration 'linux'
	links {
		'boost_chrono',
	}
configuration '*'

run_target_after_build()
------------------------------------

newaction {
   trigger     = "test",
   description = "run lua test",
   execute     = function ()
      os.execute("busted test/test_connection.lua")
      os.execute("busted test/test_channels.lua")
      os.execute("busted test/test_ack.lua")
      os.execute("busted test/test_consume.lua")
      os.execute("busted test/test_exchange.lua")
      os.execute("busted test/test_get.lua")
      os.execute("busted test/test_message.lua")
      os.execute("busted test/test_publish.lua")
   end
}

newaction {
	trigger = "prepare",
	description = "build and install librabbitmq",
	execute = function ()
		os.execute("./build_rabbitmq")
	end
}

newaction {
	trigger = 'start',
	description = 'start the rabbitmq server',
	execute = function ()
		os.execute 'rabbitmq-server start &'
	end
}

newaction {
	trigger = 'stop',
	description = 'stop the rabbitmq server',
	execute = function ()
		os.execute 'rabbitmqctl stop'
	end
}
