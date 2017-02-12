-- Search anywhere in the column
SELECT
  *
FROM person
WHERE firstname LIKE '%v%'

-- Search where skills begins with v
SELECT
  *
FROM person
WHERE firstname LIKE 'v%'

-- Search where skills ends with l
SELECT
  *
FROM person
WHERE firstname LIKE '%l'

--single wild-character underscore character
SELECT
  *
FROM person
WHERE firstname LIKE 'v_r%'