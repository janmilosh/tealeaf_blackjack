# encoding: utf-8
require "pry"
system "clear"

def create_deck
  deck = []
  suites = ["\u2660", "\u2663", "\u2665", "\u2666"]
  card_ranks = %w(A K Q J 10 9 8 7 6 5 4 3 2)
  card_values = [11, 10, 10, 10, 10, 9, 8, 7, 6, 5, 4, 3, 2]
  4.times do # to create 4 decks
    4.times do |j| # to create the 4 suites
      13.times do |k| # to create the 13 values/ranks
        deck.push([card_values[k], card_ranks[k], suites[j]])
      end
    end
  end
  deck.shuffle
end

def get_player_name
  puts "\nPlease enter your name:"
  print "=> "
  gets.chomp
end

def keep_playing
  puts "Keep playing? (Y/N)"
  print "=> "
  gets.chomp.downcase
end

def hit(hand, deck)
  hand.push(deck.slice!(0))
end

def hit_or_stay(hand, deck)
  puts "hit(H) or stay(S)?"
  print "=> "
  hit_or_stay = gets.chomp.downcase
  if hit_or_stay == 'h'
    hit(hand, deck)
  end
  hit_or_stay
end

def deal_first_two_cards(hands, deck)
  2.times do |i|
    2.times do |j|
      hands[i][j] = deck.slice!(1)
    end
  end
  hands
end

def check_for_ace(hand)
  ace = false
  hand.each do |card|
    if card[0] == 11
      card[0] = 1
      ace = true
      break
    end
  end
  ace
end

def calculate_total(hand)
  total = 0
  hand.each do |card|
    total += card[0]
  end
  total
end

def total_for_hand(hand)
  total = calculate_total(hand)
  if total > 21
    ace = check_for_ace(hand)
    if ace
      total = calculate_total(hand)
    end
  end
  total
end

def declare_winner(totals_array, player_name, total_wins)
  if totals_array[0] > 21
    total_wins[1] += 1
    message = "#{player_name} busts, Dealer wins!!!"
  elsif totals_array[1] > 21
    total_wins[0] += 1
    message =  "Dealer busts, #{player_name} wins!!!"
  elsif totals_array[0] > totals_array[1]
    message = "#{player_name} wins!!!"
    total_wins[0] += 1
  elsif totals_array[1] > totals_array[0]
    message = "Dealer wins!!!"
    total_wins[1] += 1
  else
    message = "It's a tie!!!"
  end

  puts message
  puts "\nTotal wins: #{player_name} => #{total_wins[0]}  Dealer => #{total_wins[1]}"
  
end

def display_player_hand(hand, player_name) #displays and returns total
  print "\n#{player_name}: "
  hand.each do |card|
    print "#{card[1]}#{card[2]}  "    
  end
  total = total_for_hand(hand)
  print "total: #{total}"
  total
end

def display_dealer_hand(hand, hole_card_hidden) #displays and returns total
  print "\nDealer: "
  hand.each_with_index do |card, index|
    if !hole_card_hidden || index == 0 
      print "#{card[1]}#{card[2]}  "
    else
      print "??"
    end    
  end
  total = total_for_hand(hand)
  if !hole_card_hidden
    print "total: #{total}"
  end
  total
end

def display_hands(hands, player_name, hole_card_hidden)
  system "clear"
  totals_array = []
  totals_array[1] = display_dealer_hand(hands[1], hole_card_hidden)  
  puts
  totals_array[0] = display_player_hand(hands[0], player_name)
  puts "\n\n"
  totals_array
end

deck = []
total_wins = [0, 0]
player_name = get_player_name

begin
  if deck.length <= 52 # minimum deck size before getting a new deck
    deck = create_deck
  end
  
  hands = deal_first_two_cards([[], []], deck)
  totals_array = display_hands(hands, player_name, true)

  begin # player's turn
    hit_or_stay = hit_or_stay(hands[0], deck)
    totals_array = display_hands(hands, player_name, true)
  end while hit_or_stay == 'h' && totals_array[0] <= 21  

  if totals_array[0] <= 21
    while totals_array[1] < 17 # dealer's turn
      hit(hands[1], deck)
      totals_array = display_hands(hands, player_name, false)
    end
  end

  totals_array = display_hands(hands, player_name, false)
  declare_winner(totals_array, player_name, total_wins)
  puts
end while keep_playing == 'y'
