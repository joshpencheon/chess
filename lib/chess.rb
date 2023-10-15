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
        Rook.new(:white,   1, 'a'),
        Knight.new(:white, 1, 'b'),
        Bishop.new(:white, 1, 'c'),
        Queen.new(:white,  1, 'd'),
        King.new(:white,   1, 'e'),
        Bishop.new(:white, 1, 'f'),
        Knight.new(:white, 1, 'g'),
        Rook.new(:white,   1, 'h'),
        Pawn.new(:white,   2, 'a'),
        Pawn.new(:white,   2, 'b'),
        Pawn.new(:white,   2, 'c'),
        Pawn.new(:white,   2, 'd'),
        Pawn.new(:white,   2, 'e'),
        Pawn.new(:white,   2, 'f'),
        Pawn.new(:white,   2, 'g'),
        Pawn.new(:white,   2, 'h'),
        Pawn.new(:black,   7, 'a'),
        Pawn.new(:black,   7, 'b'),
        Pawn.new(:black,   7, 'c'),
        Pawn.new(:black,   7, 'd'),
        Pawn.new(:black,   7, 'e'),
        Pawn.new(:black,   7, 'f'),
        Pawn.new(:black,   7, 'g'),
        Pawn.new(:black,   7, 'h'),
        Rook.new(:black,   8, 'a'),
        Knight.new(:black, 8, 'b'),
        Bishop.new(:black, 8, 'c'),
        Queen.new(:black,  8, 'd'),
        King.new(:black,   8, 'e'),
        Bishop.new(:black, 8, 'f'),
        Knight.new(:black, 8, 'g'),
        Rook.new(:black,   8, 'h')
      ]
    end

    def initialize(pieces)
      @pieces = pieces
    end

    def at(rank, file)
      @pieces.detect { |piece| piece.at?(rank, file) }
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

          piece = @position.at(rank, file)

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

    def initialize(colour, rank, file)
      @white = colour == :white
      @rank = rank
      @file = file
    end

    def white?
      @white
    end

    def black?
      !white?
    end

    def at?(rank, file)
      self.rank == rank && self.file == file
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
