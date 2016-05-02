include 'premake'

local OS = os.get()

lua = assert(dofile 'premake/recipes/lua.lua')
boost = assert(dofile 'premake/recipes/boost.lua')

OS = os.get()

------------------------
make_solution 'luconejo'
------------------------

if OS == 'windows' then
	rabbitmq_lib = 'rabbitmq.4'
	includedirs 'C:/Program Files (x86)/rabbitmq-c/include'
	defines { 'WIN32', '_WIN32' }
	sac_library = make_shared_lib
else	
	rabbitmq_lib = 'rabbitmq'
	sac_library = make_static_lib
end

includedirs { 
	'./rabbitmq-c/librabbitmq',
	'./SimpleAmqpClient/src',
	'./LuaBridge-1.0.2',
	'./SimpleAmqpClient/third-party/gtest-1.7.0'
}

configuration 'windows'
	includedirs 'C:/Program Files (x86)/rabbitmq-c/include/'
	libdirs 'C:/Program Files (x86)/rabbitmq-c/lib'
configuration 'macosx'
	includedirs { '/usr/local/include/lua5.1' }
configuration '*'

boost:set_libdirs()

includedirs {
	lua.includedirs[OS],
	boost.includedirs[OS]
}

libdirs {
	lua.libdirs[OS]
}

defines { 'BOOST_NO_VARIADIC_TEMPLATES' }

-------------------------------
sac_library( 'SimpleAmqpClient',
	{
		'./SimpleAmqpClient/src/*.cpp',
		'./SimpleAmqpClient/src/**.h'
	}
)

if OS == 'windows' then
	links { rabbitmq_lib }
	targetdir '.'
end

defines 'SimpleAmqpClient_EXPORTS'

configuration 'linux'
	buildoptions '-fPIC'
configuration '*'

----------------------------
make_shared_lib( 'luconejo',
	{
		'./src/*.h',
		'./src/*.cpp'
	}
)

targetdir '.'

links {
	rabbitmq_lib,
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
	rabbitmq_lib,
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

-- run_target_after_build()
------------------------------------

newaction {
   trigger     = "test",
   description = "run lua test",
   execute     = function ()
      os.execute("busted --lpath=./?.lua test/test_connection.lua")
      os.execute("busted --lpath=./?.lua test/test_channels.lua")
      os.execute("busted --lpath=./?.lua test/test_ack.lua")
      os.execute("busted --lpath=./?.lua test/test_consume.lua")
      os.execute("busted --lpath=./?.lua test/test_exchange.lua")
      os.execute("busted --lpath=./?.lua test/test_get.lua")
      os.execute("busted --lpath=./?.lua test/test_message.lua")
      os.execute("busted --lpath=./?.lua test/test_publish.lua")
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
