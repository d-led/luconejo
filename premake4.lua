_G.package.path=_G.package.path..[[;./?.lua;./?/?.lua]]

assert( require 'premake.quickstart' )

make_solution 'luconejo'

make_console_app('luconejo', { 'luconejo.cpp' })

make_cpp11()

