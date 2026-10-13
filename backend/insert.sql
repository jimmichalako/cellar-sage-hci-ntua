USE HCI_db;

INSERT INTO users (username, passwd, firstname, surname, email)
VALUES 
('user1', 'password1', 'John', 'Doe', 'john.doe@example.com'),
('user2', 'password2', 'Jane', 'Doe', 'jane.doe@example.com'),
('Milfanikos', 'insane', 'Mhxanikos', 'mhxanikopoulos', 'mhx.anikos@makaronia.com'),
('Pol', 'Kr', 'Api', 'Enjoyer', 'polkr@pow.com');

INSERT INTO wines (wine_name, wine_info) VALUES
('Wine 1', 'Information about Wine 1'),
('Wine 2', 'Information about Wine 2'),
('Wine 3', 'Information about Wine 3'),
('Wine 4', 'Information about Wine 4'),
('Wine 5', 'Information about Wine 5'),
('Wine 6', 'Information about Wine 6'),
('Wine 7', 'Information about Wine 7'),
('Wine 8', 'Information about Wine 8');


INSERT INTO scans (username, wine_name, last_view)
VALUES 
('user1', 'Wine 1', NOW()),
('user1', 'Wine 2', NOW()),
('user1', 'Wine 3', NOW()),
('user1', 'Wine 4', NOW()),
('user2', 'Wine 5', NOW()),
('user2', 'Wine 7', NOW()),
('user2', 'Wine 8', NOW());

-- Insert reviews for user1
INSERT INTO reviews (review, username, wine_name, likes, score)
VALUES ('Review 1', 'user1', 'Wine 1', 3, 2),
       ('Review 2', 'user1', 'Wine 2', 6, 3),
       ('dsfgd', 'user2', 'Wine 2', 7, 3),
       ('Review 3', 'user1', 'Wine 3', 3, 4),
       ('Review 4', 'user1', 'Wine 4', 1, 5),
       ('Review 4.5', 'user1', 'Wine 4', 3, 5),
       ('Review 5', 'user1', 'Wine 5', 7, 1),
       ('papoutsi', 'Milfanikos', 'Wine 2', 0, 1),
       ('timio', 'Pol', 'Wine 2', 10, 5);


-- Insert reviews for user2
INSERT INTO reviews (review, username, wine_name, score)
VALUES ('Review 6', 'user2', 'Wine 1', 2),
       ('Review 7', 'user2', 'Wine 5', 2),
       ('Review 8', 'user2', 'Wine 3', 2);

INSERT INTO likedReviews (review_id, username)
VALUES (2, 'user1'),
       (5, 'user1'),
       (2, 'user2'),
       (1, 'user2'),
       (8, 'user2'),
       (4, 'user1'),
       (5, 'user2'),
       (3, 'user2');
