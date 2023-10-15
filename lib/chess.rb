# frozen_string_literal: true

module Chess
  class Game
    def initialize
      @positions = [Position.starting]
    end
  end

  class Position
    def self.starting
      new [
        Rook.new(:white,   'a', 1),
        Knight.new(:white, 'b', 1),
        Bishop.new(:white, 'c', 1),
        Queen.new(:white,  'd', 1),
        King.new(:white,   'e', 1),
        Bishop.new(:white, 'f', 1),
        Knight.new(:white, 'g', 1),
        Rook.new(:white,   'h', 1),
        Pawn.new(:white,   'a', 2),
        Pawn.new(:white,   'b', 2),
        Pawn.new(:white,   'c', 2),
        Pawn.new(:white,   'd', 2),
        Pawn.new(:white,   'e', 2),
        Pawn.new(:white,   'f', 2),
        Pawn.new(:white,   'g', 2),
        Pawn.new(:white,   'h', 2),
        Pawn.new(:black,   'a', 7),
        Pawn.new(:black,   'b', 7),
        Pawn.new(:black,   'c', 7),
        Pawn.new(:black,   'd', 7),
        Pawn.new(:black,   'e', 7),
        Pawn.new(:black,   'f', 7),
        Pawn.new(:black,   'g', 7),
        Pawn.new(:black,   'h', 7),
        Rook.new(:black,   'a', 8),
        Knight.new(:black, 'b', 8),
        Bishop.new(:black, 'c', 8),
        Queen.new(:black,  'd', 8),
        King.new(:black,   'e', 8),
        Bishop.new(:black, 'f', 8),
        Knight.new(:black, 'g', 8),
        Rook.new(:black,   'h', 8)
      ]
    end

    def initialize(pieces)
      @pieces = pieces
    end

    def at(file, rank)
      @pieces.detect { |piece| piece.at?(file, rank) }
    end

    def render(...)
      Renderer.new(self).render(...)
    end
  end

  class Renderer
    def initialize(position)
      @position = position
    end

    def render(perspective: :white)
      ranks = white_ranks.to_a
      files = white_files.to_a

      unless perspective == :white
        ranks.reverse!
        files.reverse!
      end

      puts ' ┌────────────────────────┐'
      ranks.reverse_each.with_index do |rank, rank_index|
        print "#{rank}│"

        files.each_with_index do |file, file_index|
          if (rank_index + file_index).odd?
            print "\e[48;2;100;82;59m"
          else
            print "\e[48;2;200;168;129m"
          end

          piece = @position.at(file, rank)

          if piece
            if piece.white?
              print "\e[97m"
            else
              print "\e[30m"
            end

            print " #{piece.icon} "
          else
            print '   '
          end

          print "\e[0m"
        end

        puts '│'
      end
      puts ' └────────────────────────┘'
      print '  '
      files.each { |file| print " #{file} " }
      puts
    end

    private

    def white_ranks
      1..8
    end

    def white_files
      'a'..'h'
    end
  end

  class Piece
    attr_reader :rank, :file

    def initialize(colour, file, rank)
      @white = colour == :white
      @file = file
      @rank = rank
    end

    def white?
      @white
    end

    def black?
      !white?
    end

    def at?(file, rank)
      self.file == file && self.rank == rank
    end

    def moves
      raise NoMethodError
    end

    def icon
      raise NoMethodError
    end
  end

  class Pawn < Piece
    def icon
      '♟︎'
    end
  end

  class Knight < Piece
    def icon
      '♞'
    end
  end

  class Bishop < Piece
    def icon
      '♝'
    end
  end

  class Rook < Piece
    def icon
      '♜'
    end
  end

  class Queen < Piece
    def icon
      '♛'
    end
  end

  class King < Piece
    def icon
      '♚'
    end
  end
end
