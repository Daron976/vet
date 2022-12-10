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

-- JOIN queries owners

SELECT owners.id, owners.full_name, animals.id, animals.name
FROM owners
JOIN animals
ON owners.id = owner_id
WHERE owners.full_name = 'Melody Pond';

SELECT owners.id, owners.full_name, animals.id, animals.name
FROM owners
FULL JOIN animals
ON owners.id = owner_id;

-- JOIN queries species

SELECT species.id, species.name, animals.id, animals.name, COUNT()
FROM species
JOIN animals
ON species.id = species_id
WHERE species.name = 'Pokemon';

SELECT COUNT(animals.name)
FROM animals
JOIN species
ON species_id = species.id
WHERE species.name = 'Pokemon';

SELECT COUNT(animals.name)
FROM animals
JOIN species
ON species_id = species.id
WHERE species.name = 'Digimon';

SELECT owners.id, full_name, animals.id, animals.name, species.id, species.name
FROM animals
JOIN owners
ON owner_id = owners.id
JOIN species
ON species_id = species.id
WHERE species.name = 'Digimon' AND full_name = 'Jennifer Orwell';

SELECT owners.id, full_name, animals.id, animals.name, escape_attempts
FROM animals
JOIN owners
ON owner_id = owners.id
WHERE full_name = 'Dean Winchester' AND escape_attempts IS NULL;

SELECT full_name, COUNT(animals.name)
FROM animals
JOIN owners
ON owner_id = owners.id
GROUP BY full_name
ORDER BY COUNT DESC
LIMIT 1;

-- JOIN queries with many to many relationships

SELECT vets.name, date_of_visit, animals.name
FROM vets
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
WHERE vets.name = 'William Tatcher'
ORDER BY date_of_visit DESC
LIMIT 1;

SELECT vets.name, COUNT(animals.name)
FROM vets
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
JOIN species
ON animals.species_id = species.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

SELECT vets.name, species.name
FROM vets
FULL JOIN specializations
ON vets.id = specializations.vets_id
FULL JOIN species
ON specializations.species_id = species.id;

SELECT vets.name, animals.name, date_of_visit
FROM vets
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
JOIN species
ON animals.species_id = species.id
WHERE vets.name = 'Stephanie Mendez' AND date_of_visit > 'Apr 1, 2020' AND date_of_visit < 'Aug 30, 2020';

SELECT animals.name, COUNT(animals.name)
FROM vets
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY COUNT DESC
LIMIT 1;

SELECT vets.name, animals.name, date_of_visit
FROM vets
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY date_of_visit ASC 
LIMIT 1;

SELECT vets.name vet, species.name speciality, date_of_graduation, animals.name animal, species.name species, date_of_birth, date_of_visit
FROM vets
FULL JOIN specializations
ON vets.id = specializations.vets_id
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
JOIN species
ON animals.species_id = species.id
ORDER BY date_of_visit DESC
LIMIT 1;

SELECT vets.name, COUNT(date_of_visit)
FROM vets
FULL JOIN specializations
ON vets.id = specializations.vets_id
FULL JOIN species
ON specializations.species_id = species.id
JOIN visits
ON vets.id = visits.vets_id
WHERE species.name IS NULL
GROUP BY vets.name;

SELECT species.name species, COUNT(species) number
FROM vets
JOIN visits
ON vets.id = visits.vets_id
JOIN animals
ON visits.animal_id = animals.id
JOIN species
ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species
ORDER BY number DESC
LIMIT 1;