SELECT *
FROM animals
WHERE name LIKE '%mon';

SELECT (name)
FROM animals
WHERE date_of_birth BETWEEN 'Jan 1, 2016' AND 'Dec 31, 2019';

SELECT (name)
FROM animals
WHERE neutered = true AND escape_attempts < 3;

SELECT (date_of_birth)
FROM animals
WHERE name = 'Agumon' OR name = 'Pikachu';

SELECT (name, escape_attempts)
FROM animals
WHERE weight_kg > 10.5;

SELECT *
FROM animals
WHERE neutered = true;

SELECT *
FROM animals
WHERE name <> 'Gabumon';

SELECT *
FROM animals
WHERE weight_kg > 10.4 AND weight_kg < 17.3;

-- transactions

BEGIN;

UPDATE animals
  SET species = 'unspecified';

ROLLBACK;

BEGIN;

UPDATE animals
  SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
  SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;

BEGIN;

DELETE FROM animals;

ROLLBACK;

BEGIN;

DELETE FROM animals
WHERE date_of_birth > 'Jan 1, 2022';

SAVEPOINT sp1;

UPDATE animals
  SET weight_kg = weight_kg * -1;

ROLLBACK TO sp1;

BEGIN;

UPDATE animals
  SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

-- aggregate functions

SELECT COUNT(name) FROM animals;

SELECT COUNT(name) FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT name
FROM animals
WHERE escape_attempts = (SELECT MAX(escape_attempts) FROM animals);

SELECT species, MAX(weight_kg), MIN(weight_kg)
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth > 'Jan 1, 1990' AND date_of_birth < 'Dec 31, 2000'
GROUP BY species;