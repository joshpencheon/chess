# Chess

A noddy Ruby script for rendering a chessboard in a terminal. It may become an interactive chess game in future, no promises.

## Usage

To see the game from White's perspective:

```ruby
Chess::Position.starting.render
```

...or, from Black's:

```ruby
Chess::Position.starting.render(perspective: :black)
```
