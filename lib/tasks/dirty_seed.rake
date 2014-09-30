require 'dependency_ordener'

namespace :dirty_seed do

  def seed_record record, attributes
    line = "{"
    line += attributes.map{|a| a.to_s+": '"+escape_single_quotes(record.send(a).to_s)+"'"}.join(", ")
    line += "}"
  end

  def seed_table cls
    puts cls.name+".create(["
    puts cls.all.map{|t| seed_record(t, cls.column_names)}.join(", \n")
    if Gem.loaded_specs['activerecord'].version < Gem::Version.create('4.0')
      puts "], without_protection: true)\n\n"
    else
      puts "])\n\n"
    end
  end

  def escape_single_quotes str
    str.gsub(/'/, "\\\\'")
  end

  def models
    Rails.application.eager_load!
    models = ActiveRecord::Base.send :descendants
    dord = DependencyOrdener.new
    dord.order models    
  end

  desc "Dump all seed data"
  task :dump => [:environment] do
    puts "# encoding: UTF-8"
    models.each{|m| seed_table m}
    # reset primary key counter, needed for postgres when inserting explicit ids
    put "ActiveRecord::Base.connection.tables.each { |t|     ActiveRecord::Base.connection.reset_pk_sequence!(t) }"
  end

  desc "Drop, create, migrate and seed database"
  task :reset do

    Rake::Task['db:drop'].reenable
    Rake::Task['db:drop'].invoke
    puts 'Database dropped'

    Rake::Task['db:create'].reenable
    Rake::Task['db:create'].invoke
    puts 'Database created'

    Rake::Task['db:migrate'].reenable
    Rake::Task['db:migrate'].invoke
    puts 'Database migrated'

    Rake::Task['db:seed'].reenable
    Rake::Task['db:seed'].invoke
    puts 'Database seeded'
  end

end