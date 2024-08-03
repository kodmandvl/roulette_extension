# МОЕ ТЕСТОВО-УЧЕБНОЕ РАСШИРЕНИЕ "РУЛЕТКА" ДЛЯ POSTGRESQL

Для проверки этого учебного примера можно использовать [мой docker-образ для PostgreSQL](https://hub.docker.com/r/kodmandvl/postgres/tags), например, kodmandvl/postgres:13

## ФАЙЛ roulette.control:

```conf
## begin of file ##
# Roulette extension!
comment = 'PostgreSQL extension for roulette game'
default_version = '1.0'
relocatable = true
#requires = 'some extension(s)'
superuser = false
## end of file ##
```

## ФАЙЛ roulette--1.0.sql:

```sql
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
```

## СОБЕРЕМ ЭТИ ДВА ФАЙЛА В АРХИВ ДЛЯ УДОБНОЙ ПОСТАВКИ РАСШИРЕНИЯ:

```bash
chmod -v 644 roulette*
tar -czvf roulette--1.0.tar.gz roulette.control roulette--1.0.sql
```

## УСТАНАВЛИВАЕМ НАШЕ ВООБРАЖАЕМОЕ РАСШИРЕНИЕ ИЗ АРХИВА ВЕРСИИ 1.0:

```bash
# Идем в каталог с архивом и затем:
echo $PATH
which pg_config
pg_config --version
pg_config --sharedir
ls -alF $(pg_config --sharedir)/extension/
ls -alF $(pg_config --sharedir)/extension/ | grep roulette
sudo tar xzvf roulette--1.0.tar.gz --directory $(pg_config --sharedir)/extension
ls -alF $(pg_config --sharedir)/extension/ | grep roulette
```

## Запросы:

```sql
select * from pg_available_extensions where name='roulette';
select * from pg_available_extension_versions where name='roulette';
-- Create extension:
CREATE EXTENSION roulette;
\dx
-- или:
-- CREATE EXTENSION roulette schema имя_схемы;
-- Examples:
SELECT ROULETTE();
SELECT ROULETTE(10);
SELECT ROULETTE(10,5);
```

## Создание новой версии нашего расширения с описанием на русском языке и с добавлением еще одной функции:

```bash
# Добавляем в файл control параметр encoding:
cat $(pg_config --sharedir)/extension/roulette.control
sudo su -c "echo 'encoding = UTF8' >> $(pg_config --sharedir)/extension/roulette.control"
cat $(pg_config --sharedir)/extension/roulette.control
# Создаем файлик sql для новой версии:
sudo su -c "cp -aiv $(pg_config --sharedir)/extension/roulette--1.0.sql $(pg_config --sharedir)/extension/roulette--1.1.sql"
# Меняем комментарии на русскоязычные и добавляем еще одну функцию:
sudo vi $(pg_config --sharedir)/extension/roulette--1.1.sql
```

## Содержимое файла roulette--1.1.sql:

```sql
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
```

## Чтобы не было ошибки при попытке обновления расширения, для корректного апгрейда и даунгрейда расширения нужно сделать сооответствующие файлы sql (сделаем такие же, как и файлы для версий 1.1 и 1.0, но в даунгрейде еще удалим новую функцию):

```bash
sudo su -c "cp -aiv $(pg_config --sharedir)/extension/roulette--1.1.sql $(pg_config --sharedir)/extension/roulette--1.0--1.1.sql"
sudo su -c "cp -aiv $(pg_config --sharedir)/extension/roulette--1.0.sql $(pg_config --sharedir)/extension/roulette--1.1--1.0.sql"
# Добавим удаление функции MAGICBALL в файл roulette--1.1--1.0.sql:
sudo su -c "echo 'DROP FUNCTION IF EXISTS MAGICBALL;' >> $(pg_config --sharedir)/extension/roulette--1.1--1.0.sql"
cat $(pg_config --sharedir)/extension/roulette--1.1--1.0.sql
# Еще можно поменять дефолтную версию в файле roulette.control с 1.0 на 1.1 для удобства и коммент подредактировать:
sudo vi $(pg_config --sharedir)/extension/roulette.control
```

## Содержимое файла roulette.control теперь:

```conf
## begin of file ##
# Roulette extension
comment = 'Расширение для игры в рулетку и в магический шар с функцией random внутри'
default_version = '1.1'
relocatable = true
#requires = 'some extension(s)'
superuser = false
encoding = UTF8
## end of file ##
```

## Список файлов, относящихся к расширению (версии 1.1):

```
$ ls -1 $(pg_config --sharedir)/extension/roulette*
/usr/local/pgsql/share/extension/roulette--1.0--1.1.sql
/usr/local/pgsql/share/extension/roulette--1.0.sql
/usr/local/pgsql/share/extension/roulette--1.1--1.0.sql
/usr/local/pgsql/share/extension/roulette--1.1.sql
/usr/local/pgsql/share/extension/roulette.control
```

## Скопируем их и соберем в архив новой версии:

```bash
mkdir roulette--1.1
cd roulette--1.1/
cp -aiv $(pg_config --sharedir)/extension/roulette* ./
chmod -v 644 roulette*
tar -czvf roulette--1.1.tar.gz roulette.control roulette*.sql
ls -1 roulette*
```

## УСТАНАВЛИВАЕМ НАШЕ ВООБРАЖАЕМОЕ РАСШИРЕНИЕ ИЗ АРХИВА НОВОЙ ВЕРСИИ 1.1:

(например, если еще не устанавливали первую ваерсию и не редактировали файлы, как в примере выше)

```bash
# Идем в каталог с архивом и затем:
echo $PATH
which pg_config
pg_config --version
pg_config --sharedir
ls -alF $(pg_config --sharedir)/extension/
ls -alF $(pg_config --sharedir)/extension/ | grep roulette
sudo tar xzvf roulette--1.1.tar.gz --directory $(pg_config --sharedir)/extension
ls -alF $(pg_config --sharedir)/extension/ | grep roulette
```

## Запросы:

```sql
select * from pg_available_extensions where name='roulette';
select * from pg_available_extension_versions where name='roulette';
select pg_extension_update_paths('roulette');
-- Теперь можно проверять:
SELECT MAGICBALL(); -- пока еще функции нет
\dx roulette
ALTER EXTENSION ROULETTE UPDATE TO "1.1";
\dx roulette
SELECT MAGICBALL(); -- теперь функция есть
ALTER EXTENSION ROULETTE UPDATE TO "1.0";
\dx roulette
SELECT MAGICBALL(); -- теперь функции снова нет
ALTER EXTENSION ROULETTE UPDATE;
\dx roulette
SELECT MAGICBALL(); -- теперь версия 1.1 и снова есть фнукция
-- Посмотрим пересоздание:
\dx roulette
DROP EXTENSION ROULETTE;
CREATE EXTENSION ROULETTE;
\dx roulette
SELECT MAGICBALL();
SELECT ROULETTE();
-- Пересоздание расширения (со старой версией и обновление):
DROP EXTENSION ROULETTE;
CREATE EXTENSION ROULETTE VERSION '1.0';
\dx roulette
ALTER EXTENSION ROULETTE UPDATE;
\dx roulette
```