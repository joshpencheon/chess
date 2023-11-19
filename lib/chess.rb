# frozen_string_literal: true

require "stringio"

module Chess
  class Game
    attr_reader :positions

    def initialize
      @positions = [Position.starting]
    end

    def to_move
      current_position.to_move
    end

    def move
      piece = current_position.pieces.sample
      file = ('a'..'g').to_a.sample
      rank = (1..8).to_a.sample
      new_position = current_position.move(piece:, file:, rank:)
      @positions << new_position
      self
    end

    def render(...)
      current_position.render(...)
    end

    private

    def current_position
      positions.last
    end
  end

  class Position
    def self.starting
      new(to_move: :white, pieces: [
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
      ])
    end

    attr_reader :pieces

    def initialize(to_move:, pieces:)
      @to_move = to_move
      @pieces = pieces
    end

    def at(file:, rank:)
      pieces.detect { |piece| piece.at?(file:, rank:) }
    end

    def move(piece:, file:, rank:)
      other_pieces = (pieces - [piece]).map(&:dup)
      next_position = self.class.new(to_move: other_player, pieces: other_pieces)

      puts "moved from: #{piece}"
      captured_piece = next_position.at(file:, rank:)
      puts "captured: #{captured_piece}"
      next_position.capture(piece: captured_piece) if captured_piece

      moved_piece = piece.dup.move(file:, rank:)
      puts "moved to: #{moved_piece}"
      next_position.place(piece: moved_piece)

      next_position
    end

    def render(...)
      Renderer.new(self).render(...)
    end

    protected

    def capture(piece:)
      pieces.delete(piece)
    end

    def place(piece:)
      pieces << piece
    end

    private

    def other_player
      @to_move == :white ? :black : :white
    end
  end

  class Renderer
    def initialize(position)
      @position = position
    end

    def render(perspective: :white)
      ranks = white_ranks.to_a
      files = white_files.to_a

      canvas = StringIO.new

      unless perspective == :white
        ranks.reverse!
        files.reverse!
      end

      canvas.puts ' ┌────────────────────────┐'
      ranks.reverse_each.with_index do |rank, rank_index|
        canvas.print "#{rank}│"

        files.each_with_index do |file, file_index|
          if (rank_index + file_index).odd?
            canvas.print "\e[48;2;100;82;59m"
          else
            canvas.print "\e[48;2;200;168;129m"
          end

          piece = @position.at(file:, rank:)

          if piece
            if piece.white?
              canvas.print "\e[97m"
            else
              canvas.print "\e[30m"
            end

            canvas.print " #{piece.icon} "
          else
            canvas.print '   '
          end

          canvas.print "\e[0m"
        end

        canvas.puts '│'
      end
      canvas.puts ' └────────────────────────┘'
      canvas.print '  '
      files.each { |file| canvas.print " #{file} " }
      canvas.puts

      canvas.rewind
      puts canvas.read
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
      @has_moved = false
    end

    def white?
      @white
    end

    def black?
      !white?
    end

    def move(file:, rank:)
      @has_moved = true
      @file = file
      @rank = rank
      self
    end

    def has_moved?
      @has_moved
    end

    def at?(file:, rank:)
      self.file == file && self.rank == rank
    end

    def to_s
      "#{self.class.name} #{file}#{rank}"
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
