require_relative './ttt_ruby.rb'
# start game
game = Ttt_game.new
# ask user to choose symbol
game.assign_player_symbo
# create blank game board
game.create_game

game.user_symbo == "X" ? game.user_turn : game.cpu_turn

until game.game_over == true do
    moves_remain = game.board.values.select { |v| v == ' ' }.length
    if moves_remain > 0
        if game.active_turn == 'user'
            game.cpu_turn
        else
            game.user_turn
        end
    else
        game.put_line
        game.draw_game
        puts "\n Game Over -- DRAW!\n".blue
        game.ask_to_play_again
    end
end
