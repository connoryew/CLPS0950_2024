% CLPS0950 Group Project: Blackjack (w/ Basic Strategy Recommendations)
% Group Members: Nicole Chen, Jilienne Widener, Connor Yew

% Start with shuffle deck
shuffle_card = randperm(52);

% Initialize player and dealer hands
player_raw_hand = shuffle_card(1:2:3); % dealer gives first and third card to player
dealer_raw_hand = shuffle_card(2:2:4); % dealer takes second and fourth for themselves

% Card values
card_value = zeros(1,52); %initialize our card values with 0
for card_number = 1:52
    posit_value = mod(card_number, 13); %posit or position value is the deck position, that we need to map to the game value
    if posit_value == 1 %because ace is 1, 1 mod 13 returns 1 --> its position in the modulo operation
        tmp_card_value = 11;
    elseif posit_value > 10 || posit_value == 0 %for jacks, queens, kings have posit value of 0 because matlab matrix starts at 1, meaning ace at 1, meaning king at 13, and 13 mod 13 = 0
        tmp_card_value = 10;
   
    else
        tmp_card_value = posit_value; %for 2-10, because their rank value within 1:52 corresponds to their actual value
    end
    card_value(card_number) = tmp_card_value;
end
player_hand = card_value(player_raw_hand) %turning the raw hand straight from the deck into values that have meaning in cards
player_total = sum(card_value(player_raw_hand)) %totalling the two cards player has
dealer_hand = card_value(dealer_raw_hand); %turning raw hand from deck into cards with meaning
dealer_first_card = card_value(dealer_hand(1)) %show only the first card of the dealer

if dealer_first_card == (2:6)
    if player_total == (13:17)
        disp('stand');
    elseif player_total == 12 && dealer_first_card == 2 || dealer_first_card == 3
        disp('hit');
    elseif player_total == 12 && dealer_first_card == 4 || dealer_first_card == 5 || dealer_first_card == 6
        disp('stand');
    end
elseif dealer_first_card == 7:11
    if player_total == 17
        disp('stand');
    elseif player_total == (12:16)
        disp('stand');
    end
end
       
%current place: player totals are falling outside ranges, code isn't
%continuing --> need to add more else/if conditions ideally in loops bc
%this is probably inefficient. for now, i've coded the hard totals from
%12-17 of player card and 2-A of dealer upcard (looking at the strat
%chart). Also need to make sure the code is displaying what it's supposed
%to