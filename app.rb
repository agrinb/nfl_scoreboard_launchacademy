require 'sinatra'
require "shotgun"
require 'pry'


games = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

######################## DATA ##########################
# #Create record hash {
# { "Patriots" => { "wins" => 0, "losses" =>  0 },
# }

# Populate the wins loss hash with all data
# If home_score is > than away score
# add one to home team wins and add one to away team loss
# else
# add one to away team wins and one to home team loss

#Instantiate record hash
record = {}

def create_record(games, record)
  games.each do |game|
  # add home and away team are in the record hash
    unless record.keys.include?(game[:home_team])
      wins_foo = { :wins => 0, :losses => 0 }
      record.merge!(game[:home_team] => wins_foo )
    end
    unless record.keys.include?(game[:away_team])
      wins_foo = { :wins => 0, :losses => 0 }
      record.merge!(game[:away_team] => wins_foo )
    end
  end
record
end

#create_record(games, record)


def fill_record(games, record)
# populate record hash with wins and looses
  games.each do |game|
  # if home team won
    if game[:home_score] > game[:away_score]
      record.each do |team, record|
  # add one to home wins and add one to away losses
        if team == game[:home_team]
          record[:wins] += 1
        elsif team == game[:away_team]
          record[:losses] += 1
        end
      end
  # if home team lost
    else
      record.each do |team, record|
        if team == game[:home_team]
            record[:losses] += 1
        elsif team == game[:away_team]
            record[:wins] += 1
        end
      end
    end
  end
 record
end

@record = {}

def complete_record(games, record)
  create_record(games, record)
  fill_record(games, record)
  @record = record
end



##################### LEADERBOARD #########################

# Sort the record hash with the team with most winsat the top
# if there is a tie the team with the fewer losses goes on top

# record2 = record.sort_by { |team, team_record| -team_record[:wins]}
# puts record2.sort_by { |team, team_record| team_record[:losses]}





###################### TEAMS PAGE ########################



@team_record = nil
@team_games = nil

# def find_games(team, games)
#   team_games = []
#   games.each do |game|
#     if game[:home_team] == team || game[:away_team] == team
#       team_games << game
#     end
#   end
#   team_games
#   binding.pry
# end

def find_games(param_team, games)
  team_games = []
    games.each do |game|
      if game[:home_team] == param_team || game[:away_team] == param_team
        team_games << game
      end
    end
  team_games
end



def find_record(team, record)
  record.each do |db_team, team_record|
    @team_record = team_record if team == db_team
  end
   @team_record
end



get '/teams/:team' do
  @team = params[:team]
  @team_record = find_record(params[:team], complete_record(games, record))
  @team_games = find_games(params[:team], games)
  erb :show
end

get '/' do
  get_record = complete_record(games, record)
  @show_record = get_record.sort_by { |team, team_record| [-team_record[:wins], team_record[:losses]] }
  erb :index
end



# Get the team name from params hash
# List the wins and losses for the team
# List all games where the team is either home or away team from games array



