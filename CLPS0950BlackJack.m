% CLPS0950 Group Project: Blackjack (w/ Basic Strategy Recommendations)
% Group Members: Nicole Chen, Jilienne Widener, Connor Yew
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETTING UP THE GAME
shuffle_card = randperm(52); % "Shuffles" the deck by creating a 1x52 vector of random permutations of integers 1-52
player_raw_hand = shuffle_card(1:2:3); % Deals the 1st and 3rd values from the vector shuffle_card to the player
dealer_raw_hand = shuffle_card(2:2:4); % Deals the 2nd and 4th values from the vector shuffle card to the dealer
card_value = zeros(1,52); % Initializes a 1x52 vector of zeroes for the values of the cards
card_display_value = cell(1,52); % Initializes the display value of the cards 

for card_number = 1:52
    posit_value = mod(card_number, 13); % Uses the modulo operation to find the position value in the deck, which we'll map to the game value
    if posit_value == 1 % We're using the modulo operator to find the first card of each 13-card "suit", so the cards in positions 1, 14, 27, etc. are defined as Aces and set to value 11
        card_value(card_number) = 11; % Ace value 
        card_display_value{card_number} = 'A'; % Display 'A' for Ace
    elseif posit_value > 10 || posit_value == 0 % Uses the modulo operation to pick out the J, Q, and K positions for each suit and sets them to value 10
        card_value(card_number) = 10;
        card_display_value{card_number} = '10'; 
    else
        card_value(card_number) = posit_value; % Number cards
        card_display_value{card_number} = num2str(posit_value);
    end
end

% Map raw hands to display hands for player and dealer
player_display_hand = card_display_value(player_raw_hand); 
dealer_display_hand = card_display_value(dealer_raw_hand); 

% Adjust for aces and update display hands for player and dealer 
[player_total, player_hand, player_display_hand] = adjust_aces(player_raw_hand, card_value, player_display_hand);
[dealer_total, dealer_hand, dealer_display_hand] = adjust_aces(dealer_raw_hand, card_value, dealer_display_hand);

% Correctly set the dealer's first card for display
dealer_first_card_display = dealer_display_hand{1};  % Use the display value directly

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TESTING/DEBUGGING w/ Set Initial Values
 %dealer_first_card = [];
 %player_total = [];
 %player_hand = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAYING INITIAL GAME VALUES: Player Hand, Player Total, and Dealer Up-Card
disp(['Your Initial Cards: ', strjoin(player_display_hand, ', ')]);
disp(['Your Total: ', num2str(player_total)]);
disp(['Dealer''s Up-Card: ', dealer_first_card_display]);

% Check if the player's initial hand is soft or hard and call the appropriate strategy function
is_soft_hand = any(player_hand == 11) && player_total <= 21; 
if is_soft_hand
    % Call the soft hand strategy function 
    basic_strat_recommendation = soft_basic_strategy(dealer_first_card,player_total);
else
    % Call the hard hand strategy function
    basic_strat_recommendation = basic_strategy(dealer_first_card, player_total);
end 
disp (['We recommend that you: ', basic_strat_recommendation]);
% We might want to eventually add some lines here that use imagesc and subplot to create a figure for the game table that we can update with each hit
% We would also need to  upload the 52 images for the face of each possible card in the deck + an image of the back of a card for the dealer's down-card

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HIT/STAND/DOUBLE LOGIC:
shuffle_card = shuffle_card(5:end); % Since the first four cards are already dealt, we can remove them by starting from the fifth card

% At the start of the player's turn, check for Blackjack
if player_total == 21 && numel(player_hand) == 2 %if their first two cards = blacjack
    disp('Blackjack! Player wins!');
    proceed_to_dealer = true;  % Set a flag to proceed directly to the dealer's turn
else
    proceed_to_dealer = false;  % Continue with the player's turn normally
end

