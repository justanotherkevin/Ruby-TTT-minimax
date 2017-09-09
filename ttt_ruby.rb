require 'color_text'
require 'pry'

class Ttt_game
    attr_reader :cpu_symbo, :user_symbo, :active_turn, :game_over, :user_score, :cpu_score
    attr_accessor :board
    def initialize
        @cpu_symbo = ''
        @user_symbo = ''

        @board = nil
        @active_turn = nil
        @game_over = false
        # if your can restart then it make sense to add score tracking
        @user_score = 0
        @cpu_score = 0
        @choice = ''
    end

    def assign_player_symbo
        put_line
        puts "\n  TIC TAC TOE IN RUBY".red
        puts "\n Which player do you want to be? X or O? ".neon
        STDOUT.flush

        @user_symbo = gets.chomp.upcase
        # force user_symbo to be X or O
        assign_player_symbo until (@user_symbo == 'X') || (@user_symbo == 'O')
        # assign computer as remaining symbo
        @cpu_symbo = @user_symbo == 'X' ? 'O' : 'X'
        puts `clear`
        # X make the first move
    end

    def create_game
        # the tic tac toe slots; After one game, if chose to play again this will clear the board
        @board = {
            a1: ' ', a2: ' ', a3: ' ',
            b1: ' ', b2: ' ', b3: ' ',
            c1: ' ', c2: ' ', c3: ' '
        }
    end

    def user_turn
        @active_turn = 'user'
        draw_game

        puts " Please specify a move with the format 'A1' , 'B3' , 'C2' etc.\n or type 'exit' to quit".red
        STDOUT.flush
        input = gets.chomp.downcase.to_sym

        # force user input
        if
            (%w[a b c].include? input.to_s.split('')[0]) &&
            (%w[1 2 3].include? input.to_s.split('')[1]) &&
            (@board[input] == ' ') &&
            (input.length == 2)

            @board[input] = @user_symbo
            put_line
            puts "Player marks #{input.to_s.upcase.green}".neon
            check_game(@board, @user_symbo)
        else
            wrong_input unless input == :exit
        end
    end

    def cpu_turn
        @active_turn = 'cpu'
        availible_moves = @board.select { |_k, v| v == ' ' }
        # if availible_moves.length < 9
        #   minimax( @board, 0, @user_symbo)
        #   @board[@choice] = @cpu_symbo
        # else
        # end

        move = availible_moves.keys.sample
        @board[move] = @cpu_symbo

        put_line
        notification = " #{@cpu_name} marks #{move.to_s.upcase.green}\n"
        notification.each_char { |c| putc c; sleep 0.10; $stdout.flush }
        put_line
        check_game(@board, @cpu_symbo)
    end

    def draw_game
        puts `clear`
        puts " Scores   Computer:#{@cpu_score} Player:#{@user_score}\n\n".gray
        puts '      A   B   C'.red
        puts '    +---+---+---+'
        puts ' 1'.red + "  | #{@board[:a1].green} | #{@board[:b1].green} | #{@board[:c1].green} |"
        puts '     --- --- ---'
        puts ' 2'.red + "  | #{@board[:a2].green} | #{@board[:b2].green} | #{@board[:c2].green} |"
        puts '     --- --- ---'
        puts ' 3'.red + "  | #{@board[:a3].green} | #{@board[:b3].green} | #{@board[:c3].green} |"
        puts '    +---+---+---+'

        put_line
    end


    def score(board, depth)
        if win?(board, @cpu_symbo)
            10 - depth
        elsif win?(board, @user_symbo)
            depth - 10
        else
            0
        end
    end

    def no_more_move?(board)
        board.select { |_k, v| v == ' ' }.empty? ? true : false
    end

    def minimax(board, depth, player)
        # return score(board, depth) if no_more_move?(board)
        if win?(board, @cpu_symbo)
            return 10 - depth
        elsif win?(board, @user_symbo)
            return depth - 10
        elsif no_more_move?(board)
            return 0
        end
        depth += 1
        scores = [] # an array of scores
        moves = []  # an array of moves
        best_move = { 'position' => -999 }
        symbo = player == @user_symbo ? @cpu_symbo : @user_symbo
        available_moves = board.select { |_k, v| v == ' ' }.keys
        # Populate the scores array, recursing as needed
        # p "this is pre loop #{depth}/////////////////////"
        available_moves.each do |move|
            # play that move, make new board
            this_move = { move => symbo }
            possible_board = board.merge(this_move)
            # track the score from minimax when hit basecase
            scores << minimax(possible_board, depth, symbo)
            moves << move
            # if game_score > best_move.values[0]
            #   best_move = { move => game_score }
            # end
        end
        # Do the min or the max calculation
        # binding.pry
        # if @active_turn == "user"
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        puts 'i am here '
        scores[max_score_index]
      # else
      #     # This is the min calculation
      #     min_score_index = scores.each_with_index.min[1]
      #     @choice = moves[min_score_index]
      #     return scores[min_score_index]
      # end
    end

    def wrong_input
        put_line
        puts " Please specify a move with the format 'A1' , 'B3' , 'C2' etc.".red
        put_line
        user_turn
    end

    def wrong_move
        put_line
        puts ' You must choose an empty slot'.red
        put_line
        user_turn
    end

    def win?(board, symbo)
        # created nested array
        # ex.[["X", " ", " "], [" ", " ", " "], [" ", " ", " "]]
        board_in_array = board.values.each_slice(3).to_a
        diagnoal_count = [0, 0]
        size = board_in_array[0].length
        i = 0
        while i < size
            hor_count = 0
            ver_count = 0
            n = 0
            while n < size
                # check for horizontal & vertical win
                (hor_count += 1) if symbo == board_in_array[i][n]
                (ver_count += 1) if symbo == board_in_array[n][i]
                # check for diagnoal win
                if symbo == board_in_array[i][n]
                    (diagnoal_count[0] += 1) if i == n
                    (diagnoal_count[1] += 1) if i == size - 1 - n
                end

                return true if (hor_count == size)  ||
                    (ver_count == size)             ||
                    (diagnoal_count[0] == size)     ||
                    (diagnoal_count[1] == size)

                n += 1
            end
            i += 1
        end
        false
    end

    def check_game(board, symbo)
        if win?(board, symbo)
            winner = ''
            if symbo == @user_symbo
                @user_score += 1
                winner = 'Player'
            else
                @cpu_score += 1
                winner = 'Computer'
            end
            put_line
            draw_game
            put_line
            puts "\n Game Over -- #{winner} WINS!!!\n".blue
            @game_over = true
            ask_to_play_again
        end
        # if @game_over == false
        #     moves_remain = board.values.select { |v| v == ' ' }.length
        #     if moves_remain > 0
        #         # switch turn
        #         if symbo == @user_symbo
        #             cpu_turn
        #         else
        #             user_turn
        #         end
        #     else
        #         put_line
        #         draw_game
        #         puts "\n Game Over -- DRAW!\n".blue
        #         ask_to_play_again
        #     end
        # end
    end

    def ask_to_play_again
        print ' Play again? (Y/N): '
        STDOUT.flush
        user_goes_first = (rand > 0.5)
        response = gets.chomp.downcase
        case response
        when 'y', 'yes'  then restart_game(user_goes_first)
        when 'n', 'no'   then 'Have a good day'
        else ask_to_play_again(user_goes_first)
        end
    end

    def restart_game(user_goes_first)
        @game_over = false
        puts `clear`
        create_game(user_goes_first)
    end

    def put_line
        puts ('-' * 80).red
    end

    def put_bar
        puts ('#' * 80).red
    end
end
