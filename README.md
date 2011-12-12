## Purpose
Demo for [Winnipeg.rb](http://winnipegrb.org).

Libraries in use:

 * [Sinatra](http://www.sinatrarb.com/) - server to hit against
 * [Typhoeus](https://github.com/dbalatero/typhoeus) - http parallization library

## Quick Start

```shell
gem install sinatra typhoeus
ruby -rubygems server.rb # in separate window
ruby successes.rb # if using 1.9.2... supply -rubygems if using 1.8.7
```

Don't forget to kill your **sinatra** instance.