% Round two
% Player's decision pathways
while~proceed_to_dealer
    user_input = input('Do you want to HIT (h), DOUBLE (d), or STAND (s)? ', 's'); % Asking for player input to determine if they want to hit, double down, or stand
        if user_input == 'h' || user_input == 'd' % Player chooses to HIT or DOUBLE DOWN
        % Draw a card (applicable to both HIT and DOUBLE DOWN)
        next_card_index = shuffle_card(1);
        player_raw_hand(end+1) = next_card_index; % Add the card to the player's raw hand
        player_display_hand{end+1} = card_display_value{next_card_index}; % Add the card to the player's display hand
        shuffle_card(1) = []; % Remove the drawn card from the deck

        % Adjust aces in player's hand if necessary and update total
        [player_total, player_hand, player_display_hand] = adjust_aces(player_raw_hand, card_value, player_display_hand);

        % Display updated player cards and total using display values
        disp(['Your Current Cards: ', strjoin(player_display_hand, ', ')]);
        disp(['Your Total: ', num2str(player_total)]);

        % After HIT, check for player's action continuation or bust
        if user_input == 'h'
            % Check if the player has busted with their new total
            if player_total > 21
                disp('Bust! You lose :(');
                proceed_to_dealer = true;  % End the player's turn
                break; % Exit the loop if busted
            else
                % Display strategy recommendation based on updated total
                is_soft_hand = any(player_hand == 11) && player_total <= 21;
                if is_soft_hand
                    % Call the soft hand strategy function
                    basic_strat_recommendation = soft_basic_strategy(dealer_first_card, player_total);
                else
                    % Call the hard hand strategy function
                    basic_strat_recommendation = basic_strategy(dealer_first_card, player_total);
                end
                disp(['Strategy Recommendation: ', basic_strat_recommendation]);
            end
        elseif user_input == 'd' % Player chooses to DOUBLE DOWN
            % Double down logic already covered above. If player_total > 21, it's handled.
            proceed_to_dealer = true; % Whether bust or not, player's turn ends after double down.
        end

    elseif user_input == 's' % Player chooses to STAND
        proceed_to_dealer = true; % Proceed to dealer's turn
        break; % Exit the loop

    else % Invalid input handling
        disp('Invalid input. Please choose "h" to HIT, "d" to DOUBLE, or "s" to STAND.');
    end
end

     % Show current state if game continues with the player
     if ~proceed_to_dealer
     disp(['Your cards: ', strjoin(player_display_hand, ', '), ' (Total: ', num2str(player_total), ')']);
     disp(['Dealer''s up-card: ', dealer_first_card_display]); % Ensure this uses a display-friendly version too
     end


if proceed_to_dealer % start giant proceed to dealer loop
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DEALER SHOWDOWN (Performed once the player has stood or finished doubling down)
if (player_total <= 21)
    disp(['Dealer''s Down-Card: ', dealer_display_hand{2}]); % Show dealer's second card using display hand
    % Recalculate dealer's total considering the possibility of Ace adjustments not yet applied
    [dealer_total, dealer_hand, dealer_display_hand] = adjust_aces(dealer_raw_hand, card_value, dealer_display_hand);
    disp(['Dealer''s Total: ', num2str(dealer_total)]); % Display recalculated total

    while dealer_total <= 16
        disp('Dealer Hits!');
        next_card_index = shuffle_card(1); % Draw the next card
        dealer_raw_hand(end+1) = next_card_index; % Add it to the dealer's raw hand
        dealer_display_hand{end+1} = card_display_value{next_card_index}; % Add to the dealer's display hand
        shuffle_card(1) = []; % Remove the drawn card from the deck
        
        [dealer_total, dealer_hand, dealer_display_hand] = adjust_aces(dealer_raw_hand, card_value, dealer_display_hand); % Adjust for Aces

        if dealer_total > 21
            disp(['Dealer''s Total: ', num2str(dealer_total)]);
            disp('Dealer Busts. You win!');
            break; % Dealer busts, end loop
        end
        disp(['Dealer''s Hand: ', strjoin(dealer_display_hand, ', ')]); % Show dealer's hand using display values
        disp(['Dealer''s Total: ', num2str(dealer_total)]);
    end

    if dealer_total >= 17 && dealer_total <= 21
        disp('Dealer Stands');
    end

    % Calculate the game outcome
    if player_total > dealer_total
        disp(['You have ', num2str(player_total), ', and the dealer has ', num2str(dealer_total), '. You win!']);
    elseif player_total < dealer_total
        disp(['You have ', num2str(player_total), ', and the dealer has ', num2str(dealer_total), '. You lose :(']);
    else % player_total == dealer_total
        disp(['You have ', num2str(player_total), ', and the dealer has ', num2str(dealer_total), '. It''s a push.']);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HARD TOTALS BASIC STRATEGY FUNCTION:
function [basic_strat_recommendation] = basic_strategy(dealer_first_card,player_total)

basic_strat_recommendation = ' ';

if dealer_first_card >= 2 && dealer_first_card <=6
    if player_total >= 17
        basic_strat_recommendation = 'STAND';
    elseif player_total >= 13 && player_total <=17
        basic_strat_recommendation = 'STAND';
    elseif player_total == 12 && (dealer_first_card == 2 || dealer_first_card == 3)
        basic_strat_recommendation = 'HIT';
    elseif (player_total == 12) && (dealer_first_card == 4 || dealer_first_card == 5 || dealer_first_card == 6)
        basic_strat_recommendation = 'STAND';
    end
elseif (dealer_first_card >= 7) && (dealer_first_card <= 11)
    if player_total >= 17
        basic_strat_recommendation = 'STAND';
    elseif player_total >= 12 && player_total <=16
        basic_strat_recommendation = 'HIT';
    end
end

