require 'csv'

class Gossip
  FILE_PATH = "./db/gossip.csv"

  attr_reader :id, :author, :content

  def initialize(id, author, content)
    @id = id
    @author = author
    @content = content
  end

  def save
    CSV.open(FILE_PATH, "ab") do |csv|
      csv << [id, author, content]
    end
  end

  def self.all
    all_gossips = []
    CSV.foreach(FILE_PATH) do |row|
      all_gossips << Gossip.new(row[0].to_i, row[1], row[2])
    end
    all_gossips
  end

  def self.find(id)
    all.find { |gossip| gossip.id == id }
  end

  def self.next_id
    CSV.read(FILE_PATH).size + 1
  end

  def self.update(id, new_author, new_content)
    gossips = CSV.read(FILE_PATH)
    gossip_index = gossips.index { |row| row[0].to_i == id }
    return false unless gossip_index

    gossips[gossip_index] = [id, new_author, new_content]

    CSV.open(FILE_PATH, "w") do |csv|
      gossips.each { |line| csv << line }
    end
    true
  end

  def self.delete(id)
    # Supprimer les commentaires associés au potin
    Comment.delete_by_gossip_id(id)

    # Supprimer le potin
    gossips = CSV.read(FILE_PATH)
    gossips.reject! { |row| row[0].to_i == id }

    CSV.open(FILE_PATH, "w") do |csv|
      gossips.each { |line| csv << line }
    end
    true
  end
end










  