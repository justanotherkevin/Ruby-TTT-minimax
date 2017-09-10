require_relative './ttt_ruby.rb'
require 'pry'
# require 'spec_helper'

describe Ttt_game do
    before :each do
        @game = Ttt_game.new
    end

    describe "initialize GAME" do
        it "assign cpu symbol as blank" do
            expect(@game.cpu_symbo).to eq ''
        end
        it "assign user symbol as blank" do
            expect(@game.user_symbo).to eq ''
        end
        it "assign borad as nil" do
            expect(@game.board).to eq nil
        end
        it "assign active turn as nil" do
            expect(@game.active_turn).to eq nil
        end
        it "assign game over as 0 " do
            expect(@game.game_over).to eq false
        end
        it "assign user score as 0 " do
            expect(@game.user_score).to eq(0)
        end
        it "assign cpu score as 0 " do
            expect(@game.cpu_score).to eq(0)
        end
    end

    describe "winning conditions with horizontal " do
        it "has winning first row" do
            @game.board = {
                a1: 'x', a2: 'x', a3: 'x',
                b1: ' ', b2: ' ', b3: ' ',
                c1: ' ', c2: ' ', c3: ' '
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
        it "has winning second row" do
            @game.board = {
                a1: ' ', a2: ' ', a3: ' ',
                b1: 'x', b2: 'x', b3: 'x',
                c1: ' ', c2: ' ', c3: ' '
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
        it "has winning thrid row" do
            @game.board = {
                a1: ' ', a2: ' ', a3: ' ',
                b1: ' ', b2: ' ', b3: ' ',
                c1: 'x', c2: 'x', c3: 'x'
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
    end

    describe "winning conditions with vertical " do
        it "has winning first column" do
            @game.board = {
                a1: 'x', a2: ' ', a3: ' ',
                b1: 'x', b2: ' ', b3: ' ',
                c1: 'x', c2: ' ', c3: ' '
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
        it "has winning second column" do
            @game.board = {
                a1: ' ', a2: 'x', a3: ' ',
                b1: ' ', b2: 'x', b3: ' ',
                c1: ' ', c2: 'x', c3: ' '
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
        it "has winning third column" do
            @game.board = {
                a1: ' ', a2: ' ', a3: 'x',
                b1: ' ', b2: ' ', b3: 'x',
                c1: ' ', c2: ' ', c3: 'x'
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
    end

    describe "winning conditions with diagnoal " do
        it "has winning first diagnoal" do
            @game.board = {
                a1: 'x', a2: ' ', a3: ' ',
                b1: ' ', b2: 'x', b3: ' ',
                c1: ' ', c2: ' ', c3: 'x'
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end
        it "has winning second diagnoal" do
            @game.board = {
                a1: ' ', a2: ' ', a3: 'x',
                b1: ' ', b2: 'x', b3: ' ',
                c1: 'x', c2: '', c3: ' '
            }
            expect(@game.win?(@game.board, 'x')).to eq true
        end

    end

    describe "Testing for full board" do
        it "return true if there are no more moves to make" do
            @game.board = {
                a1: 'x', a2: 'o', a3: 'o',
                b1: 'o', b2: 'x', b3: 'o',
                c1: 'o', c2: 'o', c3: 'x'
            }
            expect(@game.no_more_move?( @game.board )).to eq true
        end
        it "return false if there are more moves to make" do
            @game.board = {
                a1: 'x', a2: 'o', a3: ' ',
                b1: 'o', b2: ' ', b3: 'o',
                c1: 'o', c2: 'o', c3: 'x'
            }
            expect(@game.no_more_move?( @game.board )).to eq false
        end
    end

end
