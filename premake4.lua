_G.package.path=_G.package.path..[[;./?.lua;./?/?.lua]]

assert( require 'premake.quickstart' )

local OS = os.get()
local settings = {
	links = {
		linux = { 'lua5.1-c++' , 'boost_chrono' },
		windows = { 'lua5.1' },
		macosx = { 'lua' , 'boost_chrono-mt'}
	},
	exec_prefix = {
		linux = "./",
		windows = "",
		macosx = "./"
	},
	test_links = {
		linux = { 'boost_chrono', 'boost_system', 'pthread' },
		windows = { },
		macosx = { 'boost_chrono-mt', 'boost_system-mt' }
	}
}

local function platform_specifics()
	-- platform specific --
	configuration 'macosx'
		targetprefix ''
		targetextension '.so'
	configuration 'windows'
		includedirs { [[C:\Users\Public\lua\LuaRocks\2.1\include]] , os.getenv 'BOOST' }
		libdirs { [[C:\Users\Public\lua\LuaRocks\2.1]] , path.join(os.getenv'BOOST',[[stage\lib]]) }
	configuration 'linux'
		targetprefix ''
		includedirs { [[/usr/include/lua5.1]] }
	configuration { '*' }
end

------------------------
make_solution 'luconejo'
------------------------

includedirs { 
	'./rabbitmq-c/librabbitmq',
	'./SimpleAmqpClient/src',
	'./LuaBridge-1.0.2',
	'./SimpleAmqpClient/third-party/gtest-1.7.0'
}

defines { 'BOOST_NO_VARIADIC_TEMPLATES' }

--------------------------
make_static_lib( 'SimpleAmqpClient',
	{
		'./SimpleAmqpClient/src/*.cpp',
		'./SimpleAmqpClient/src/**.h'
	}
)
language "C++"

----------------------------
make_shared_lib( 'luconejo',
	{
		'./src/*.h',
		'./src/*.cpp'
	}
)

targetdir '.'

language "C++"

links {
	'rabbitmq',
	'SimpleAmqpClient',
	settings.links[OS]
}

platform_specifics()

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
	settings.test_links[OS]
}

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
		os.execute(settings.exec_prefix[OS].."build_rabbitmq")
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
