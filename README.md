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
	frame_max)
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
	auto_delete)
connection:DeleteExchange( exchange_name )
connection:DeleteExchangeIfUnused( exchange_name ) -- delete an exchange if unused
connection:BindExchange( destination, source, routing key )
connection:UnbindExchange( destination, source, routing key )
```

queues
------

```lua
local queue_name = connection:DeclareQueue(
	queue_name,
	passive,
	durable,
	exclusive,
	auto_delete)
	-- returns luconejo.Channel.INVALID_QUEUE_NAME if failed
```

disconnecting
-------------

`connection:Disconnect()`

basic message
-------------

`message = luconejo.BasicMessage.Create( body )` create a message with a string-body`

publishing a message
--------------------

`connection:BasicPublish(exchange_name, routing key, message, mandatory, immediate)` message should be a `luconejo.BasicMessage`.

exception mechanisms
--------------------

Currently, the wrapped objects have a `.Valid` property, indicating if the object has been successfully created.

If not valid, the object ignores commands.

The exception text is sent to `stderr`.

`void (...)` methods return `true` if succeeded or `false` if exception thrown.

binding details
---------------

All parameters are mandatory at the moment. C++ Function signatures with default values or without are mapped onto different Lua functions.

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
 
 testing
 -------
 
  - start RabbitMQ
  - premake/premake4 test

license
-------

[MIT License](http://opensource.org/licenses/MIT)
