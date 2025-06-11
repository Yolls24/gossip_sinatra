require 'csv'

class Comment
  FILE_PATH = "./db/comments.csv"

  attr_reader :gossip_id, :content

  def initialize(gossip_id, content)
    @gossip_id = gossip_id
    @content = content
  end

  def save
    CSV.open(FILE_PATH, "ab") do |csv|
      csv << [gossip_id, content]
    end
  end

  def self.all(gossip_id)
    comments = []
    CSV.foreach(FILE_PATH) do |row|
      comments << Comment.new(row[0].to_i, row[1]) if row[0].to_i == gossip_id
    end
    comments
  end

  def self.delete_by_gossip_id(gossip_id)
    comments = CSV.read(FILE_PATH)
    comments.reject! { |row| row[0].to_i == gossip_id }

    CSV.open(FILE_PATH, "w") do |csv|
      comments.each { |line| csv << line }
    end
  end
end


  
