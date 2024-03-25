![](https://github.com/connoryew/CLPS0950_2024/blob/main/CLPS0950%20Blackjack%20GIF.gif)
**Group Members**: Nicole Chen, Jilienne Widener, Connor Yew

**Project Proposal**: For our CLPS0950 Group Project, we will be creating a program that presents the user with a simulated game of BlackJack and allows them to input their desired actions (i.e., hold, stay, double-down, and surrender) that they would like to take to beat the dealer and win the round. Additionally, we will be coding another program that provides text recommendations for which actions the player should take on each hand based on the principles of "Basic Strategy." These recommendations help to limit the casino's edge over a player to < 1% when properly implemented, and they can be found in a table format at the following link: https://www.blackjackapprenticeship.com/blackjack-strategy-charts/

**Rules of BlackJack**

1. *CARD VALUES*:
Cards 2-10 have a value equal to their face value. J, Q, and K each have a value of 10. Aces can be worth either 1 or 11 based off of which would bring the player closer to 21 without going over.
2. Each round begins with both the dealer and the player receiving two cards. The player knows the value of both of their own cards, but only knows the value of one of the dealer's cards.
3. If the player is dealt an Ace AND a Value-10 Card (10, J, Q, or K), they have a *BlackJack*, and they automatically win the round as long as the dealer does not ALSO have a *BlackJack*
4. Players can either SURRENDER (fold their intial hand w/o getting any additional cards), HIT (take another card), STAND (keep their current cards), or DOUBLE DOWN (double their initial bet, take one more card, then stand)
5. Once the player has decided to STAND on all available hands, the  dealer reveals their hidden card
6. If either the dealer or the player obtains a series of cards that have a combined value > 21, they have "busted" and lost the round.
7. If both player and dealer have NOT busted, whoever is closer to 21 w/o going over has won the round
8. If the player and dealer have NOT busted AND they have cards that sum up to the same value, the result is a PUSH, where neither party wins the round.

**Contributions**
We completed a majority of this project while working together, so it's difficult to attribute entire sections of code to a specific person. In general, Niki worked a lot on the Hit/Stand/Double/Surrender code, Jilienne put together most of the Soft Total Recommendations and Ace Recalculation code, and Connor did a lot of the debugging and helped with the Game Setup and Hard Total Recommendation sections. During our work sessions, especially near the end of the project, we usually just spent time running sections of the code to try to find errors or incorrect game outcomes and then went in and debugged. Please feel free to reach out to any of us if you have any specific questions about each member's contributions to this project
