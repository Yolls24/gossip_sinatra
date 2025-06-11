require 'sinatra'
require 'sinatra/reloader' if development?
require 'csv'
require_relative 'gossip'
require_relative 'comment'

set :views, File.expand_path('../views', __FILE__)

# Route d'accueil : liste tous les potins
get '/' do
  erb :index, locals: { gossips: Gossip.all }
end

# Formulaire pour créer un nouveau potin
get '/gossips/new' do
  erb :new_gossip
end

# Action qui sauvegarde un nouveau potin en CSV
post '/gossips/new' do
  Gossip.new(params[:gossip_author], params[:gossip_content]).save
  redirect '/'
end

# Page "show" : affiche un potin selon son ID + ses commentaires
get '/gossips/:id' do
  begin
    id = params[:id].to_i
    gossip = Gossip.find(id)
    if gossip
      comments = Comment.all(id)
      erb :show, locals: { gossip: gossip, id: id, comments: comments }
    else
      status 404
      "Potin non trouvé"
    end
  rescue => e
    status 500
    "Erreur serveur : #{e.message}"
  end
end

# Page "edit" : formulaire d'édition d’un potin
get '/gossips/:id/edit' do
  begin
    id = params[:id].to_i
    gossip = Gossip.find(id)
    if gossip
      erb :edit_gossip, locals: { gossip: gossip, id: id }
    else
      status 404
      "Potin non trouvé pour édition"
    end
  rescue => e
    status 500
    "Erreur serveur : #{e.message}"
  end
end

# Action de mise à jour du potin (update)
post '/gossips/:id/edit' do
  id = params[:id].to_i
  Gossip.update(id, params[:gossip_author], params[:gossip_content])
  redirect "/gossips/#{id}"
end

# Suppression d'un potin
post '/gossips/:id/delete' do
  id = params[:id].to_i
  Gossip.delete(id)
  redirect '/'
end

# Ajout d'un commentaire à un potin
post '/gossips/:id/comments' do
  id = params[:id].to_i
  content = params[:comment_content]
  comment = Comment.new(id, content)
  comment.save
  redirect "/gossips/#{id}"
end











