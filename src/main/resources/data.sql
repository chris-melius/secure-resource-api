-- No need for 'USE resource_db' here; Spring is already connected to it
INSERT IGNORE INTO employee (id, name)
VALUES (1, 'John Doe');

INSERT IGNORE INTO employee (id, name)
VALUES (2, 'Jane Doe');