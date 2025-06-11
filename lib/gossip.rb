require 'csv'
require_relative 'comment'  # à inclure si tu utilises la classe Comment pour supprimer les commentaires liés

class Gossip
  FILE_PATH = "./db/gossip.csv"

  attr_reader :id, :author, :content

  def initialize(id, author, content)
    @id = id.to_i
    @author = author
    @content = content
  end

  # Sauvegarde le potin dans le fichier CSV
  def save
    CSV.open(FILE_PATH, "ab") do |csv|
      csv << [id, author, content]
    end
  end

  # Récupère tous les potins sous forme d'objets Gossip
  def self.all
    return [] unless File.exist?(FILE_PATH)

    all_gossips = []
    CSV.foreach(FILE_PATH) do |row|
      all_gossips << Gossip.new(row[0], row[1], row[2])
    end
    all_gossips
  end

  # Trouve un potin par son ID
  def self.find(id)
    all.find { |gossip| gossip.id == id.to_i }
  end

  # Génère le prochain ID disponible
  def self.next_id
    return 1 unless File.exist?(FILE_PATH)

    gossips = CSV.read(FILE_PATH)
    return 1 if gossips.empty?

    ids = gossips.map { |row| row[0].to_i }
    ids.max + 1
  end

  # Met à jour un potin existant
  def self.update(id, new_author, new_content)
    gossips = CSV.read(FILE_PATH)
    gossip_index = gossips.index { |row| row[0].to_i == id.to_i }
    return false unless gossip_index

    gossips[gossip_index] = [id, new_author, new_content]

    CSV.open(FILE_PATH, "w") do |csv|
      gossips.each { |line| csv << line }
    end
    true
  end

  # Supprime un potin et ses commentaires associés
  def self.delete(id)
    Comment.delete_by_gossip_id(id) if defined?(Comment)

    gossips = CSV.read(FILE_PATH)
    gossips.reject! { |row| row[0].to_i == id.to_i }

    CSV.open(FILE_PATH, "w") do |csv|
      gossips.each { |line| csv << line }
    end
    true
  end
end











  