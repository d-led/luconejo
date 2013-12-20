**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [luconejo](#luconejo)
- [api](#api)
	- [reading convention](#reading-convention)
	- [global constants](#global-constants)
	- [connecting](#connecting)
	- [exchanges](#exchanges)
	- [queues](#queues)
	- [disconnecting](#disconnecting)
	- [basic message](#basic-message)
	- [publishing a message](#publishing-a-message)
	- [consuming a message](#consuming-a-message)
	- [acknowledging a message](#acknowledging-a-message)
	- [recovering an unacknowledged message](#recovering-an-unacknowledged-message)
	- [quality of service](#quality-of-service)
- [error handling](#error-handling)
- [binding details](#binding-details)
- [building](#building)
- [status](#status)
- [motivation](#motivation)
- [dependencies](#dependencies)
- [license](#license)

luconejo
========

a lua wrapper of the C++ RabbitMQ AMQP client library wrapper SimpleAmqpClient written mostly on a subway train

[![Build Status](https://travis-ci.org/d-led/luconejo.png?branch=master)](https://travis-ci.org/d-led/luconejo)


api
===

reading convention
------------------

The api is mirroring the c++ api as closely as possible. Some overloads are split into multiple functions.
To read the full documentation, please refer to the original documentation in [SimpleAmqpClient](https://github.com/woldan/SimpleAmqpClient/tree/master/src).
The full binding can be seen at a glance in [luconejo_lib.cpp -> register_luconejo](src/luconejo_lib.cpp)
See the [tests](test) for the API usage examples


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
local queue_name = connection:SimpleDeclareQueue( queue_name )
local queue_name = connection:DeclareQueue(
	queue_name,
	passive,
	durable,
	exclusive,
	auto_delete)
	-- returns luconejo.Channel.INVALID_QUEUE_NAME if failed

connection:BindQueue( queue_name, exchange_name, routing_key )
connection:UnbindQueue( queue_name, exchange_name, routing_key )
connection:PurgeQueue( queue_name )

connection:DeleteQueue( queue_name, if_unused, if_empty )
```

disconnecting
-------------

`connection:Disconnect()`

basic message
-------------

`message = luconejo.BasicMessage.Create( body )` create a message with a string-body`
`local body = message.Body` get the message text

publishing a message
--------------------

`connection:BasicPublish(exchange_name, routing key, message, mandatory, immediate)` message should be a `luconejo.BasicMessage`.
`connection:SimpleBasicPublish(exchange_name, routing key, message)` nonmandatory and not immediate.

consuming a message
-------------------

`local consumer_tag = connection:SimpleBasicConsume(queue)`
`local consumer_tag = connection:BasicConsume(queue,consumer_tag,no_local,no_ack,exclusive,prefetch_count)` returns the consumer tag
`local envelope = connection:BasicConsumeMessage(consumer_tag,timeout)`
`local envelope = connection:BasicGet( queue, no_ack )`
`local message = envelope.Message` returns `luconejo.BasicMessage`

`connection:BasicCancel( consumer_tag )` stop consuming

acknowledging a message
-----------------------

`connection:BasicAck(envelope)` where `envelope` is `luconejo.Envelope`

recovering an unacknowledged message
------------------------------------

`connection:BasicRecover( consumer )`

quality of service
------------------

`connection:BasicQos( consumer, message_prefetch_count )`

error handling
==============

Currently, the wrapped objects have a `.Valid` property, indicating if the object has been successfully created.

If not valid, the object ignores commands.

The exception text is sent to `stderr`.

`void (...)` methods return `true` if succeeded or `false` if exception thrown.

binding details
===============

All parameters are mandatory at the moment. C++ Function signatures with default values or without are mapped onto different Lua functions.

building
========

 - generate your makefiles or project files using premake
 - on Linux and MacOS X the rabbitmq-c library can be built and installed using `premake4 prepare`
 - build accordingly

motivation: [Recursive Make Considered Harmful](http://miller.emu.id.au/pmiller/books/rmch/)

status
======

 - work in process
 - no SSL support yet, will be configurable in the future
 - compiles and passes tests with clang on MacOS X only
 - rabbitmq-c should be built with its own CMake config and linked dynamically

motivation
==========

By way of writing this binding, partially going the wrong way of wrapping an otherwise simpler-bindable class, I can dive into the API and its details.

dependencies
============

all dependent libraries are built from source

 - rabbitmq-c
 - SimpleAmqpClient
 - LuaBridge
 - Premake for generating makefiles and solutions
 
 testing
 =======
 
  - start RabbitMQ
  - `> premake/premake4 test`

license
=======

[MIT License](http://opensource.org/licenses/MIT)
