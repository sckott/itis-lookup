require 'faraday'
require 'sqlite3'
require 'date'
require 'zip'
require 'csv'

$itis_zip = 'https://itis.gov/downloads/itisSqlite.zip'

module Itis
	def self.fetch
		puts 'fetching/unzipping backbone from ITIS servers'
		fetch_zip
		unzip
	end

	def self.make_table
		puts 'creating csv table'
		make_lookup_table
	end

	def self.all
		if is_zip_file_new?
			puts 'new ITIS database, updating'
			fetch_zip
			unzip
			make_lookup_table
		else
			puts 'ITIS database is old, not updating'
		end
	end
end

def is_zip_file_new?
	# initialize Faraday connection object
	conn = Faraday.new do |x|
	  x.adapter Faraday.default_adapter
	end

	# check last-modified header
	res = conn.head $itis_zip;
	lm = DateTime.parse(res.headers['date']).to_time

	# file last modified
	begin
		fm = File.stat("itisSqlite.zip").mtime
	rescue Exception => e
		fm = nil
	end

	if fm.nil?
		return true
	end

	# return boolean
	return lm > fm
end

def fetch_zip
	if !File.exist?('itisSqlite.zip')
		# initialize Faraday connection object
		conn = Faraday.new do |x|
		  x.adapter Faraday.default_adapter
		end

		# get zip file
		res = conn.get $itis_zip;

		# write zip file to disk
		File.open('itisSqlite.zip', 'wb') { |fp| fp.write(res.body) }
	else
		puts "'itisSqlite.zip' found, skipping download"
	end
end

def unzip
	Zip::File.open('itisSqlite.zip') do |zip_file|
	  zip_file.glob("*/ITIS.sqlite") do |f|
			begin
				zip_file.extract(f, f.name.split('/').last) unless File.exist?(f.name)
			end
	  end
	end
end

def make_lookup_table
	db = SQLite3::Database.open "ITIS.sqlite"
	xx = db.prepare "SELECT tu.tsn,tut.rank_name FROM taxonomic_units tu JOIN (SELECT DISTINCT rank_id,rank_name FROM taxon_unit_types) tut ON tu.rank_id = tut.rank_id"
	xx_res = xx.execute!;
	xx_res.map { |e| e[1].downcase! };
	
	CSV.open("data/itis_lookup.csv", "w") do |csv|
		csv << ["tsn","rank_name"]
	  xx_res.each do |m|
	  	csv << m
	  end
	end
end

def disconnect_from_db
end

# def clean_up
# 	files_to_clean = ["Taxon.tsv", "itisSqlite.zip", "gbif.sqlite", "gbif.zip"]
# 	files_to_clean.each { |x| File.unlink(x) unless !File.exists?(x) }
# end
