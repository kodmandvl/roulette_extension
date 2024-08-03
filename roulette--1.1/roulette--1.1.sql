-- begin of file --
\echo Пожалуйста, используйте команду "CREATE EXTENSION roulette" для загрузки этого файла. \quit
COMMENT ON EXTENSION roulette IS 'Это игра в рулетку и в магический шар с ответами';
/* ========= Моя функция "Рулетка": ========= */
CREATE OR REPLACE FUNCTION ROULETTE (P_MAX INTEGER DEFAULT 36, P_BET INTEGER DEFAULT 7) RETURNS TEXT AS
$$
SELECT CASE
WHEN CEIL(RANDOM()*P_MAX)=P_BET THEN 'VICTORY! YOU ARE LUCKY! FROM 1 TO '||P_MAX||' YOU GET YOUR NUMBER '||P_BET||'!'
ELSE 'Failure... You lost... From 1 to '||P_MAX||' your number '||P_BET||' did not come up...'
END
$$ LANGUAGE SQL;
COMMENT ON FUNCTION ROULETTE (P_MAX INTEGER, P_BET INTEGER) IS 'Это игра в рулетку с функцией random внутри';
/* ========= Моя функция "Магический шар с ответами": ========= */
CREATE OR REPLACE FUNCTION MAGICBALL (P_QUESTION TEXT DEFAULT 'Yes or no?') RETURNS TEXT AS 
$$ 
SELECT CASE 
WHEN CEIL(RANDOM()*20)=20 THEN 'Это бесспорно!'
WHEN CEIL(RANDOM()*20)=19 THEN 'Это предрешено!'
WHEN CEIL(RANDOM()*20)=18 THEN 'Никаких сомнений!'
WHEN CEIL(RANDOM()*20)=17 THEN 'Определённо да!'
WHEN CEIL(RANDOM()*20)=16 THEN 'Можешь быть уверен в этом!'
WHEN CEIL(RANDOM()*20)=15 THEN 'Я думаю, да.'
WHEN CEIL(RANDOM()*20)=14 THEN 'Вероятнее всего.'
WHEN CEIL(RANDOM()*20)=13 THEN 'Хорошие перспективы'
WHEN CEIL(RANDOM()*20)=12 THEN 'Звёзды подсказывают, что да.'
WHEN CEIL(RANDOM()*20)=11 THEN 'Да.'
WHEN CEIL(RANDOM()*20)=10 THEN 'Пока не ясно, попробуй еще разок.'
WHEN CEIL(RANDOM()*20)=9 THEN 'Спроси меня позже.'
WHEN CEIL(RANDOM()*20)=8 THEN 'Пожалуй, не смогу ответить тебе сейчас.'
WHEN CEIL(RANDOM()*20)=7 THEN 'Сейчас нельзя предсказать.'
WHEN CEIL(RANDOM()*20)=6 THEN 'Сконцентрируйся и спроси опять.'
WHEN CEIL(RANDOM()*20)=5 THEN 'Весьма сомнительно.'
WHEN CEIL(RANDOM()*20)=4 THEN 'Перспективы не очень хорошие.'
WHEN CEIL(RANDOM()*20)=3 THEN 'По моим данным, нет.'
WHEN CEIL(RANDOM()*20)=2 THEN 'Мой ответ - нет!'
WHEN CEIL(RANDOM()*20)=1 THEN 'Даже не думай!'
ELSE 'Даже не думай!' 
END 
$$ LANGUAGE SQL; 
COMMENT ON FUNCTION MAGICBALL (P_QUESTION TEXT) IS 'Это игра в магический шар с ответами';
-- end of file --
