luconejo
========

a lua wrapper of the C++ RabbitMQ AMQP client library wrapper SimpleAmqpClient

api
===


global constants
----------------
`luconejo.version` luconejo version string

`luconejo.client_version` SimpleAmqpClient version

`luconejo.amqp_version()` rabbitmq-c version string

connecting
----------
```lua
connection = luconejo.Channel.Create( host ) -- create a connection (simple api)
connection = luconejo.Channel.CreateWithParameters(
	host,
	port,
	username,
	password,
	vhost,
	frame_max) -- create a connection
connection = luconejo.Channel.CreateFromUri( host_uri ) --  connect with an AMQP URI
connection.Valid -- check if connection succeeded
```

exchanges
---------
```lua

luconejo.Channel.EXCHANGE_TYPE_DIRECT -- constant
luconejo.Channel.EXCHANGE_TYPE_FANOUT -- constant
luconejo.Channel.EXCHANGE_TYPE_TOPIC -- constant

connection:DeclareExchange(
	exchange_name,
	exchange_type,
	passive,
	durable,
	auto_delete) -- declare an exchange
connection:DeleteExchange( exchange_name ) -- delete an exchange
connection:DeleteExchangeIfUnused( exchange_name ) -- delete an exchange if unused
```

disconnecting
-------------

`connection:Disconnect()`

exception mechanisms
--------------------

Currently, the wrapped objects have a `.Valid` property, indicating if the object has been successfully created.

If not valid, the object ignores commands.

The exception text is sent to `stderr`.

`void (...)` methods return `true` if succeeded or `false` if exception thrown.

building
--------

 - generate your makefiles or project files using premake
 - build accordingly

motivation: [Recursive Make Considered Harmful](http://miller.emu.id.au/pmiller/books/rmch/)

status
------

 - work in process
 - no SSL support yet, will be configurable in the future

dependencies
------------

all dependent libraries are built from source

 - rabbitmq-c
 - SimpleAmqpClient
 - LuaBridge
 - Premake for generating makefiles and solutions

license
-------

[MIT License](http://opensource.org/licenses/MIT)
