require 'csv'

class Gossip
  FILE_PATH = "./db/gossip.csv"

  attr_accessor :author, :content

  def initialize(author, content)
    @author = author
    @content = content
  end

  def save
    CSV.open(FILE_PATH, "ab") do |csv|
      csv << [author, content]
    end
  end

  def self.all
    all_gossips = []
    CSV.foreach(FILE_PATH) do |row|
      all_gossips << Gossip.new(row[0], row[1])
    end
    all_gossips
  end

  def self.find(id)
    all_gossips = self.all
    return nil if id < 0 || id >= all_gossips.size
    all_gossips[id]
  end

  def self.update(id, new_author, new_content)
    gossips = CSV.read(FILE_PATH)
    return false if id < 0 || id >= gossips.size

    gossips[id] = [new_author, new_content]

    CSV.open(FILE_PATH, "w") do |csv|
      gossips.each { |line| csv << line }
    end
    true
  end

  def self.delete(id)
    gossips = CSV.read(FILE_PATH)
    return false if id < 0 || id >= gossips.size

    gossips.delete_at(id)

    CSV.open(FILE_PATH, "w") do |csv|
      gossips.each { |line| csv << line }
    end
    true
  end
end









  