# DirtySeed

Rake task to dump the current ActiveRecord database content into a working seeds.rb file

## Installation

Add this line to your application's Gemfile:

    gem 'dirty_seed', github: 'kogre/dirty_seed', group: :development

And then execute:

    $ bundle

## Usage

The gem provides 2 rake tasks.

### dump

To create a seeds.rb file from your current database, use the `db_dump` task. The task writes out the file content to standard out, so you probably want to run the following command from within your Rails project folder. Caution: This overwrites your existing `seeds.rb` file.


	$ rake dirty_seed:dump > db/seeds.rb


### reset

This is a convenience tasks that executes `db:drop`, `db:create`, `db:migrate` and `db:seed` consecutively in one command. It brings your database in the exact state described in the seedfile.


	$ rake dirty_seed:reset


## Disclaimer

The tasks have had limited testing with SQLite and PostgreSQL databases. It has been successfully used with Rails 3 and 4 on some project. Some datatypes might not work. Other databases might or might not work. If you run into problems, please post an issue or fix them yourself and create a pull request.

Only when I judge the gem to be stable, I will publish it to RubyGems for easier installation.

## Contributing

1. Fork it ( https://github.com/kogre/dirty_seed/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
