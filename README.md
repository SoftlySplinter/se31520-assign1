SE31520: Enhancing the CS-Alumni Application
============================================

**Note:** This is part of university coursework. Not all code is my own; most of the server was produced by Chris Loftus of Aberystwyth University, Department of Computer Science.

By Alex Brown (adb9).

Requirements
------------
* ruby 1.9.3 (known to work with ruby 1.9.3p286 (2012-10-12 revision 37165) [i686-linux])
* FOX 1.6.x (see [FXRuby Installation Guide](https://github.com/lylejohnson/fxruby/wiki))
* All gems specified in `csa/Gemfile` and `client/Gemfile`


Running the CSA Server
----------------------
The server runs as a typical Rails application. To start it in development mode for local
testing run (you may also want to use `rails server -d` for detached mode):

```sh
cd csa/ && rails server
```

For information on how to run Ruby on Rails as part of a production environment I would
suggest looking at: [Ruby Guides](http://guides.rubyonrails.org/).

Configuring the CSA Client
--------------------------
To run the client you will need to ensure the server is running in a location accessible
to your machine. This might mean running a Rails development server on 
`http://localhost:5000` or it might mean a full production system.

To configure the client you will then need to edit the file `client/csa.conf` and modify
the line `site=http://localhost:5000` so that `http://localhost:5000` is the address used
to access the CSA server.

Running the CSA Client
----------------------
Once configured, use the following command to run the client:

```sh
cd client/ && ./csa-client
```

Running the CSA Server Tests
----------------------------
You can use rake to run all of the CSA Server Tests.

```sh
# Run all the tests, except rpsec
rake test

# Run unit tests only.
rake test:units

# Run functional tests only.
rake test:functionals

# Run RSpec tests.
rake test:rspec
```

Running the CSA Client Tests
----------------------------
You can run the CSA Client tests using rake:

```sh
rake test
```
