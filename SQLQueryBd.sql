/*Consulta para obtener todos los libros de un autor específico. Para esto, deberá
declarar una variable asociada al autor 
*/

/* 
	Declarar
*/


DECLARE @autorId INT;
SET @autorId = 1;

/* 
	Consulta para obtener todos los libros del autor especificado
*/


SELECT l.id, l.titulo, a.nombre AS autor, e.nombre AS editorial, c.nombre AS categoria, l.fechaPublicacion
FROM Libros l
INNER JOIN Autores a ON l.autorId = a.id
INNER JOIN Editoriales e ON l.editorialId = e.id
INNER JOIN Categorias c ON l.categoriaId = c.id
WHERE l.autorId = @autorId;

/* 
	Consulta para obtener todos los libros de una categoría determinada. Para esto,
deberá declarar una variable asociada a la categoría
*/


/* 
	Declarar
*/

DECLARE @categoriaId INT;
SET @categoriaId = 3; 
/* 
	Consulta para obtener todos los libros de la categoría especificada
*/

SELECT l.id, l.titulo, a.nombre AS autor, e.nombre AS editorial, c.nombre AS categoria, l.fechaPublicacion
FROM Libros l
INNER JOIN Autores a ON l.autorId = a.id
INNER JOIN Editoriales e ON l.editorialId = e.id
INNER JOIN Categorias c ON l.categoriaId = c.id
WHERE l.categoriaId = @categoriaId;

/* 
	Consulta para obtener todos los libros de Gabriel García Márquez, y que hayan
sido publicados después de 1970.
*/

SELECT l.id, l.titulo, a.nombre AS autor, e.nombre AS editorial, c.nombre AS categoria, l.fechaPublicacion
FROM Libros l
INNER JOIN Autores a ON l.autorId = a.id
INNER JOIN Editoriales e ON l.editorialId = e.id
INNER JOIN Categorias c ON l.categoriaId = c.id
WHERE a.nombre = 'Gabriel García Márquez' 
AND l.fechaPublicacion > '1970-01-01';


/* Consulta para obtener todos los libros de la categoría Terror y publicados después
de 1976.

*/

SELECT l.id, l.titulo, a.nombre AS autor, e.nombre AS editorial, c.nombre AS categoria, l.fechaPublicacion
FROM Libros l
INNER JOIN Autores a ON l.autorId = a.id
INNER JOIN Editoriales e ON l.editorialId = e.id
INNER JOIN Categorias c ON l.categoriaId = c.id
WHERE c.nombre = 'Terror' 
AND l.fechaPublicacion > '1976-01-01';

/* 
Consulta para obtener todos los libros cuyo título contenga la palabra Harry.
*/

SELECT id, titulo, autorId, editorialId, categoriaId, fechaPublicacion, disponibilidad
FROM Libros
WHERE titulo LIKE '%Harry%';

/* 
Crea un procedimiento almacenado que calcule la cantidad de libros publicados por
una editorial específica. El procedimiento debe tomar el nombre de la editorial como
parámetro de entrada y devolver el número total de libros publicados por esa
editorial
*/

CREATE PROCEDURE CalcularCantidadLibrosPorEditorial
    @nombre_editorial VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @editorial_id INT;

    -- Obtener el ID de la editorial basado en el nombre proporcionado
    SELECT @editorial_id = id
    FROM Editoriales
    WHERE nombre = @nombre_editorial;

    -- Calcular la cantidad de libros publicados por la editorial
    SELECT COUNT(*) AS cantidad_libros
    FROM Libros
    WHERE editorialId = @editorial_id;
END;

EXEC CalcularCantidadLibrosPorEditorial @nombre_editorial = 'Nombre de la Editorial';

/* 
Crea un procedimiento almacenado que devuelva la lista de los libros más recientes
por categoría. El procedimiento debe tomar la categoría como parámetro de entrada
y devolver una lista de libros ordenados por fecha de publicación, de manera que se
muestre el libro más reciente de cada categoría
*/

CREATE PROCEDURE ObtenerLibrosMasRecientesPorCategoria
    @nombre_categoria VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener el ID de la categoría basado en el nombre proporcionado
    DECLARE @categoria_id INT;
    SELECT @categoria_id = id FROM Categorias WHERE nombre = @nombre_categoria;

    -- Obtener la lista de libros más recientes por categoría
    WITH LibrosPorCategoria AS (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY categoriaId ORDER BY fechaPublicacion DESC) AS Ranking
        FROM Libros
        WHERE categoriaId = @categoria_id
    )
    SELECT id, titulo, autorId, editorialId, categoriaId, fechaPublicacion, disponibilidad
    FROM LibrosPorCategoria
    WHERE Ranking = 1;
END;

EXEC ObtenerLibrosMasRecientesPorCategoria @nombre_categoria = 'Nombre de la Categoría';

