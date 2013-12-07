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

			void Disconnect() {
				connection.reset();
			}

			bool Valid() const {
				return connection;
			}
		};

	}
}

namespace luconejo {

	static const char* luconejo_version = "0.0.1";
	static const char* luconejo_SimpleAmqpClient_version = xstr(SIMPLEAMQPCLIENT_VERSION_MAJOR)"."xstr(SIMPLEAMQPCLIENT_VERSION_MINOR)"."xstr(SIMPLEAMQPCLIENT_VERSION_PATCH);

void register_luconejo (lua_State* L) {
	luabridge::getGlobalNamespace(L)
		.beginNamespace("luconejo")

			.addVariable("version",&luconejo_version,false)
			.addVariable("client_version",&luconejo_SimpleAmqpClient_version,false)
			.addFunction("amqp_version",&amqp_version)
		
			.beginClass<wrappers::Channel>("Channel")
				.addStaticFunction("Create",wrappers::Channel::Create)
				.addProperty("Valid",&wrappers::Channel::Valid)
				.addFunction("Disconnect",&wrappers::Channel::Disconnect)
			.endClass()


		.endNamespace()
		;
}

}
