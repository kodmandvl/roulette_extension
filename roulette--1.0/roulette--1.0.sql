-- begin of file --
\echo Use "CREATE EXTENSION roulette" to load this file. \quit
/* ========= My function: ========= */
CREATE OR REPLACE FUNCTION ROULETTE (P_MAX INTEGER DEFAULT 36, P_BET INTEGER DEFAULT 7) RETURNS TEXT AS
$$
SELECT CASE
WHEN CEIL(RANDOM()*P_MAX)=P_BET THEN 'VICTORY! YOU ARE LUCKY! FROM 1 TO '||P_MAX||' YOU GET YOUR NUMBER '||P_BET||'!'
ELSE 'Failure... You lost... From 1 to '||P_MAX||' your number '||P_BET||' did not come up...'
END
$$ LANGUAGE SQL;
COMMENT ON FUNCTION ROULETTE (P_MAX INTEGER, P_BET INTEGER) IS 'This is roulette game with random function inside';
-- end of file --
