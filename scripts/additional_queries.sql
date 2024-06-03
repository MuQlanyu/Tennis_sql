---------------------------------------------
--------------- Представления ---------------
---------------------------------------------

-- Имя игроков, id и их текущий ранг

CREATE VIEW tennis.player_name_ranking AS
SELECT p.Player_Id, p.Full_Name, r.Ranking
FROM tennis.Player p
         JOIN tennis.atp_ranking r ON p.player_id = r.player_id;

-- Id матча и турнира, а также id победителя и другого участника

CREATE VIEW tennis.match_tournament AS
SELECT m.match_id        as match_id,
       t.tournament_id   as tournament_id,
       m.winner_id       as winner,
       m.other_id        as loser,
       t.tournament_name as tournament_name
FROM tennis.match m
         JOIN tennis.tournament t ON m.tournament_id = t.tournament_id;

---------------------------------------
--------------- Индексы ---------------
---------------------------------------

create index idx_players_by_age on tennis.player (age);

create index idx_tournament_by_surface on tennis.tournament using hash (surface);

create index idx_players_by_ranking on tennis.atp_ranking (ranking);

create index idx_history_by_id on tennis.player_ranking_history using hash (player_id);

create index idx_match_statistics_by_duration on tennis.match_statistics (duration);


---------------------------------------------------
--------------- Процедуры и функции ---------------
---------------------------------------------------

-- Добавление фиксированного числа очяков points в турнир id для мест с place_start по place_end
create procedure insert_array_points_for_tournament(id int, points int, place_start int, place_end int)
language plpgsql as $$
begin
    for place in place_start .. place_end loop
        insert into tennis.official_points(tournament_id, place, official_points)
        values (id, place, points);
    end loop;
end;
$$;


-- Запись, что игрок pl_id занял pl_place место на турнире tour_id, а также добавление очков в итоговый рейтинг
create procedure add_official_points(pl_id int, tour_id int, pl_place int)
language plpgsql as $$
begin
    -- добавляем занимаемое место
    update tennis.official_points set player_id = pl_id where tournament_id = tour_id and place = pl_place;
    -- добавляем очки в итоговую таблицу с помощью триггера
    -- **Отработал тригер** --

    -- Обновляем ранги
    with new_ranking as (
        select player_id, row_number() over (order by official_points desc) as rank
        from tennis.atp_ranking
    )

    update tennis.atp_ranking r set ranking = nr.rank from new_ranking as nr where r.player_id = nr.player_id;
end;
$$;

-- Заполнение таблицы матчей для некоторго турнира tour_id массивами winner_id,
-- other_id (winner_id[j] и other_id[j] играли вместе)
create procedure set_matches(tour_id int, winner int array, other int array)
language plpgsql as $$
begin
    if cardinality(winner) = cardinality(other) then
        for j in 1 .. cardinality(winner) loop
            insert into tennis.match (tournament_id, winner_id, other_id)
            values (tour_id, winner[j], other[j]);
        end loop;
    end if;
end;
$$;


---------------------------------------
--------------- Тригеры ---------------
---------------------------------------

-- Если поменяется место в рейтинге, то занести его в историю
create function put_to_history() returns trigger as $$
declare
    pl_id int = old.player_id;
begin
    insert into tennis.player_ranking_history (player_id, ranking, from_date, till_date)
    values (pl_id,
            old.ranking,
            (select max(till_date) from tennis.player_ranking_history where player_id = pl_id),
            current_date);
    return new;
end;
$$ language plpgsql;

create trigger update_history
    after update on tennis.atp_ranking
    for each row
    when (old.ranking != new.ranking)
    execute function put_to_history();


-- Вычитание очков у игрока при удалении записи из tennis.official_points
create function decrease_points() returns trigger as $$
begin
    if old.player_id is not null then
        update tennis.atp_ranking set official_points = official_points - old.official_points
        where player_id = old.player_id;

        -- Обновляем ранги
        with new_ranking as (
            select player_id, row_number() over (order by official_points desc) as rank
            from tennis.atp_ranking
        )

        update tennis.atp_ranking r set ranking = nr.rank from new_ranking as nr where r.player_id = nr.player_id;
        return new;
    end if;
    return new;
end;
$$ language plpgsql;

create trigger decrease_points_ranking
    after delete on tennis.official_points
    for each row
    execute function decrease_points();


-- Обновления очков в tennis.atp_ranking при добавлении человека в official_points
create function add_points() returns trigger as $$
begin
    update tennis.atp_ranking set official_points = official_points + new.official_points
    where player_id = new.player_id;

    -- Обновляем ранги
    with new_ranking as (
        select player_id, row_number() over (order by official_points desc) as rank
        from tennis.atp_ranking
    )

    update tennis.atp_ranking r set ranking = nr.rank from new_ranking as nr where r.player_id = nr.player_id;
    return new;
end;
$$ language plpgsql;

create trigger add_points_ranking
    after update on tennis.official_points
    for each row
    when (old.player_id is null and new.player_id is not null)
    execute function add_points();
