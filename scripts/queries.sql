-- 1. Select all players along with their country and prize money.
SELECT Full_Name, Country, Prize_Money
FROM tennis.Player;

-- 2. Find the players with the highest official points in the ATP rankings.
SELECT p.Full_Name, a.Official_Points
FROM tennis.Atp_Ranking a
         JOIN tennis.Player p ON a.Player_Id = p.Player_Id
ORDER BY a.Official_Points DESC
LIMIT 5;


-- 3. Get the average age of the players.
SELECT AVG(Age) AS average_age
FROM tennis.Player;


-- 4. Find the players who have won the most matches and display the number of matches won.
SELECT Full_Name, COUNT(*) AS Matches_Won
FROM tennis.Player p
         JOIN tennis.Match m ON p.Player_Id = m.Winner_Id
GROUP BY Full_Name
ORDER BY Matches_Won DESC;


-- 5. Retrieve the players and their total aces from the Player_Statistics table.
SELECT p.Full_Name, ps.Aces
FROM tennis.Player p
         JOIN tennis.Player_Statistics ps ON p.Player_Id = ps.Player_Id;


-- 6. Find the tournaments held on a specific surface.
SELECT *
FROM tennis.Tournament
WHERE Surface = 'Grass';


-- 7. Get the number of matches played in each tournament.
SELECT t.Tournament_Name, COUNT(*) AS Matches_Played
FROM tennis.Tournament t
         JOIN tennis.Match m ON t.Tournament_Id = m.Tournament_Id
GROUP BY t.Tournament_Name;


-- 8. Display the player's ranking history, including their ranking and the respective date range.
SELECT p.Full_Name, prh.Ranking, prh.From_Date, prh.Till_Date
FROM tennis.Player p
         JOIN tennis.Player_Ranking_History prh ON p.Player_Id = prh.Player_Id;


-- 9. Display matches, played on clay, where at least one of the players is at current top 5 atp
CREATE VIEW tennis.player_name_ranking AS
SELECT p.Player_Id, p.Full_Name, r.Ranking
FROM tennis.Player p
         JOIN tennis.atp_ranking r ON p.player_id = r.player_id;

SELECT *
FROM tennis.player_name_ranking;

CREATE VIEW tennis.match_on_clay AS
SELECT m.winner_id, m.other_id, t.tournament_name
FROM tennis.match m
         JOIN tennis.tournament t ON m.tournament_id = t.tournament_id
WHERE t.surface = 'Clay';

SELECT *
FROM tennis.match_on_clay;

SELECT winner.tournament_name, winner.Full_Name, winner.ranking, other.full_name, other.ranking
FROM (SELECT *
      FROM tennis.match_on_clay m
               JOIN tennis.player_name_ranking winner ON m.winner_id = winner.Player_Id) winner
         JOIN tennis.player_name_ranking other ON other_id = other.Player_Id
WHERE winner.ranking <= 5
   OR other.ranking <= 5
ORDER BY winner.ranking;

-- 10. Display all the players who have been number 1 and their current ranking and the periods with the gained money

-- We already have table of player_name_ranking
Select p.full_name, p.ranking, p.prize_money, h.from_date, h.till_date
FROM (SELECT p.player_id, p.full_name, r.ranking, p.prize_money
      FROM tennis.player p
               JOIN tennis.atp_ranking r ON p.player_id = r.player_id) p
         JOIN tennis.player_ranking_history h ON p.player_id = h.player_id
WHERE h.ranking = 1;
