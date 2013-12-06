luconejo
========

a lua wrapper of the C++ RabbitMQ AMQP client library wrapper SimpleAmqpClient

api
---

| api | description | source |
| --- | ----------- | ------ |
| `luconejo.version` | luconejo version string | binding |
| `luconejo.client_version` | SimpleAmqpClient version | binding |
| `luconejo.amqp_version()` | rabbitmq-c version string | rabbitmq-c |
| `connection = luconejo.Channel.Create( host )` | create a connection (simple api) | binding |
| `connection.Valid` | check if connection succeeded | binding |

exception mechanisms
--------------------

Currently, the wrapped objects have a `.Valid` property, indicating if the object has been successfully created.

If not valid, the object ignores commands.

The exception text is sent to `stderr`.

building
--------

 - generate your makefiles or project files using premake

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
