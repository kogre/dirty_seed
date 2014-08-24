namespace :dirty_seed do

  def seed_line record, attributes
    line = "{"
    line += attributes.map{|a| a.to_s+": '"+escape_single_quotes(record.send(a).to_s)+"'"}.join(", ")
    line += "}"
    line
  end

  def seed_table cls
    puts cls.name+".create(["
    puts cls.all.map{|t| seed_line(t, cls.column_names)}.join(", ")
    puts "], without_protection: true)"
  end

  def escape_single_quotes str
    str.gsub(/'/, "\\\\'")
  end

  def models
    Rails.application.eager_load!
    ActiveRecord::Base.send :descendants
  end

  desc "Dump all seed data"
  task :dump_all => [:environment] do
    puts "# encoding: UTF-8"
    models.each{|m| seed_table m}
  end

  desc "Drop, create, migrate and seed database"
  task :resetdb do

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