if player_total == 11 % There's some missing scenarios here, but I'll find and fix those during class tomorrow.
    if dealer_first_card >= 2 && dealer_first_card <= 10
        basic_strat_recommendation = 'DOUBLE';
    elseif dealer_first_card == 1 
        basic_strat_recommendation = 'DOUBLE';
    end 
elseif player_total == 10 
    if dealer_first_card == 10 || dealer_first_card == 1 
        basic_strat_recommendation = 'HIT';
    elseif dealer_first_card >= 2 && dealer_first_card <= 9
        basic_strat_recommendation = 'DOUBLE';
    end
elseif player_total == 9 
    if dealer_first_card >= 3 && dealer_first_card <= 6
        basic_strat_recommendation = 'DOUBLE';
    else
        basic_strat_recommendation = 'HIT';
    end
elseif player_total <= 8 
    basic_strat_recommendation = 'HIT';
end

% Still need to code for hard totals < 8! I imagine it'll be all hits, but
% I'll double check that and add it in. 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SOFT TOTALS BASIC STRATEGY FUNCTION:
function [soft_strat_recommendation] = soft_basic_strategy(dealer_first_card,player_soft_total)
    soft_strat_recommendation = '';
    if (player_soft_total == 20)
        soft_strat_recommendation = 'STAND'; 
    elseif (player_soft_total == 19)
        if (dealer_first_card == 6)
            soft_strat_recommendation = 'DOUBLE'; 
        else 
            soft_strat_recommendation = 'STAND';
        end 

    elseif (player_soft_total == 18)
        if (dealer_first_card >= 9)
            soft_strat_recommendation = 'HIT';
        elseif (dealer_first_card == 2 || dealer_first_card == 7 || dealer_first_card == 8)
            soft_strat_recommendation = 'STAND';
        else
            soft_strat_recommendation = 'DOUBLE';
        end
    elseif (player_soft_total == 17)  
        if (dealer_first_card >= 3 && dealer_first_card <= 6)
            soft_strat_recommendation = 'DOUBLE';
        else
            soft_strat_recommendation = 'HIT';
        end
        
    elseif (player_soft_total == 16)  
        if (dealer_first_card >= 4 && dealer_first_card <= 6)
            soft_strat_recommendation = 'DOUBLE';
        else
            soft_strat_recommendation = 'HIT';
        end
        
    elseif (player_soft_total == 15) 
        if (dealer_first_card >= 4 && dealer_first_card <= 6)
            soft_strat_recommendation = 'DOUBLE';
        else
            soft_strat_recommendation = 'HIT';
        end
        
    elseif (player_soft_total == 14)  
        if (dealer_first_card >= 5 && dealer_first_card <= 6)
            soft_strat_recommendation = 'DOUBLE';
        else
            soft_strat_recommendation = 'HIT';
        end
        
    elseif (player_soft_total == 13)  
        if (dealer_first_card >= 5 && dealer_first_card <= 6)
            soft_strat_recommendation = 'DOUBLE';
        else
            soft_strat_recommendation = 'HIT';
        end
        
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACES:
function [adjusted_total, adjusted_hand, adjusted_display_hand] = adjust_aces(hand,card_values,display_hand)
    adjusted_hand = card_values(hand); % Converts raw hand to its value
    adjusted_display_hand = display_hand; % Initially, just pass through
    adjusted_total = sum(adjusted_hand); % Calculate initial total

    % Find any aces valued at 11 
    aces_as_eleven = find (adjusted_hand == 11);

    % Loop to adjust aces from 11 to 1 if total exceeds 21 
    while adjusted_total > 21 && ~isempty(aces_as_eleven)
        adjusted_hand(aces_as_eleven(1)) = 1; % Adjust the first found ace to 1 
        adjusted_total = sum(adjusted_hand); % Recalculate total 
        aces_as_eleven = find(adjusted_hand == 11); % Find any remaining aces valued at 11 
    end 
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CURRENT PLACE: 

% Double Down and Hit logic have been successfully coded for one round of
% play. Basic strategy recommendations are being offered with each
% additional card dealt to the player. Just added code for the dealer
% showdown, but we still have issues with things running after the game is
% supposed to end

% NEXT STEPS:

% Code in the card images and have them display during the DISPLAY INITIAL
% GAME VALUES and after each hit:
%   1. Use figure, imagesc, and subplot to get the card images where you
%   want them. Dealer should be easy until showdown because it'll just stay
%   as one face-up and one face-down.
%   2. Find a way to accomodate multiple hits. I have no idea what we're
%   going to do about splits (both gameplay and card image-wise)...

% Find a way to prevent Dealer Stands conditional from runnning after the
% dealer busts, and find a way for the game to end after the player busts
% (ie. the showdown conditionals don't run!)

% Maybe find a way to use a loop to limit the amount of repetitive
% copy-pasting needed for the hit logic and basic strategy calculations in
% subsequent rounds?
