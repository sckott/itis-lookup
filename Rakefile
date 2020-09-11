require_relative 'itis'

desc "get itis database, create csv file"
task :all do
  begin
    Itis.all()
  rescue Exception => e
    raise e
  end
end

desc "get and unzip backbone"
task :fetch do
  begin
    Itis.fetch()
  rescue Exception => e
    raise e
  end
end

desc "make csv file"
task :make_table do
  begin
    Itis.make_table()
  rescue Exception => e
    raise e
  end
end
