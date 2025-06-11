require 'csv'

class Comment
  FILE_PATH = "./db/comments.csv"

  attr_reader :gossip_id, :content

  def initialize(gossip_id, content)
    @gossip_id = gossip_id.to_i
    @content = content.strip
  end

  def save
    return if content.empty?

    CSV.open(FILE_PATH, "ab") do |csv|
      csv << [gossip_id, content]
    end
  end

  def self.all(gossip_id)
    return [] unless File.exist?(FILE_PATH)

    comments = []
    CSV.foreach(FILE_PATH) do |row|
      if row[0].to_i == gossip_id.to_i
        comments << Comment.new(row[0], row[1])
      end
    end
    comments
  end

  def self.delete_by_gossip_id(gossip_id)
    return unless File.exist?(FILE_PATH)

    updated_comments = CSV.read(FILE_PATH).reject do |row|
      row[0].to_i == gossip_id.to_i
    end

    CSV.open(FILE_PATH, "w") do |csv|
      updated_comments.each { |line| csv << line }
    end
  end
end



  
