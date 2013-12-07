/**
 * Copyright (c) 2013 Dmitry Ledentsov
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#include "luconejo_lib.h"

#include <LuaBridge.h>
#include <RefCountedPtr.h>
#include <string>
#include <cstdio>
#include <iostream>
#include <stdexcept>
#include <amqp.h>
#include <SimpleAmqpClient/SimpleAmqpClient.h>

#define xstr(s) str(s)
#define str(s) #s

namespace luconejo {
	namespace wrappers {


		////////////////////////////////////
		void Error(std::string const& err) {
			std::cerr << "luconejo exception: " << err << std::endl;
		}

		////////////////
		struct Channel {
			AmqpClient::Channel::ptr_t connection;

			static RefCountedPtr<Channel> Create(
					std::string const& host) {
				RefCountedPtr<Channel> res(new Channel);
				try {
					res->connection = AmqpClient::Channel::Create(host);
				} catch (std::exception const& e) {
					Error(e.what());
				}
				return res;
			}

			static RefCountedPtr<Channel> CreateWithParameters(
					std::string const& host,
					int port,
					std::string const& user,
					std::string const& password,
					std::string const& vhost,
					int frame_max
					) {
				RefCountedPtr<Channel> res(new Channel);
				try {
					res->connection = AmqpClient::Channel::Create(host,port,user,password,vhost,frame_max);
				} catch (std::exception const& e) {
					Error(e.what());
				}
				return res;
			}

			static RefCountedPtr<Channel> CreateFromUri(
					std::string const& host_uri) {
				RefCountedPtr<Channel> res(new Channel);
				try {
					res->connection = AmqpClient::Channel::CreateFromUri(host_uri);
				} catch (std::exception const& e) {
					Error(e.what());
				}
				return res;
			}

			void Disconnect() {
				connection.reset();
			}

			bool Valid() const {
				return connection;
			}

			void DeclareExchange(const std::string &exchange_name,
		                         const std::string &exchange_type,
		                         bool passive = false,
		                         bool durable = false,
		                         bool auto_delete = false) {
				if (!connection)
					return;

				connection->DeclareExchange(exchange_name,exchange_type,passive,durable,auto_delete);
			}

			void DeleteExchange(const std::string &exchange_name) {
				if (!connection)
					return;

				connection->DeleteExchange(exchange_name,false);
			}

			void DeleteExchangeIfUnused(const std::string &exchange_name) {
				if (!connection)
					return;

				connection->DeleteExchange(exchange_name,true);
			}

			static std::string EXCHANGE_TYPE_DIRECT() { return AmqpClient::Channel::EXCHANGE_TYPE_DIRECT; }
			static std::string EXCHANGE_TYPE_FANOUT() { return AmqpClient::Channel::EXCHANGE_TYPE_FANOUT; }
			static std::string EXCHANGE_TYPE_TOPIC() { return AmqpClient::Channel::EXCHANGE_TYPE_TOPIC; }
		};

	}
}

namespace luconejo {

	static const char* luconejo_version = "0.0.1";
	static const char* luconejo_SimpleAmqpClient_version = xstr(SIMPLEAMQPCLIENT_VERSION_MAJOR)"."xstr(SIMPLEAMQPCLIENT_VERSION_MINOR)"."xstr(SIMPLEAMQPCLIENT_VERSION_PATCH);

void register_luconejo (lua_State* L) {
	luabridge::getGlobalNamespace(L)
		.beginNamespace("luconejo")

			// global constants
			.addVariable("version",&luconejo_version,false)
			.addVariable("client_version",&luconejo_SimpleAmqpClient_version,false)
			.addFunction("amqp_version",&amqp_version)
		
			// Channel
			.beginClass<wrappers::Channel>("Channel")
				// constants
				.addStaticProperty("EXCHANGE_TYPE_DIRECT",&wrappers::Channel::EXCHANGE_TYPE_DIRECT)
				.addStaticProperty("EXCHANGE_TYPE_FANOUT",&wrappers::Channel::EXCHANGE_TYPE_FANOUT)
				.addStaticProperty("EXCHANGE_TYPE_TOPIC",&wrappers::Channel::EXCHANGE_TYPE_TOPIC)
		
				// factories
				.addStaticFunction("Create",wrappers::Channel::Create)
				.addStaticFunction("CreateWithParameters",wrappers::Channel::CreateWithParameters)
				.addStaticFunction("CreateFromUri",wrappers::Channel::CreateFromUri)
		
				// class
				.addProperty("Valid",&wrappers::Channel::Valid)
				.addFunction("Disconnect",&wrappers::Channel::Disconnect)
				.addFunction("DeclareExchange",&wrappers::Channel::DeclareExchange)
				.addFunction("DeleteExchange",&wrappers::Channel::DeleteExchange)
				.addFunction("DeleteExchangeIfUnused",&wrappers::Channel::DeleteExchangeIfUnused)
			.endClass()


		.endNamespace()
		;
}

}
